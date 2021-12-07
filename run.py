import sys
import os
import json
import datetime
from datetime import datetime, timedelta
from functools import wraps
from time import sleep

__device__ = True if "pi" in os.environ['USER'] else False

sys.path.append(os.path.abspath("./src/"))  # nopep8
from initMsg import msgController
from initComm import commController
if __device__:
    from initCam import imgController
    from initLED import ledController
    from initMotor import *


# Input to the Objects
# msgController
# bucket = "imgstore-pi"
bucket = "storagebucket20402-dev"
# commController
bucketImgDest = "images/"
# imgController
resolution = (900, 900)
imgsDest = "./output/"


#  List of Objects
msg = msgController(bucket)
awsPicStore = commController(bucket, bucketImgDest)
if __device__:
    led = ledController()
    img = imgController(resolution, imgsDest)
    motor_1 = motorController(chanList1)  # right
    motor_2 = motorController(chanList2)  # left


def checkDeployTime():
    timeRes = {}
    idRes = {}
    typeRes = {}

    deploy_p1 = ""
    id_1 = ""
    type_1 = ""

    deploy_p2 = ""
    id_2 = ""
    type_2 = ""

    resultFile = "./msg/Schedule.json"
    msg.getJSON("public/Schedule.json", resultFile)
    with open(resultFile) as f:
        data = json.load(f)

        if data == []:
            return [{}, {}, {}]

        data = sorted(data, key=lambda d: d['schedule'])
        for entry in data:
            if entry["label"] == "Channel 1" and deploy_p1 == "":
                t = datetime.fromisoformat(entry["schedule"])
                deploy_p1 = t.replace(second=0)
                id_1 = entry["id"]
                type_1 = entry["title"]

            if entry["label"] == "Channel 2" and deploy_p2 == "":
                t = datetime.fromisoformat(entry["schedule"])
                deploy_p2 = t.replace(second=0)
                id_2 = entry["id"]
                type_2 = entry["title"]

    if deploy_p1 != "" or deploy_p2 != "":
        idRes = {"pill_1": id_1, "pill_2": id_2}
        timeRes = {"pill_1": deploy_p1, "pill_2": deploy_p2}
        typeRes = {"pill_1": type_1, "pill_2": type_2}

    return [timeRes, idRes, typeRes]


def updateSchedule(id):
    resultFile = "./msg/Schedule.json"
    msg.getJSON("public/Schedule.json", resultFile)
    data = ""
    with open("./msg/Schedule.json") as f:
        data = json.load(f)
        for d in data.copy():
            if id in d.values():
                data.remove(d)
                print("popped pill from schedule")
    data = json.dumps(data)
    msg.setJSON(data, "public/Schedule.json")
    msg.getJSON("public/Schedule.json", resultFile)


def updateStatus(feedback):
    # First pull the latest reply
    resultFile = "./msg/device.json"
    msg.getJSON("public/device.json", resultFile)
    # Update the cloud reply
    with open("./msg/device.json") as f:
        data = json.load(f)[0]
        data.update(feedback)
        data = json.dumps([data])
        print(data)
        msg.setJSON(data, "public/device.json")
    msg.getJSON("public/device.json", resultFile)


def checkAiScan():
    result = ""
    feedback = ""
    resultFile = "./msg/current.json"
    msg.getJSON("public/current.json", resultFile)
    with open(resultFile) as f:
        data = json.load(f)
        print(data)
        data = data["currentPills"]
        if data == []:
            # platform is cleared, proceed to deploy pill
            result = True
            feedback = {
                "status": "Ready",
                "notes": "Device is ready & platform is clear",
            }
        else:
            result = False
            feedback = {
                "status": "Waiting",
                "notes": "Device is waiting for platform to be cleared",
            }
        updateStatus(feedback)
        return result


def takePicture(pillType):
    print("Taking a picture...")
    if __device__:
        led.ledON()
        currTime = datetime.now().strftime("%m-%d-%y_%H:%M:%S")
        img.getImg(currTime)
        img.cropImg()
        picture = img.getImgPath()
        print(picture)
        led.ledOFF()
        awsPicStore.sendFile(picture)
        # update msg
        lastImgName = os.path.basename(picture)

        # update the device feedback
        feedback = {"lastPill": pillType, "lastImg": lastImgName,
                    "notes": "Your medication is ready!"}
        updateStatus(feedback)

    print("Took a picture...")
    return


def dropPill_1():
    print("Droping pill_1...")
    sleep(5)
    if __device__:
        motor_1.rotate(rot_45, release)
        sleep(1)
        motor_1.rotate(rot_45, lock)


def dropPill_2():
    print("Droping pill_2...")
    sleep(5)
    if __device__:
        # Inverted logic for motor_2 (left)
        motor_2.rotate(rot_45, lock)
        sleep(1)
        motor_2.rotate(rot_45, release)


def run_once(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        if not wrapper.has_run:
            result = f(*args, **kwargs)
            wrapper.has_run = True
            return result
    wrapper.has_run = False
    return wrapper


@run_once
def takeInitialPicture():
    if __device__:
        takePicture()
    # update the device feedback
    feedback = {
        "lastPill": "",
        "notes": "Took check-up image",
    }
    updateStatus(feedback)

    print("...Initial picture check...")
    # check the platform
    sleep(10)
    response = checkAiScan()
    return response


def beat():
    feedback = {
        "status": "Healthy",
        "notes": "Device is good",
    }
    updateStatus(feedback)


def loop():
    while 1:
        # delay
        beat()
        sleep(5)

        # pulls data from schedule
        response = checkDeployTime()  # resturns already sorted dictionary
        timeData = response[0]
        idData = response[1]
        typeData = response[2]

        if timeData != {}:
            # remove empty keys from schedule
            timeData = {k: v for k, v in timeData.items() if v}
            idData = {k: v for k, v in idData.items() if v}

            dropPill = next(iter(timeData))
            dropTime = timeData[dropPill].replace(microsecond=0)
            timeZone = timeData[dropPill].tzinfo
            todayTime = datetime.now(timeZone).replace(microsecond=0)

            delta = dropTime - todayTime
            delta = delta.total_seconds()
            print(delta)

            if (delta > 0 and delta < 60):
                # take picture once
                if takeInitialPicture() == True:
                    print("(((Initial picture = Platform is empty)))")

                    # Set to negative to remove from schedule
                    delta = -1
                    sleep(5)

                    if dropPill == "pill_1":
                        dropPill_1()
                        takePicture(typeData[dropPill])

                    if dropPill == "pill_2":
                        dropPill_2()
                        takePicture(typeData[dropPill])

                else:
                    print("(((Platform needs to be cleared)))")
                    delta = -1

            # If the time has passed
            if delta < 0:
                # allow drop to happen again
                takeInitialPicture.has_run = False
                # remove pill from the schedule
                id = idData[dropPill]
                updateSchedule(id)

        else:
            print("No pills found in schedule")
            print("sleeping for 10 sec")
            sleep(10)


try:
    loop()
except Exception as e:
    print(e)
    feedback = {
        "status": "Fatal",
        "notes": "Device is down",
    }
    updateStatus(feedback)
