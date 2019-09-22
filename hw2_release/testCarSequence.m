%*************************************************************************%
% Function:    testCarSequence                                            % 
% Description: Run the iterative KLT Tracker to track the speeding car    %
%              in the given video                                         %
%                                                                         %
%              box - a n*4 matrix, n is number of frames and each row     %
%                    in the matrix contains 4 numbers: [x1,y1,x2,y2]      %
%                    which indicates the coordinates of top-left and      %
%                    bottom-right corners of the tracked rectangles       %
%                                                                         %
%*************************************************************************%

% Loads the video sequence
load('carSequence.mat') ;
N_frames = size(sequence, 4) ;

% Initialize box
box = zeros(N_frames, 4) ;

% Initial position of the rectangle
rect = [328, 213, 419, 265]' ;
box(1,:) = rect' ;

% ------------------------------ Write your code here
% Compute the width and height of the rectangle
width = abs(rect(3,1)-rect(1,1));
height = abs(rect(2,1)-rect(4,1));

% Get the first frame
It = sequence(:, :, :, 1) ;
It_color = It ;
It = rgb2gray (It) ;
It = im2double (It)  ;

% Draw the initial rectangle
figure ;
imshow(It_color) ;

rectangle('Position',[rect(1), rect(2), width, height], 'LineWidth',1.5,'edgecolor','y') ;
drawnow() ;    

% Track the car from the second frame
for i = 2:N_frames
    
    % Read next frame in the sequence 
    It_i=sequence(:, :, :, i);
    It_i = rgb2gray (It_i) ;
    It_i = im2double (It_i)  ;
    % call iterative_KLT to compute [u, v]
    [u, v] = iterative_KLT(im2double(rgb2gray (sequence(:, :, :, i-1))), It_i, rect);
    
    % Update rectangle's position
    rect(1,1)=rect(1,1)+u;
    rect(2,1)=rect(2,1)+v;
    rect(3,1)=rect(3,1)+u;
    rect(4,1)=rect(4,1)+v;
    % Record rectangle in box
    box(i,:) = rect';
    % Draw the rectangle
    imshow( sequence(:, :, :, i) ) ;
    rectangle('Position',[rect(1), rect(2), width, height], 'LineWidth',1.5,'edgecolor','y') ;
    drawnow() ;
    
    % Go to the next frame
    
end
% -------------- end of your code

% Save box in carPosition.mat
save('carPosition.mat', 'box') ;


