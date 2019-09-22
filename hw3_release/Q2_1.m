%*************************************************************************%
% Script for Q2.1 of homework 3                                           %
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

% Visualize the correctness of the estimated F
displayEpipolarF(I1, I2, F) ;

% Save F and M
save('Q2_1.mat', 'F', 'M', 'pts1', 'pts2') ;

