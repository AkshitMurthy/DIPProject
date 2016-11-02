Consider image as 'smear2.jpg'.

Step 1: Initialization

>> imgname='smear2';
>> im=imread('smear2.jpg');
>> init(im,imgname);

Step 2:Segmentation

Run the python script: python segmentBacilli.py smear2Bacilli smear2

Step 3: Counting

>> countBacilli(imgname);

For any other image, replace 'smear2' by the image name w/o the extension