import json
import urllib.parse
import boto3
import cv2
import numpy as np
import copy

#Constants for tuning AI
MIN_SIZE = 250
MAX_SIZE = 5000
MAX_SIDE_ERROR = 2
MAX_SIZE_ERROR = 100
MAX_COLOR_ERROR = 150

#Dictionary of pills that maps names to details
pillDict = {"Type1": 
            {
			"Name": "Type1",
			"Size": 1130,
			"Shape": "Ellipse",
			"Color": [200, 200, 200, 0]
		    }
        }

#Connect to S3 service
s3 = boto3.client('s3')

#Get average color of pill by looking at a 10x10 pixel box and finding the mean
def getColor(image, centroid):
    temp_crop = image[int(centroid[1]-5):int(centroid[1]+5), int(centroid[0]-5):int(centroid[0]+5)]
    color = cv2.mean(temp_crop)
    print(list(color))
    return list(color)

#Quick and dirty shape detection for pills, since they have limited shapes
#Improved version of this could use boundaries of contour
def getShape(stat):
    width = stat[cv2.CC_STAT_WIDTH]
    height = stat[cv2.CC_STAT_HEIGHT]
    print(width)
    print(height)

    if abs(width-height) <= MAX_SIDE_ERROR:
        shape = "Circle"
    else:
        shape = "Ellipse"
    print(shape)
    return shape

#Compare object shape, size, and color to references
def identifyObjects(objectList, referenceList):
    identifiedObjects = []
    unidentifiedObjects = []
    unidentified = True
    for o in objectList:
        unidentified = True
        for ref in referenceList:
            if o["Shape"] == ref["Shape"]:
                if abs(o["Size"]-ref["Size"]) <= MAX_SIZE_ERROR:
                    if np.linalg.norm(np.array(o["Color"])-ref["Color"]) <= MAX_COLOR_ERROR:
                        if "ReleaseTime" in ref.keys():
                            o["ReleaseTime"] = ref["ReleaseTime"]
                        o["Name"] = ref["Name"]
                        identifiedObjects.append(o)
                        referenceList.remove(ref)
                        unidentified = False
                        break
        if unidentified:
            unidentifiedObjects.append(o)
    return identifiedObjects, unidentifiedObjects

#Add timestamps for release and removal to pills
def addTimestamps(identifiedObjects, ref_pills, timestamp):
    for pill in identifiedObjects:
        if "ReleaseTime" not in pill.keys():
            pill["ReleaseTime"] = timestamp
    
    for pill in ref_pills:
        if "RemovalTime" not in pill.keys():
            pill["RemovalTime"] = timestamp
        
    return identifiedObjects + ref_pills

#Generate updated info for current.json    
def updateCurrentPills(pillsList):
    outputPills = []
    for p in pillsList:
        if "RemovalTime" not in p.keys():
            outputPills.append(p)
    return outputPills

#Generate new addition to append to aiOutput.json
def createAiJsonEntry(filename, timestamp, pillsList, unidentifiedObjects, status, notes, lastP):
    releasedPills = [""]
    for p in pillsList:
        if "ReleaseTime" in p.keys():
            if p["ReleaseTime"] == timestamp:
                releasedPills.append(p["Name"])
    
    removedPills = [""]
    for p in pillsList:
        if "RemovalTime" in p.keys():
            if p["RemovalTime"] == timestamp:
                removedPills.append(p["Name"])
        
    output = {
        "filename": filename,
        "timestamp": timestamp,
        "status": status,
        "notes": notes,
        "lastPill": lastP,
        "unidentifiedObjects": len(unidentifiedObjects),
        "pillsReleased": releasedPills,
        "pillsRemoved": removedPills
    }
    
    return output

#Get pill info from pillDict using name from device.json   
def getPillData(pillName):
    if pillName in pillDict.keys():
        pillType = pillDict[pillName]
        outputPill = copy.deepcopy(pillType)
        return outputPill
    return None

#This gets called when the lambda function is triggered, essentially the 'main' function
def lambda_handler(event, context):
    # Get the object from the event
    bucket = event['Records'][0]['s3']['bucket']['name']
    input_key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    image_filename = input_key.replace('images/', '')
    timestamp = input_key[input_key.find("_")+1:-4]
    input_filename = '/tmp/input.jpg'
    output_filename = '/tmp/output.jpg'
    output_key = input_key.replace('images/', 'public/')
    
    device_json_key = 'public/device.json'
    device_json_filename = '/tmp/device-out.json'
    
    reference_pills_key = 'public/current.json'
    reference_filename = '/tmp/reference.json'
    
    ai_json_key = 'public/aiOutput.json'
    ai_json_filename = '/tmp/ai-out.json'
    ai_json = []
    
    #Get deviceOutput JSON
    try:
        s3.download_file(bucket, device_json_key, device_json_filename)
        
    except Exception as e:
        print(e)
        print('Error getting device output JSON. Please make sure it exists.')
        raise e
    
    #Get currentPills JSON
    try:
        s3.download_file(bucket, reference_pills_key, reference_filename)
        
    except Exception as e:
        print(e)
        print('Error getting reference list. Please make sure it exists.')
        raise e

    #Open device.json and verify filename
    device_json = {}
    with open(device_json_filename) as infile:
        device_json = json.load(infile)[0]
        print(device_json)
        if device_json["lastImg"] != image_filename:
            print("Warning: Mismatch between image name and device output JSON")

    #Open current.json and verify image wasn't already processed
    output_pills = {}
    with open(reference_filename) as infile:
        output_pills = json.load(infile)
        print(output_pills)
        if output_pills["lastImage"] == image_filename:
            print("Error: Image already processed")
            return

    #Populate reference_pills with current pills and released pill    
    reference_pills = output_pills['currentPills']
    lastPill = getPillData(device_json['lastPill'])
    if lastPill != None:
        reference_pills.append(lastPill)
    print(reference_pills)
    
    #Get aiOutput JSON
    try:
        s3.download_file(bucket, ai_json_key, ai_json_filename)
        with open(ai_json_filename) as infile:
            ai_json = json.load(infile)
        
    except Exception as e:
        print(e)
        print('Error getting AI output JSON. Creating a new one...')
        #raise e
    
    #Get input image
    try:
        s3.download_file(bucket, input_key, input_filename)
        
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(input_key, bucket))
        raise e

    #Read image and apply edge detection and filling
    image = cv2.imread(input_filename)
    grayscale = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blurred = cv2.GaussianBlur(grayscale, (5, 5), 0)
    edges = cv2.Canny(blurred, 10, 150)
    binarized = cv2.threshold(edges, 100, 255, cv2.THRESH_BINARY)
    contour, hier = cv2.findContours(edges, cv2.RETR_CCOMP, cv2.CHAIN_APPROX_SIMPLE)
        
    for cnt in contour:
        cv2.drawContours(edges, [cnt], 0, 255, -1)

    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2,2))
    filtered_contours = cv2.erode(edges, kernel)

    #Count objects in image
    particles = cv2.connectedComponentsWithStats(filtered_contours)
    stats = particles[2]
    centroids = particles[3]
    object_data = []

    #Filter objects and append them to object_data with formatted stats
    for index in range(len(stats)):
        stat = stats[index]
        centroid = centroids[index]
        size = int(stat[cv2.CC_STAT_AREA])
        if MIN_SIZE <= size <= MAX_SIZE:
            color = getColor(image, centroid)
            shape = getShape(stat)
            topLeft = (int(stat[cv2.CC_STAT_LEFT]), int(stat[cv2.CC_STAT_TOP]))
            bottomRight = (topLeft[0]+int(stat[cv2.CC_STAT_WIDTH]), topLeft[1]+int(stat[cv2.CC_STAT_HEIGHT]))
            object_data.append({"Size": size, "Shape": shape,"Color": color, "Dimensions": (topLeft, bottomRight)})

    #Compare objects to reference_pills
    identifiedObjects, unidentifiedObjects = identifyObjects(object_data, reference_pills)

    #Outline identified pills in green
    for item in identifiedObjects:
        cv2.rectangle(image, item["Dimensions"][0], item["Dimensions"][1], (0, 255, 0), 1)

    #Outline unidentified objects in red
    for item in unidentifiedObjects:
        cv2.rectangle(image, item["Dimensions"][0], item["Dimensions"][1], (0, 0, 255), 1)

    #Save updated image    
    cv2.imwrite(output_filename, image)
    
    #Upload marked image to public folder in 'storagebucket20402-dev'        
    try:
        s3.upload_file(output_filename, bucket, output_key, ExtraArgs={'ACL': 'public-read'})
        
    except Exception as e:
        print(e)
        print('Error putting object {} into bucket {}.'.format(output_key, bucket))
        raise e
    
    #Create updated currentPills
    timestamped_pills = addTimestamps(identifiedObjects, reference_pills, timestamp)
    
    for pill in timestamped_pills:
        if "Dimensions" in pill.keys():
            pill.pop("Dimensions")
    output_pills["currentPills"] = updateCurrentPills(timestamped_pills)
    output_pills["lastImage"] = image_filename
    
    #Upload currentPills JSON to settings folder in 'smart-pill-dispenser'
    try:
        print(output_pills)
        with open(reference_filename, 'w') as outfile:
            json.dump(output_pills, outfile)
        s3.upload_file(reference_filename, bucket, reference_pills_key, ExtraArgs={'ACL': 'public-read'})
        
    except Exception as e:
        print(e)
        print('Error putting object {} into bucket {}.'.format(reference_pills_key, bucket))
        raise e
    
    #Create updated aiOutput
    ai_json.append(createAiJsonEntry(image_filename, timestamp, timestamped_pills, unidentifiedObjects, device_json["status"], device_json["notes"], device_json["lastPill"]))
    print(ai_json)
    
        
    #Upload aiOutput JSON to public folder in 'storagebucket20402-dev'
    try:
        with open(ai_json_filename, 'w') as outfile:
            json.dump(ai_json, outfile)
        s3.upload_file(ai_json_filename, bucket, ai_json_key, ExtraArgs={'ACL': 'public-read'})
        
    except Exception as e:
        print(e)
        print('Error putting object {} into bucket {}.'.format(ai_json_key, bucket))
        raise e
