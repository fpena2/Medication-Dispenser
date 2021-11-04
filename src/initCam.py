from picamera import PiCamera 
from datetime import datetime
from PIL import Image
import os

class imgController:
    def __init__(self, res = (900,900), outFolder = "./output/"):
        self.res = res
        devName = os.uname()[1]
        currTime = datetime.now().strftime("%m-%d-%y_%H:%M:%S")
        fname = "{}_{}.jpg".format(devName, currTime )
        self.fpath = os.path.join(outFolder, fname)
     
    def getImg(self):
        cam = PiCamera()
        cam.resolution = self.res
        cam.capture(self.fpath)
        
    def cropImg(self):
        img = Image.open(self.fpath)
        width, height = img.size
        left=385
        top=430
        right =580
        bottom = 730
        imgOut=img.crop((left, top, right, bottom))
        imgOut.save(self.fpath)

    def getImgPath(self):
        return self.fpath
