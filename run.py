import sys
import os
from time import sleep
import json
from datetime import datetime, date

sys.path.append(os.path.abspath("./src/"))  # nopep8
from initMsg import msgController
from initComm import commController
# from initCam import imgController
# from initLED import ledController
# from initMotor import *


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
# led = ledController()
awsPicStore = commController(bucket, bucketImgDest)
# img = imgController(resolution, imgsDest)
# motor = motorController()


def checkDeployTime():
    deploy_p1 = ""
    deploy_p2 = ""
    resultFile = "./msg/schedule.json"
    msg.getJSON("public/schedule.json", resultFile)
    with open(resultFile) as f:
        data = json.load(f)
        print(data)
        # deploy_p1 = data["schedule"]["pill_1"]["delivery"]
        # deploy_p2 = data["schedule"]["pill_2"]["delivery"]

    res = {"pill_1": datetime.fromisoformat(deploy_p1).replace(second=0),
           "pill_2": datetime.fromisoformat(deploy_p2).replace(second=0)}
    return res


def updateStatus(feedback):
    with open("./msg/device.json") as f:
        data = json.load(f)["deviceOutput"]
        data.update(feedback)
        data = json.dumps(data)
        msg.setJSON(data, "public/device.json")


def checkAiScan():
    result = ""
    feedback = ""
    resultFile = "./msg/current.json"
    msg.getJSON("public/current_test.json", resultFile)
    with open(resultFile) as f:
        data = json.load(f)["currentPills"]

        if data == []:
            # platform is cleared, proceed to deploy pill
            result = True
            feedback = {
                "status": "Deploying",
                "notes": "Device is deploying the medication",
            }
        else:
            result = False
            feedback = {
                "status": "Waiting",
                "notes": "Device is waiting for platform to be cleared",
            }
        updateStatus(feedback)
        return result


# checkAiScan()
# checkDeployTime()

# while 1:

if checkAiScan():
    print("Platform: Good")

    timeData = checkDeployTime()
    for pill in timeData.copy():
        timeZone = timeData[pill].tzinfo
        today = datetime.now(timeZone).replace(second=0)
        if today > timeData[pill]:
            timeData.pop(pill, None)

    # sort from closest time to longer
    timeData = dict(sorted(timeData.items(), key=lambda item: item[1]))
    dropPill = next(iter(timeData))
    dropTime = timeData[pill].time()
    todayTime = datetime.now(timeZone).replace(second=0)

    if (todayTime == timeData):
        if "pill_1" in dropPill:
            print("Droping pill_1")
            # m_1.rotate(rot_45, release)
            # sleep(1)
            # m_1.rotate(rot_45, lock)
            # m_1.reset()
            pass
        elif "pill_2" in dropPill:
            print("Droping pill_1")
            # m_2.rotate(rot_45, release)
            # sleep(1)
            # m_2.rotate(rot_45, lock)
            # m_2.reset()
            pass
        else:
            print("No pill to drop was found in the schedule")
else:
    print("Platform needs to be cleaned")

# heart beat
    # led.ledON()
    # img.getImg()
    # img.cropImg()
    # picture = img.getImgPath()
    # led.ledOFF()
    # led.reset()
    # aws.sendFile(picture)
    # print("done")

# sleep(5)

# m = motorController()
# m.rotate(rot_45, release)
# sleep(1)
# m.rotate(rot_45, lock)
# m.reset()

# led = ledController()
# led.ledON()

# img = imgController(resolution, imgsDest)
# img.getImg()
# img.cropImg()
# picture = img.getImgPath()

# led.ledOFF()
# led.reset()

# #bucket = "imgstore-pi"
# bucket = "smart-pill-dispenser"
# bucketImgDest = "images/"
# aws = commController(bucket, bucketImgDest)
# aws.sendFile(picture)
# print("done")
