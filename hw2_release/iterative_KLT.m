%***************************************************************************%
% Function:    iterative_KLT                                                % 
% Description: iterative KLT Tracker                                        %
%              Computes the optimal local motion (u,v) from frame It to     %
%              frame It+1 that minimizes the pixel squared difference       %
%              in the two rectangles                                        %
%              Assumes that the rectangle undergoes constant motion         %
%              in a small region rect                                       %
%                                                                           %
%              Input:  It - the image frame It with pixel values in [0,1]   % 
%                      It1 - the image frame It+1 with pixel values in [0,1]%
%                      rect - 4*1 vector [x1, y1, x2, y2]'                  %
%                             where (x1, y1) is the top-left corner         %
%                             (x2, y2) is the bottom-right corner           %
%                             x1,y1,x2,y2 may not be integers               %
%                             The rectangle is inclusive, i.e. it includes  %
%                             all the four corners.                         %
%                                                                           %
%              Output: (u,v) - the movement of rect from It to It1          % 
%                                                                           %
%***************************************************************************%

function [u, v] = iterative_KLT(It, It1, rect)

% ------------------------------ Write your code here
% Initialize u and v
u = 0;
v = 0;

% Get the size of image It1
[It1_x, It1_y] = size(It1);

% Compute gradient of It+1
[gradient_x, gradient_y] = gradient(It1);

% Compute the intensity of the rectangle on It
I1 = It(rect(2,1):1:rect(4,1), rect(1,1):1:rect(3,1));

% Initialize the norm of delta_p 
delta_p_norm = 3;

% Iteratively compute u, v
while(delta_p_norm > 0.1 )
    % Compute the new rectangle based on current u, v 
    % If you encountered numerical issues here, you can try to add a very small value to each coordinate, e.g. 1e-6 
    newx1 = rect(1,1) + u + 1e-6;
    newx2 = rect(3,1) + u + 1e-6;
    newy1 = rect(2,1) + v + 1e-6;
    newy2 = rect(4,1) + v + 1e-6;
    
    [meshx, meshy] = meshgrid(newy1:1:newy2, newx1:1:newx2);
    % Check that whether the new rectangle is out of the image boundary
    if (newx1 < 1 || newx2 > It1_y || newy1 < 1 || newy2 > It1_x )
        error('Window is out of image!') ;
    end
    % Build Lucas-Kanade equation (compute A, b)
    tmp_diff = interp2(1:It1_x, 1:It1_y, It1', meshx, meshy) - I1';
    tmp_Ix = interp2(1:1:It1_x, 1:1:It1_y, gradient_x', meshx, meshy);
    tmp_Iy = interp2(1:1:It1_x, 1:1:It1_y, gradient_y', meshx, meshy);
    A = [tmp_Ix(:), tmp_Iy(:)];
    % Compute delta_p
    delta_p =-(A'*A)\(A'*tmp_diff(:));
    % Update u, v
    u = u + delta_p(1);
    v = v + delta_p(2);
    % Compute the norm of delta_p
    delta_p_norm = norm(delta_p);
end
% ------------------------ end of your code
end