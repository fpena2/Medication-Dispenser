import sys
import os
sys.path.append(os.path.abspath("./src/"))
from initCam import imgControler

resolution = (900, 900)
dest = "./output/"

s = imgControler(resolution, dest)
s.getImg()
s.cropImg()