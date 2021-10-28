import sys
import os
sys.path.append(os.path.abspath("./src/"))
from initCam import imgController
from initComm import commController
from initMotor import *

resolution = (900, 900)
imgsDest = "./output/"


s = imgControler(resolution, imgsDest)
s.getImg()
s.cropImg()
pic = s.getImgPath()


#bucket = "imgstore-pi"
bucket = "smart-pill-dispenser"
bucketImgDest = "images/" 


a = commControl(bucket, bucketImgDest)
a.sendFile(pic)
print("done")


m = motorController()
m.rotate(rot_45, lock)
m.reset()
