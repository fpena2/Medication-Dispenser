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
    id_1 = ""
    deploy_p2 = ""
    id_2 = ""
    resultFile = "./msg/Schedule.json"
    msg.getJSON("public/Schedule.json", resultFile)
    with open(resultFile) as f:
        data = json.load(f)

        if data == []:
            return [{}, {}]

        data = sorted(data, key=lambda d: d['schedule'])
        for entry in data:
            if entry["label"] == "Channel 1" and deploy_p1 == "":
                t = datetime.fromisoformat(entry["schedule"])
                deploy_p1 = t.replace(second=0)
                id_1 = entry["id"]

            if entry["label"] == "Channel 2" and deploy_p2 == "":
                t = datetime.fromisoformat(entry["schedule"])
                deploy_p2 = t.replace(second=0)
                id_2 = entry["id"]

    if deploy_p1 != "" or deploy_p2 != "":
        idRes = {"pill_1": id_1, "pill_2": id_2}
        timeRes = {"pill_1": deploy_p1, "pill_2": deploy_p2}

    return [timeRes, idRes]


def updateSchedule(id):
    resultFile = "./msg/Schedule.json"
    msg.getJSON("public/Schedule.json", resultFile)
    data = ""
    with open("./msg/Schedule.json") as f:
        data = json.load(f)
        for d in data.copy():
            if id in d.values():
                data.remove(d)
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
        msg.setJSON(data, "public/device.json")
    msg.getJSON("public/device.json", resultFile)


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
    print("Taking picture of pill")
    sleep(1)
    return


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


@ run_once
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
    print("Initial picture taken")
    sleep(1)
    return checkAiScan()


def loop():
    action = run_once(takeInitialPicture)

    while 1:
        # resturns already sorted dictionary
        response = checkDeployTime()
        timeData = response[0]
        idData = response[1]

        # remove empty keys from schedule
        timeData = {k: v for k, v in timeData.items() if v}
        idData = {k: v for k, v in idData.items() if v}

        if timeData != {}:
            dropPill = next(iter(timeData))
            print(dropPill)
            print(timeData[dropPill])
            dropTime = timeData[dropPill].replace(second=0, microsecond=0)
            timeZone = timeData[dropPill].tzinfo
            todayTime = datetime.now(timeZone).replace(second=0, microsecond=0)

            print(dropTime - todayTime)
            delta = dropTime - todayTime

            if (delta < timedelta(minutes=1) and delta > timedelta(minutes=0)):
                # Take picture once
                aiScan = action()
                if aiScan == True:
                    print("Initial picture looks good")
                    if dropPill == "pill_1":
                        dropPill_1()
                        takePicture()
                    if dropPill == "pill_2":
                        dropPill_2()
                        takePicture()

            # If the time has passed
            if todayTime > dropTime:
                # remove pill from the schedule
                id = idData[dropPill]
                updateSchedule(id)
                # allow drop to happen again
                action.has_run = False
        else:
            print("No pills found in schedule")
            print("sleeping for 5 sec")
            sleep(5)


loop()
