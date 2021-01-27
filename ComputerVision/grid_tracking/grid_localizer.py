import numpy as np
import cv2
from numpy.lib.function_base import average, median

# Round to nearest multiple of 5
def myround(x, base=5):
    return base * round(x/base)

def sort_contours(contours):
    locations = []
    i = 0
    for contour in contours:
        M = cv2.moments(contour)
        cX = myround(int(M["m10"] / M["m00"]))
        cY = myround(int(M["m01"] / M["m00"]))
        locations.append([cX, cY, i])
        i += 1
    sorted_locations = sorted(locations,key=lambda x: (x[1],x[0]))
    x_diff = 0
    y_diff = 0
    for j in range(1,len(sorted_locations)):
        a = abs(sorted_locations[j][0] - sorted_locations[j-1][0])
        b = abs(sorted_locations[j][1] - sorted_locations[j-1][1])
        if (x_diff == 0) or (a < x_diff and a != 0):
                x_diff = a
        if (y_diff == 0) or (b < y_diff and b != 0):
                y_diff = b
        

    sorted_contours = []
    for location in sorted_locations:
            sorted_contours.append(contours[location[2]])
    return sorted_contours, x_diff, y_diff



image  = cv2.imread("grid.png")
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
blur = cv2.GaussianBlur(gray, (5,5), 0)
thresh = cv2.adaptiveThreshold(blur, 255, 1, 1, 11, 2)
contours, _ = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

max_area = 0
c = 0
for i in contours:
        area = cv2.contourArea(i)
        if area > 1000:
                if area > max_area:
                    max_area = area
                    best_cnt = i
                    image = cv2.drawContours(image, contours, c, (0, 255, 0), 3)
        c+=1

mask = np.zeros((gray.shape),np.uint8)
cv2.drawContours(mask,[best_cnt],0,255,-1)
cv2.drawContours(mask,[best_cnt],0,0,2)
out = np.zeros_like(gray)
out[mask == 255] = gray[mask == 255]
blur = cv2.GaussianBlur(out, (5,5), 0)
thresh = cv2.adaptiveThreshold(blur, 255, 1, 1, 11, 2)

# Find all the contours
contours1, _ = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

# Filter out contours around multiple blocks
area_list = []
for contour in contours1:
        area = cv2.contourArea(contour)
        area_list.append(area)
average_area = average(area_list)
contours = []
for contour in contours1:
        if cv2.contourArea(contour) < average_area:
                contours.append(contour)

# Sort contours
contours, x_diff, y_diff = sort_contours(contours)

c = 0
for i in contours:

        # Calculate centre of contour
        M = cv2.moments(i)
        cX = myround(int(M["m10"] / M["m00"]))
        cY = myround(int(M["m01"] / M["m00"]))

        # Calculate contour coordinates
        if x_diff != 0:
                x_coordinate = round(cX/x_diff)-1
        else:
                x_coordinate = 0
        if y_diff != 0:
                y_coordinate = round(cY/y_diff)-1
        else:
                y_coordinate = 0
        coordinate = [x_coordinate, y_coordinate]

        # Put circle and text at center of contour
        cv2.circle(image, (cX, cY), 5, (0, 0, 0), -1)
        cv2.putText(image, str(coordinate), (cX - 20, cY - 20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 2)

        # Draw contour
        cv2.drawContours(image, contours, c, (0, 255, 0), 3)
        c+=1


cv2.imshow("Final Image", image)
cv2.waitKey(0)
cv2.destroyAllWindows()