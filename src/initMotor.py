import RPi.GPIO as GPIO
from time import sleep

# Pin Configuration
chanList = [17, 18, 27, 22]

# Variables
delay= 0.001

# Rotation
rot_360 = 4096
rot_180 = int(rot_360/2)
rot_90 = int(rot_360/4)
rot_45 = int(rot_360/8)

#State
lock = 1
release = -1 

# Step Motor Sequence 
sequence = [[1,0,0,1],
           [1,0,0,0],
           [1,1,0,0],
           [0,1,0,0],
           [0,1,1,0],
           [0,0,1,0],
           [0,0,1,1],
           [0,0,0,1]]

class motorController:
	def __init__(self):
		GPIO.setmode(GPIO.BCM)
		GPIO.setup(chanList, GPIO.OUT)
		GPIO.output(chanList, GPIO.LOW)

	def reset(self):
		GPIO.setup(chanList, GPIO.OUT)
		GPIO.cleanup()

	# (+) Rotate caunter clockwise (looking from blue pastic marking)
	# (-) Rotate clockwise to release the pill
	def rotate(self, angle, direction):
		step = 0
		for _ in range(angle):
			for i in range(0, 4):
				sleep(delay)
				GPIO.output(chanList[i], sequence[step][i])
			step = (step + direction) % 8
