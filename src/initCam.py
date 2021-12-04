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
        cam.capture(fpath)
        cam.close()

    def cropImg(self):
        img = Image.open(self.fpath)
        left = 385
        top = 430
        right = 580
        bottom = 730
        imgOut = img.crop((left, top, right, bottom))
        imgOut.save(self.fpath)

    def getImgPath(self):
        return self.fpath
