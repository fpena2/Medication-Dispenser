import boto3
from botocore.client import Config
import os

class commController:
    def __init__(self, bucket="", bucketFolder=""):
        self.bucket = bucket
        self.bucketFolder = bucketFolder

    def sendFile(self, imgPath):
        if os.path.isfile(imgPath):
            data = open(imgPath, "rb")
            name = os.path.basename(imgPath)
            self.startComm(name, data)

    def sendBulk(self, imgFolder):
        for img in os.listdir(self.imgFolder):
            if img.endswith(".jpg"):
                print(img)
                getFile(img)
                
    def startComm(self, name, data):
        s3 = boto3.resource("s3")
        s3.Bucket(self.bucket).put_object(Key=self.bucketFolder + name, Body=data)

