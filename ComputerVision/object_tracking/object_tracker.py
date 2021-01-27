import cv2
import numpy as np
import math

def object_tracker(frame):
    """
    Locate circular objects on frame and calculate the distance between the center
    of the frame and the center of the circular object

    """

    # Calculate the x and y coordinates of the center of the frame
    frame_center = (round(frame.shape[1]/2), round(frame.shape[0]/2))

    # Initialise the distances in the x and y direction
    delta_x = None
    delta_y = None

    # Convert the frame to greyscale
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Detect circular shapes on the frame (third parameter (dp): 
    # higher is more forgiving for shape that are not exact circles)
    circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, 2, 100)

    if circles is not None:
        # Convert the (x, y) coordinates and radius of the circles to integers
        circles = np.round(circles[0, :]).astype("int")

        # Only track one circlular object
        circle = circles[0]
        
        # Draw circle and center of circle
        x,y,r = circle
        cv2.circle(frame, (x, y), r, (0, 255, 0), 4)
        cv2.rectangle(frame, (x - 5, y - 5), (x + 5, y + 5), (0, 128, 255), -1)

        # Draw line from center of the frame to center of the circle
        cv2.line(frame, frame_center, (x, y), (0, 255, 0), thickness=3, lineType=8)

        # Calculate the Euclidian distance between both centers and display on frame
        distance  = math.sqrt((frame_center[0]-x)**2 + (frame_center[1]-y)**2)
        text = "Distance: " + str(distance)
        cv2.putText(frame, text, (20, 550), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 100, 255), 2)

        # Calculate the distances in the x and y direction
        delta_x = frame_center[0] - x
        delta_y = frame_center[1] - y
    
    return frame, delta_x, delta_y