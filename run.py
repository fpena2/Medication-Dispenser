import sys
import os
sys.path.append(os.path.abspath("./src/"))
from initCam import imgController
from initComm import commController
from initLED import ledController
from initMotor import *

resolution = (900, 900)
imgsDest = "./output/"


s = imgController(resolution, imgsDest)
s.getImg()
s.cropImg()
picture = s.getImgPath()


#bucket = "imgstore-pi"
bucket = "smart-pill-dispenser"
bucketImgDest = "images/" 
a = commController(bucket, bucketImgDest)
a.sendFile(picture)
print("done")


# m = motorController()
# m.rotate(rot_45, lock)
# m.reset()
