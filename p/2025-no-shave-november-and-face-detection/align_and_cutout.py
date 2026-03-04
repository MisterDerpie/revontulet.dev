import cv2

def left_eye_x_y(eyes):
    if eyes[0][0] < eyes[1][0]:
        return [(eyes[0][0]+(eyes[0][2]/2)).astype(int), (eyes[0][1]+(eyes[0][3]/2)).astype(int)]
    else:
        return [(eyes[1][0]+(eyes[1][2]/2)).astype(int), (eyes[1][1]+(eyes[1][3]/2)).astype(int)]

# Load the face classifier
face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier('haarcascade_eye_tree_eyeglasses.xml')

# Load the image
image = cv2.imread("image.png")
image = cv2.resize(image, (0, 0), fx=0.3, fy=0.3)

# Turn image into grayscale
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
# Detect faces
faces = face_cascade.detectMultiScale(gray, 1.3, 5)

for face in faces:
    # Face is stored as the rectangle [x, y, width, height]
    x = face[0]
    y = face[1]
    w = face[2]
    h = face[3]

    # Draw rectangle around it
    # cv2.rectangle(image, (x,y), (x+w, y+h), (0,0,255),thickness=5)

    # Use x, y, width and height from face as search area
    face_img = image[y:y+h, x:x+w]
    eyes = eye_cascade.detectMultiScale(face_img)

    # Create a list to append the eye's center x
    eyes_center_x = []

    # Draw rectangle around the eyes
    for eye in eyes:
        eye_x = eye[0]
        eye_y = eye[1]
        eye_width = eye[2]
        eye_height = eye[3]

        # cv2.rectangle(
        #     image,
        #     (x+eye_x,y+eye_y),
        #     (x+eye_x+eye_width, y+eye_y+eye_height),
        #     (0,255,0),
        #     thickness=5
        # )

        center_x = x + eye_x + (eye_width / 2).astype(int)
        center_y = y + eye_y + (eye_height / 2).astype(int)

        # cv2.circle(image, center=(center_x, center_y), radius=3, color=(0,0,255), thickness=25)
        eyes_center_x.append(center_x)
    

    eye_distance = abs(eyes_center_x[0] - eyes_center_x[1])
    print(eye_distance)
    sf = 150/eye_distance
    image = cv2.resize(image, (0, 0), fx=sf, fy=sf)
    

    left_eye = left_eye_x_y(eyes)
    print(left_eye)
    left_eye = (
        ((x+left_eye[0])*sf).astype(int),
        ((y+left_eye[1])*sf).astype(int),
    )

    # cv2.circle(image, center=(left_eye[0], left_eye[1]), radius=3, color=(0,0,255), thickness=25)
    # image = image[left_eye[1]:, left_eye[0]:]
    # image = image[left_eye[1]-300:, left_eye[0]-150:]
    image = image[
        left_eye[1]-300:(left_eye[1]-300)+630,
        left_eye[0]-150:(left_eye[0]-150)+475,
    ]

    # Even if multiple faces are found, we intentionally break
    break


# Save image to output.png
cv2.imwrite("output.png", image)
