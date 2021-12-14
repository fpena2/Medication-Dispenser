import RPi.GPIO as GPIO
from time import sleep

chanList = [15]


class ledController:
    def __init__(self):
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(chanList, GPIO.OUT)
        GPIO.output(chanList, GPIO.LOW)

    def ledON(self):
        GPIO.output(chanList, GPIO.HIGH)

    def ledOFF(self):
        GPIO.output(chanList, GPIO.LOW)

    def reset(self):
        GPIO.cleanup()
