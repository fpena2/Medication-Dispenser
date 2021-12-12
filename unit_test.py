import boto3
from functools import wraps
import sys
import os

sys.path.append(os.path.abspath("./src/"))  # nopep8
from initMsg import msgController

bucket = "storagebucket20402-dev"
msg = msgController(bucket)


def test():
    name = "Schedule.json"
    # name = "current.json"
    # name = "device.json"
    msg.setFile("public/" + name, "./msg/archive/" + name)
    # s3 = boto3.client("s3")
    # all_objects = s3.list_objects(Bucket=bucket)
    # for key in all_objects:
    #     if key == "Contents":
    #         for a in all_objects["Contents"]:
    #             print(a["Key"])


test()
