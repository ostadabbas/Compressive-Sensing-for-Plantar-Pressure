# Plantar Pressure Reconstruction Using Compressive Sensing

This is the code for the following paper:

Farnoosh, A., Ostadabbas, S., & Nourani, M. (2017, November). Spatially-Continuous Plantar Pressure Reconstruction Using Compressive Sensing. In Machine Learning for Healthcare Conference (pp. 13-24).
 
![Algorithm framewrk](Images/Framewrk.PNG)


Contact: 

[Amirreza Farnoosh](farnoosh.a@husky.neu.edu),

[Sarah Ostadabbas](ostadabbas@ece.neu.edu)


## Contents   
* [1. Requirement](#1-requirement)
* [2. Dataset](#2-dataset)
* [3. Training and Evaluation](#3-training-and-evaluation)
* [Citation](#citation)
* [License](#license)


## 1. Requirement 

* The codes are written with MATLAB 2016b.
* The mfiles `KSVD.m`, `KSVD_NN.m`, `OMP.m`, `OMPerr.m`, `NN_BP.m`, and `my_im2col.m` are taken from [here] (https://github.com/hbtsai/dip_sr/tree/master/matlab_ref/Lib/KSVD) with slight changes. These mfiles implement K-SVD algorithm proposed in: [The K-SVD: An Algorithm for Designing of Overcomplete Dictionaries for Sparse Representation] (https://sites.fas.harvard.edu/~cs278/papers/ksvd.pdf), written by M. Aharon, M. Elad, and A.M. Bruckstein.
 
## 2. Dataset

The dataset comes from the original work of [A knowledge-based modeling for plantar pressure image reconstruction] (https://ieeexplore.ieee.org/abstract/document/6813648/) and is placed in `Dataset/` directory. It includes plantar pressure readings from 5 healthy subjects (right/left foot), and is augmented with the corresponding GMM centroids and variances from their method, as well as other information/preprocessing needed for our method.   

## 3. Training and Evaluation 

* Run `learningtest.m` and set `dict.learn` flag to learn dictionary, and get evaluation plots for each specified subject and foot. You may set `dict.learn = 0` if you wish to use pretrained dictionaries in `Dictionaries\` directory to get evaluation plots.

* Run `analyzeAll.m` to get aggregated evaluation results for all subjects and feet. Again set `dict.learn = 0` if you want to use the pretrained dictionaries.

* Uncomment the corresponding lines (40-43)in `testallfunc.m` if you want to switch between sparse reconstruction (`fpreconst`), interpolation (`fpreconst_interp`), and GMM method (`fpreconst_gmm`). 

* Edit line 32 of `testallfunc.m` to specify the set of number of sensors (K) for which you want to get evaluation results. By default K is from 4 sensors (atleast) to 46.  

* Set the corresponding figure flags to get the desired graphs.   


## Citation 
If you find our work useful in your research please consider citing our paper:

```
@inproceedings{farnoosh2017spatially,
  title={Spatially-Continuous Plantar Pressure Reconstruction Using Compressive Sensing},
  author={Farnoosh, Amirreza and Ostadabbas, Sarah and Nourani, Mehrdad},
  booktitle={Machine Learning for Healthcare Conference},
  pages={13--24},
  year={2017}
}

```

## License 
* This code is for non-commercial purpose only. For other uses please contact ACLab of NEU. 
* No maintenance service


