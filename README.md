# MFCN
This code is for the paper "A unified deep-learning network to accurately segment insulin granules of different animal models imaged under different electron microscopy methodologies "
--

STEP 1: Image histogram equalization.
-

The histogram equalization can be implemented with the Matlab built-in function, e.g.,:
img = imread('train1.tiff');
J = histeq(img);

STEP 2: MFCN binary segmentation.
-

We provide a MFCN implement of the Caffe version, saved as code_model.zip, containing the MFCN model (in./code_model/caffeprototxt/), our trained modelweight file (in./code_model/modelweight/), some python scripts (in ./code_model/python_script/) and Matlab scripts(in ./code_model/matlab_script/) for model training and post-processing. However, the MFCN model realized by other deep-learning frameworks, such as TensorFlow, PyTorch, MXNet also works well. For this version, we randomly crop and save the image sets and the corresponding binary label sets as an .h5 file. The model training depended on two prototxt scripts: wd.prototxt (for MFCN model description) and solverdbwt.prototxt (for training strategy description). We can enter the Caffe installation directory and input the command line to train these models, such as: ./build/tools/caffe train -gpu 0 --solver=/home/zxy/caffeprototxt/solver.prototxt
More examples can be seen in http://caffe.berkeleyvision.org/gathered/examples/imagenet.html. 
In this experiment, we train the model from scratch. In effect, users can finetune their own model with our trained model (./code_model/modelweight/dwu__iter_60000.caffemodel), which can improve the training speed significantly.
Once we have trained the model, we can use the trained model to segment new images (the corresponding python script can be seen in ./code_model/python_script/test_perpatch.py). This python script adopts a patch-based testing method, in which the input image (i.e., size of 1792 × 2048) is sliced into smaller patches (i.e., size of 640 × 640) to be run on GPU. However, the whole (i.e., size of 1792 × 2048) image can be segmented on a CPU with MFCN model immediately, although this is relatively slow.

STEP 3: Watershed based instance segmentation.
-

After obtaining binary segmentation maps, to record information for each vesicle, e.g., area, radius, and gray-value, we adopt a watershed-based instance segmentation and save each vesicle’s contour as .roi files, which can be read by ImageJ software. We provide Matlab scripts (in ./code_model/matlab_script), first running watershed_for_dbwts.m to record information for each vesicle, and then running freeroisaveapply.m to save the .roi files. These .roi files can be read and analyzed by ImageJ software.

If you need the dataset or have any questions, please contact with 644364381@qq.com
