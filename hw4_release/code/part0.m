% install and compile MatConvNet 
% (you can comment out the next three lines if you have already installed MatConvNet beta 16 and the mex files)
untar('http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta16.tar.gz') ;
cd matconvnet-1.0-beta16
run matlab/vl_compilenn

% download a pre-trained CNN from the web (needed once)
urlwrite('http://cs.brown.edu/courses/csci1430/2017_Spring/proj6a/imagenet-vgg-f.mat', ...
         'imagenet-vgg-f.mat') ;

% setup MatConvNet. Your path might be different.
run  '../matconvnet-1.0-beta16/matlab/vl_setupnn'

% load the 233MB pre-trained CNN
net = load('imagenet-vgg-f.mat') ;

% load and preprocess an image
im = imread('peppers.png') ;
im_ = single(im) ; % note: 0-255 range
im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
im_ = im_ - net.normalization.averageImage ;

% run the CNN
res = vl_simplenn(net, im_) ;

% show the classification result
scores = squeeze(gather(res(end).x)) ;
[bestScore, best] = max(scores) ;
figure(1) ; clf ; imagesc(im) ;
title(sprintf('%s (%d), score %.3f',...
net.classes.description{best}, best, bestScore)) ;
