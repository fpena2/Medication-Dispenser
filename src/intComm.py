import boto3
from botocore.client import Config
import os

class commControl:
    def __init__(self, bucket="", imgFolder=""):
        self.bucket = bucket
        self.imgFolder = imgFolder

    def getFiles(self):
        for img in os.listdir(self.imgFolder):
            if img.endswith(".jpg"):
                print(img)
                data = open(os.path.join(self.imgFolder, img), "rb")
                name = os.path.basename(img)
                self.startComm(name, data)
            
    def startComm(self, name, data):
        s3 = boto3.resource("s3")
        s3.Bucket(self.bucket).put_object(Key=name, Body=data)


bucket = "smart-pill-dispenser"
imgFolder = "/home/pi/Desktop/source/Medication-Dispenser/output"

a = commControl(bucket, imgFolder)
a.getFiles()
print("done")