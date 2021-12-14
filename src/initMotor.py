import RPi.GPIO as GPIO
from time import sleep

# disable warnings
GPIO.setwarnings(False)

# Pin Configuration (GPIO)
chanList1 = [17, 18, 27, 22]  # right side or pill_1
chanList2 = [26, 19, 13, 6]  # lift side or pill_2

# Variables
delay = 0.001

# Rotation
rot_360 = 4096
rot_180 = int(rot_360 / 2)
rot_90 = int(rot_360 / 4)
rot_45 = int(rot_360 / 8)

# State
lock = 1
release = -1

# Step Motor Sequence
sequence = [
    [1, 0, 0, 1],
    [1, 0, 0, 0],
    [1, 1, 0, 0],
    [0, 1, 0, 0],
    [0, 1, 1, 0],
    [0, 0, 1, 0],
    [0, 0, 1, 1],
    [0, 0, 0, 1],
]


class motorController:
    def __init__(self, chanList):
        self.chanList = chanList
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.chanList, GPIO.OUT)
        GPIO.output(self.chanList, GPIO.LOW)

    def reset(self):
        GPIO.setup(self.chanList, GPIO.OUT)
        GPIO.cleanup()

    # (+) Rotate caunter clockwise (looking from blue pastic marking)
    # (-) Rotate clockwise to release the pill
    def rotate(self, angle, direction):
        step = 0
        for _ in range(angle):
            for i in range(0, 4):
                sleep(delay)
                GPIO.output(self.chanList[i], sequence[step][i])
            step = (step + direction) % 8
