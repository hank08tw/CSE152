%*************************************************************************%
% Function:    eightpoint                                                 % 
% Description: Estimate the fundamental matrix F using N given            %
%              correspondences (N>=8)                                     %  
%                                                                         %
%              Input:  X and Y - each N x 2 matrices with coordinates     % 
%                                that constitute correspondences with     % 
%                                the first and second image respectively  %
%                                                                         %
%                      M - a scalar used to scale F which is equal to the %
%                          largest image dimension                        %
%                                                                         %
%              Output: F - the 3 x 3 fundamental matrix                   %
%*************************************************************************%

function [F] = eightpoint(X, Y, M)
% Check equal size
if ( (size(X,1) ~= size(Y,1)) || (size(X,2) ~= size(Y,2)) )
    error('X and Y must have the same size.') ;
end

% Need at least 8 point pairs
N = size(X, 1) ;
if (N < 8)
    error('At least 8 point pairs are required to compute F') ;
end

% % ------- YOUR CODE HERE
[ylen,~]=size(X);
z=zeros(3,1);
z2=zeros(3,1);
t=zeros(3,3);
t(1,1)=1/M;
t(2,2)=1/M;
t(3,3)=1;
for i=1:1:ylen
    z(1,1)=X(i,1);
    z(2,1)=X(i,2);
    z(3,1)=1;
    z2(1,1)=Y(i,1);
    z2(2,1)=Y(i,2);
    z2(3,1)=1;
    z=t*z;
    z2=t*z2;
    X(i,1)=z(1,1);
    X(i,2)=z(2,1);
    Y(i,1)=z2(1,1);
    Y(i,2)=z2(2,1);
end
U=ones(ylen,9);
for i=1:1:ylen
    tmpv=X(i,2);
    tmpu=X(i,1);
    ylen2=Y(i,2);
    xlen2=Y(i,1);
    U(i,1)= xlen2*tmpu;
    U(i,2)=xlen2*tmpv;
    U(i,3)=xlen2;
    U(i,4)=ylen2*tmpu;
    U(i,5)=ylen2*tmpv;
    U(i,6)=ylen2;
    U(i,7)=tmpu;
    U(i,8)=tmpv;
    U(i,9)=1;
end
[~,~,V] = svd(U);
F=zeros(3,3);
cnt=1;
for i=1:1:3
    for j=1:1:3
        F(i,j)=V(cnt,9);
        cnt=cnt+1;
    end
end

[U,S,V]=svd(F);
S(3,3)=0;
F = U*S*V'; 
F=t'*F*t;

% % ------- END OF YOUR CODE

end

