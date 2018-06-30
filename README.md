# MFCN
This code is for the paper "A unified deep-learning network to accurately segment insulin granules of different animal models imaged under different electron microscopy methodologies "<br>
--

STEP 1: Image histogram equalization.
-

The histogram equalization can be implemented with the Matlab built-in function, e.g.,:<br>
J = histeq(img);<br>

STEP 2: MFCN binary segmentation.
-

We provide a MFCN implement of the Caffe version. In this experiment, we train the model from scratch. In effect,<br>
users can finetune their own model with our trained model , which can improve the training speed significantly.<br>
Once we have trained the model, we can use the trained model to segment new images. This python script adopts a <br>
patch-based testing method, in which the input image (i.e., size of 1792 × 2048) is sliced into smaller patches <br>
(i.e., size of 640 × 640) to be run on GPU. However, the whole (i.e., size of 1792 × 2048) image can be segmented <br>
on a CPU with MFCN model immediately, although this is relatively slow.<br>

STEP 3: Watershed based instance segmentation.
-

After obtaining binary segmentation maps, to record information for each vesicle, e.g., area, radius, and gray-value, <br>
we adopt a watershed-based instance segmentation and save each vesicle’s contour as .roi files, which can be read by <br>
ImageJ software. We provide Matlab scripts , first running watershed_for_dbwts.m to record information for each vesicle, <br>
and then running freeroisaveapply.m to save the .roi files. These .roi files can be read and analyzed by ImageJ software.<br>

If you need the dataset or have any questions, please contact with 644364381@qq.com<br>
