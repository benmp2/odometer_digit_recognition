# odometer_digit_recognition

step 1

git clone https://github.com/benmp2/odometer_digit_recognition

step 2

docker build . -t odometer_digit_recognition --rm 

step 3 

docker run --rm -p 8888:8888 -v "$PWD":/home/jovyan/work --name odometer_project odometer_digit_recognition
