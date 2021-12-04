import sys
import os
import random
from time import sleep
import json
import datetime
from datetime import datetime, timedelta

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
    resultFile = "./msg/Schedule.json"
    msg.getJSON("public/Schedule.json", resultFile)
    with open(resultFile) as f:
        data = json.load(f)
        data = sorted(data, key=lambda d: d['schedule'])
        for entry in data:
            if entry["label"] == "Channel 1" and deploy_p1 == "":
                t = datetime.fromisoformat(entry["schedule"])
                deploy_p1 = t.replace(second=0)

            if entry["label"] == "Channel 2" and deploy_p2 == "":
                t = datetime.fromisoformat(entry["schedule"])
                deploy_p2 = t.replace(second=0)
    if deploy_p1 != "" or deploy_p2 != "":
        res = {"pill_1": deploy_p1,
               "pill_2": deploy_p2}
    return res

# print(checkDeployTime())


def updateStatus(feedback):
    # First pull the latest reply
    resultFile = "./msg/device.json"
    msg.getJSON("public/device.json", resultFile)
    # Update the cloud reply
    with open("./msg/device.json") as f:
        data = json.load(f)[0]
        data.update(feedback)
        data = json.dumps([data])
        msg.setJSON(data, "public/device.json")


def checkAiScan():
    result = ""
    feedback = ""
    resultFile = "./msg/current.json"
    msg.getJSON("public/current.json", resultFile)
    with open(resultFile) as f:
        data = json.load(f)["currentPills"]
        if data == []:
            # platform is cleared, proceed to deploy pill
            result = True
            feedback = {
                "status": "Ready: ",
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


# print(checkAiScan())


def takePicture():
    # led.ledON()
    # img.getImg()
    # img.cropImg()
    # picture = img.getImgPath()
    # led.ledOFF()
    # led.reset()
    # aws.sendFile(picture)

    # update msg
    # lastImgName = os.path.basename(picture)
    # healtyBeat = {"lastImg": lastImgName}
    # updateStatus()
    sleep(1)
    return checkAiScan()


def dropPill_1():
    print("Droping pill_1")
    # motor_1.rotate(rot_45, release)
    # sleep(1)
    # motor_1.rotate(rot_45, lock)
    # motor_1.reset()


def dropPill_2():
    print("Droping pill_1")
    # motor_2.rotate(rot_45, release)
    # sleep(1)
    # motor_2.rotate(rot_45, lock)
    # motor_2.reset()


def run_once(f):
    def wrapper(*args, **kwargs):
        if not wrapper.has_run:
            wrapper.has_run = True
            return f(*args, **kwargs)
    wrapper.has_run = False
    return wrapper


@run_once
def takeInitialPicture():
    # led.ledON()
    # img.getImg()
    # img.cropImg()
    # picture = img.getImgPath()
    # led.ledOFF()
    # led.reset()
    # aws.sendFile(picture)

    # update msg
    # lastImgName = os.path.basename(picture)
    # healtyBeat = {"lastImg": lastImgName}
    # updateStatus()
    print("Take one picture")
    sleep(1)
    return checkAiScan()


def loop():
    action = run_once(takeInitialPicture)
    flag = False

    # dropTime = datetime.now().replace(microsecond=0) + timedelta(minutes=3)
    # todayTime = datetime.now().replace(microsecond=0)

    while 1:
        # resturns already sorted dictionary
        timeData = checkDeployTime()
        # timeData = dict(sorted(timeData.items(), key=lambda item: item[1]))
        if not timeData["pill_1"] == "" and not timeData["pill_2"] == "":
            dropPill = next(iter(timeData))
            dropTime = timeData[dropPill].replace(second=0, microsecond=0)
            timeZone = timeData[dropPill].tzinfo
            todayTime = datetime.now(timeZone).replace(second=0, microsecond=0)

            # todayTime = todayTime + timedelta(seconds=1)
            print(dropTime - todayTime)
            # print(dropTime - todayTime)
            # print(timedelta(minutes=1))

            if (dropTime - todayTime < timedelta(minutes=2)):
                # Take picture once
                aiScan = action()
                if aiScan == True:
                    print("Initial picture looks good")
                    flag = True

            if flag == True:
                if (dropTime - todayTime < timedelta(minutes=1)):
                    print("Drop the pill")
                    flag = False
        else:
            print("Pill was not found in the schedule")
            sleep(5)
            pass


loop()
