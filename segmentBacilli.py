import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import scipy
import sys

from skimage import data
from skimage.filters import threshold_otsu
from skimage.segmentation import clear_border
from skimage.measure import label
from skimage.morphology import closing, square
from skimage.measure import regionprops
from skimage.color import label2rgb
from skimage import color
from skimage import io
from skimage import exposure

fname=sys.argv[1]
folder=sys.argv[2]

path='C:\\Program Files\\MATLAB\\R2013a\\DIP Project\\'
image = scipy.misc.imread(path+fname+'.jpg')

#img = color.rgb2gray(io.imread('/home/akshit/DIP Python codes/smear2.jpg'));

# apply threshold
thresh = threshold_otsu(image)
bw = closing(image > thresh, square(3))
#bw=image

# remove artifacts connected to image border
cleared = bw.copy()
clear_border(cleared)

# label image regions
label_image = label(cleared)
borders = np.logical_xor(bw, cleared)
label_image[borders] = -1
image_label_overlay = label2rgb(label_image, image=image)

fig, ax = plt.subplots(ncols=1, nrows=1, figsize=(6, 6))
ax.imshow(image_label_overlay)
labels=1

for region in regionprops(label_image):

    # skip small images
    if region.area < 400:
        continue

    # draw rectangle around segmented coins
    #print("area="+str(region.area))
    minr, minc, maxr, maxc = region.bbox
    #rect = mpatches.Rectangle((minc, minr), maxc - minc, maxr - minr,
                              #fill=False, edgecolor='red', linewidth=2)
    #ax.add_patch(rect)
    
    roi=label_image[minr:maxr,minc:maxc]
    
    roi=color.rgb2gray(roi)#rgb2gray
    roi = exposure.rescale_intensity(roi, out_range=(0, 255))#contrast
    io.imsave('C:\\Program Files\\MATLAB\\R2013a\\DIP Project\\'+folder+'\\'+fname+str(labels)+'.jpg', roi)#saving

    labels=labels+1
    #plt.imshow(roi)     
    #plt.show()
#plt.show()