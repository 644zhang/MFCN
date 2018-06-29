import sys
caffe_root = '/home/zxy/caffe/'  # this file should be run from {caffe_root}/examples (otherwise change this line)
sys.path.insert(0, caffe_root + 'python')
import caffe
import h5py
import numpy as np
import matplotlib.pyplot as plt
import skimage.external.tifffile as tiff
from PIL import Image
from pylab import *
import pickle
import time
from scipy.misc import  imresize
from glob import glob
import cv2
import sklearn.preprocessing as pr
import shutil
import pdb

model_def = '/home/zxy/dbwt/modelprototxt/deploywd.prototxt'
model_weights = '/home/zxy/caffemodelsave/dwu__iter_60000.caffemodel'
img_path=r'/home/zxy/dbwt/testrealx'
img_paths = glob(img_path + '/*.tiff')
img_paths.sort()
i=0
caffe.set_mode_gpu()
caffe.set_device(1)
net = caffe.Net(model_def,      # defines the structure of the model
                model_weights,  # contains the trained weights
                caffe.TEST)     # use test mode (e.g., don't perform dropout)
for im_path in img_paths:
    start=time.time()
    image=cv2.imread(im_path,0)
    image=pr.scale(image)
    sp=np.shape(image)
    if sp[0]<640:
        paddingimg=zeros((640,640))
        paddingimg[320-sp[0]/2:320+sp[0]/2,320-sp[1]/2:320+sp[1]/2] \
            =image[:sp[0]/2*2,:sp[1]/2*2]
        x=paddingimg
    else:
        x=image
    sp1=np.shape(x)
    mul1=int(np.ceil(sp1[0]/640.0))
    mul2=int(np.ceil(sp1[1]/640.0))
    x1=np.zeros((sp1[0],sp1[1]))
    for j in xrange(mul1):
        for k in xrange(mul2):
            xmin=j*640
            ymin=k*640
            if (j+1)*640>sp1[0]:
                xmin=sp1[0]-640
            if (k+1)*640>sp1[1]:
                ymin=sp1[1]-640
            patch=x[xmin:xmin+640,ymin:ymin+640]
            pshape=np.shape(patch)
            net.blobs['data'].data[:]=patch[None,None]
            output = net.forward()
            part_output=np.argmax(output['prob8'],1).reshape(1,1,pshape[0],pshape[1])*255
            x1[xmin:xmin+640,ymin:ymin+640]=part_output
    tiff.imsave('/home/zxy/caffeimage/d_'+im_path[30:-5]+'.tiff',x1.astype("uint8")) 
    print time.time()-start
    




