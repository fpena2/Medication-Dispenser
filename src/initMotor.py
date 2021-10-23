import RPi.GPIO as GPIO
from time import sleep

# Pin Configuration
# GPIO.setwarnings(False)
chanList = [17, 18, 27, 22]
GPIO.setmode(GPIO.BCM)
GPIO.setup(chanList, GPIO.OUT)
GPIO.output(chanList, GPIO.LOW)

# Variables
delay= 0.001

# Rotation
full = 4096
half = int(full/2)
quarter = int(full/4)

# Step Motor Sequence 
sequence = [[1,0,0,1],
           [1,0,0,0],
           [1,1,0,0],
           [0,1,0,0],
           [0,1,1,0],
           [0,0,1,0],
           [0,0,1,1],
           [0,0,0,1]]

def reset():
	GPIO.setup(chanList, GPIO.OUT)
	GPIO.cleanup()

# Rotate caunter clockwise (looking from blue pastic marking)
def lock(rotation):
	step = 0
	for _ in range(rotation):
		for i in range(0, 4):
			sleep(delay)
			GPIO.output(chanList[i], sequence[step][i])
		step = (step+1)%8


# Rotate clockwise to release the pill
def release(rotation):
	step = 0
	for _ in range(rotation):
		for i in range(0, 4):
			sleep(delay)
			GPIO.output(chanList[i], sequence[step][i])
		step = (step - 1) % 8

release(quarter)
lock(quarter)
reset()