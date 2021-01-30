import cv2
import numpy as np
import object_tracker as obj_trck
import matplotlib.pyplot as plt
import time
import math

# Choice of video file
choice = input('Test standard video? (y/n): ')
if (choice == "y"):
    cap = cv2.VideoCapture("IMG_5439.MOV")
else:
    video = input('Enter the name of the video file: ')
    cap = cv2.VideoCapture(str(video))

# Initialisation
x_distance_data = []
y_distance_data = []

# Read the first frame
_, frame = cap.read()

# Resizing parameters of frame
scale_percent = 30 # percent of original size ==> HUGE INFLUENCE ON SPEED
width = int(frame.shape[1]* scale_percent / 100)
height = int(frame.shape[0] * scale_percent / 100)
dim = (width, height)

track_time = []


while True:

    # Break at last frame (None)
    if not isinstance(frame, np.ndarray):
        if frame == None:
            break

    # Resize image
    frame = cv2.resize(frame, dim, interpolation = cv2.INTER_AREA)

    # Track circular objects on frame and time it
    time1 = time.time()
    frame, delta_x, delta_y = obj_trck.object_tracker(frame)
    time2 = time.time()

    # Save distance data
    x_distance_data.append(delta_x)
    y_distance_data.append(delta_y)

    track_time.append(time2 - time1)
    
    # Show the frame
    cv2.imshow('frame',frame)
    k = cv2.waitKey(1) 
    if k == 27:
        break

    # Read frame
    _, frame = cap.read()

# Plot the distance data
plt.xlim(-width/2, width/2)
plt.ylim(-height/2, height/2)
plt.scatter(x_distance_data, y_distance_data)
plt.grid()
plt.show()

avg_track_time = sum(track_time)/len(track_time)
print("Average tracking time: " + str(round(1000*avg_track_time,5)) + " ms")

# Termination
cap.release()
cv2.destroyAllWindows()