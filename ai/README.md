The AI component of this project is hosted entirely by AWS, using an S3 bucket and a Lambda function written in Python. The Lambda function containing the AI gets triggered when an image is uploaded to the 'images' folder of the bucket. 

Once triggered, the function converts the image to gray scale and applies blur and edge detection. Next, it converts from gray scale to binary using a set threshold, fills in any closed shapes, and counts the number of particles, (which are contiguous sections of white pixels) eliminating any which are outside size constraints. The particles are compared to a list of reference pills to identify objects. 

The AI outputs a list of pills on the platform, an updated color image with objects highlighted, and lists of pills released and removes along with additional data about device state.

## Installation

NOTE: It is easiest if all of these steps are performed within the same AWS account. If using multiple accounts, you will have to set up permissions across accounts using IAM roles. There are many tutorials in the AWS documentation to do this.

1. Create an S3 bucket with two sub-folders, 'images' and 'public'.

2. Copy the JSON files in the 'msg' folder of this repository to the 'public' folder in the bucket.

3. Create a Lambda function and copy the code from 'lambda_pill_detection.py'.

4. Add a trigger to the Lambda function when an object is uploaded to the 'images' folder of the S3 bucket. You should select the name of the bucket for the 'Bucket' field, 'All object create events' for the 'Event type' field, and put 'images/' in the optional prefix field.

5. Create a Lambda layer which includes `numpy` and openCV Python libraries. There are tutorials in AWS documentation and other online sources that walk through this process step-by-step. NOTE: You need Docker for this, so I recommend using Linux, as Docker does not behave well on Windows.

6. Upload this layer to an S3 bucket (it can be the same one you created earlier, so long as you don't upload the file to the 'images' folder). In the Lambda function's 'Code' tab, scroll down and press 'Add a layer', then add your custom layer. This will allow your function to utilize the cv2 and `numpy` libraries it needs for image processing.

7. Perform the necessary install steps for the device and the user interface, if desired. You can also run the AI manually without the other components by uploading images to the 'images' folder.

## How-to-Run

1. Update the pillDict in the Lambda function with the list of pills relevant to your use case. Entries should map a pill name to a dictionary containing the name, the pill size in pixels, the shape of the pill, and the color, as an RGBA vector.

2. The AI will automatically be triggered when a file is uploaded to the 'images' folder of the associated S3 bucket. Make sure only image files are uploaded here, as other file types will cause errors. AI output will be placed in the 'public' folder of the S3 bucket.
   