load('carPosition.mat') ;

% Loads the video sequence
load('carSequence.mat') ;

% Compute the width and height of the window
width = box(1,3) - box(1,1) + 1 ;
height = box(1,4) - box(1,2) + 1 ;


figure;
% Get the 1,20,50,100 frame
It1 = sequence(:, :, :, 1) ;
% Draw the rectangle
subplot(2,2,1), imshow(It1);
rectangle('Position',[box(1,1), box(1,2), width, height], 'LineWidth',1.5,'edgecolor','y') ;

It20 = sequence(:, :, :, 20) ;
% Draw the rectangle
subplot(2,2,2), imshow(It20);
rectangle('Position',[box(20,1), box(20,2), width, height], 'LineWidth',1.5,'edgecolor','y') ;

It50 = sequence(:, :, :, 50) ;
% Draw the rectangle
subplot(2,2,3), imshow(It50);
rectangle('Position',[box(50,1), box(50,2), width, height], 'LineWidth',1.5,'edgecolor','y') ;

It100 = sequence(:, :, :, 100) ;
% Draw the rectangle
subplot(2,2,4), imshow(It100);
rectangle('Position',[box(100,1), box(100,2), width, height], 'LineWidth',1.5,'edgecolor','y') ;