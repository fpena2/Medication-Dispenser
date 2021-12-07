from picamera import PiCamera
from datetime import datetime
from PIL import Image
import os


class imgController:
    def __init__(self, res=(900, 900), outFolder="./output/"):
        self.res = res
        self.outFolder = outFolder
        self.devName = os.uname()[1]
        self.fpath = ""

    def getImg(self, time):
        fname = "{}_{}.jpg".format(self.devName, time)
        fpath = os.path.join(self.outFolder, fname)
        self.fpath = fpath
        cam = PiCamera()
        cam.resolution = self.res
        cam.capture(self.fpath)
        cam.close()

    def cropImg(self):
        img = Image.open(self.fpath)
        left = 390
        top = 435
        right = 570
        bottom = 720
        imgOut = img.crop((left, top, right, bottom))
        imgOut.save(self.fpath)

    def getImgPath(self):
        return self.fpath
