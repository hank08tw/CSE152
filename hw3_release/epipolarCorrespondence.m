%*************************************************************************%
% Function:    epipolarCorrespondence                                     % 
% Description: Slide a window along the epipolar line in im2 and find     %
%              the one that matches most closely to the window around     %
%              the point in im1                                           %  
%                                                                         %
%              Input:  x1 and y1 - The x and y coordinates of a pixel     %
%                                  on im1                                 %
%                                                                         %
%                      F - The 3*3 fundamental matrix                     %
%                                                                         %
%              Output: x2 and y2 - The x and y coordinates of the         %
%                                  corresponding pixel on im1             %
%*************************************************************************%

function [x2, y2] = epipolarCorrespondence(im1, im2, F, x1, y1)

% ------- YOUR CODE HERE
% (note: the code and comments below are provided for reference only)
% (feel free to change or add code if necessary)

% Convert RGB to gray
im1=rgb2gray(im1);
im2=rgb2gray(im2);
x1=round(x1);
y1=round(y1);
% Compute the size of the window depending on the value of the gaussian sigma 
sig=1;
win_size=5;
% Get the patch in image1
[ylen,~]=size(im1);
patch1=getWindow(x1, y1, win_size, im1) ;
tmp=zeros(3,1);
tmp(1,1)=x1;
tmp(2,1)=ylen-y1;
tmp(3,1)=1;
% Compute the epipolar line
I=F'*tmp;
% Get the range of x, y in im2
point=zeros(1,2);                 
[ylen2,xlen2]=size(im2);
% Get the points along the line
cnt=1;
for i= 1:1:ylen2
    tmp1=round(-(I(2,1)*ylen2+I(3,1))/I(1,1));
    tmp2=i;
    if (tmp1+2<xlen2&&tmp1>2&&tmp2+2<=ylen2&&tmp2>2)
        point(cnt,1)=tmp1;
        point(cnt,2)=tmp2;
        cnt=cnt+1;
    end
end
[ylen3,~]=size(point);
% Limit the searching range to a neighborhood


% Get the points that are close to the one in image 1


% Find the correspondence in im2
point2=zeros(3,1);
for i= 1:1:ylen3
    patch2 =getWindow(point(i,1),point(i,2),win_size,im2) ;
    d = computeDifference(patch1, patch2, win_size, sig) ;
    point2(1,i)=d;
    point2(2,i)=point(i,1);
    point2(3,i)=point(i,2);
end
[~,tmp]=min(point2(1,:));
x2 = point2(2,tmp);
y2 = point2(3,tmp);
% ------- END OF YOUR CODE

end

%*************************************************************************%
% Function:    getWindow                                                  % 
% Description: Get the intensity values of the window in the given image  %  
%                                                                         %
%              Input:  x and y - The coordinates of the window center     %
%                      n_row, n_col - The number of rows and columns of   %
%                                     the image                           %
%                      sizeW - The width of the window                    %
%                                                                         %
%              Output: patch                                              %
%*************************************************************************%
function [patch] = getWindow(x, y, sizeW, image)

% ------- YOUR CODE HERE
% (note: the code and comments below are provided for reference only)
% (feel free to change or add code if necessary)

% Compute the boundaries
% ...
down=y+(sizeW-1)/2;
up=y-(sizeW-1)/2;
left=x-(sizeW-1)/2;
right=x+(sizeW-1)/2;
patch = image(up:down,left:right);
% Get patch
% ...
patch =imfilter( patch, fspecial('gaussian', 5, 1) );

% ------- END OF YOUR CODE

end

%*************************************************************************%
% Function:    computeDifference                                          % 
% Description: compute difference between the two windows                 %  
%                                                                         %
%              Input:  patch1 - patch from image1                         %
%                      patch2 - patch from image2                         %
%                      sizeW - The width of the window                    %
%                      sigma                                              %
%                                                                         %
%              Output: d - distance                                       %
%*************************************************************************%
function [d] = computeDifference(patch1, patch2, sizeW, sigma)

% ------- YOUR CODE HERE
% (note: the code and comments below are provided for reference only)
% (feel free to change or add code if necessary)
tmp=(patch1-patch2).^2;
d =sqrt(sum(tmp(:)));
% ------- END OF YOUR CODE

end
