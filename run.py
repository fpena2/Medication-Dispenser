import sys
import os
from time import sleep
sys.path.append(os.path.abspath("./src/"))
from initCam import imgController
from initComm import commController
from initLED import ledController
from initMotor import *

resolution = (900, 900)
imgsDest = "./output/"

# m = motorController()
# m.rotate(rot_45, release)
# sleep(1)
# m.rotate(rot_45, lock)
# m.reset()

led = ledController()
led.ledON()

img = imgController(resolution, imgsDest)
img.getImg()
img.cropImg()
picture = img.getImgPath()

led.ledOFF()
led.reset()

#bucket = "imgstore-pi"
bucket = "smart-pill-dispenser"
bucketImgDest = "images/" 
aws = commController(bucket, bucketImgDest)
aws.sendFile(picture)
print("done")



