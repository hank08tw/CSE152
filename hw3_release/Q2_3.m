%*************************************************************************%
% Script for Q2.3 of homework 3                                           %
%*************************************************************************%

% Read the two images and convert them to double
I1 = imread('temple/im1.png') ;
I1 = im2double(I1) ;
I2 = imread('temple/im2.png') ;
I2 = im2double(I2) ;

% Get the scalar M, the largest image dimension
M = max(size(I1, 1), size(I1, 2)) ;

% Load the correspondences for the eight point algorithm
load('temple/some_corresp.mat') ;

% Compute the fundamental matrix using the eight point algorithm
F = eightpoint(pts1, pts2, M) ;

% Test the function epipolarCorrespondence
[coordsIM1, coordsIM2] = epipolarMatchGUI(I1, I2, F) ;

% Save F and the correspondences found by epipolarCorrespondence
save('Q2_3.mat', 'F', 'coordsIM1', 'coordsIM2') ;