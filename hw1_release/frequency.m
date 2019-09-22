    %% ======================== Fourier series of 1-D function
% define the function (spatial domain)
x = 0:200;
y1 = sin(2*pi*x/10);
y2 = cos(2*pi*x/10)+sin(2*pi*x/5);
y = y2; % you can choose y1 or y2 here, or other functions you like
n = 2000; % sample n points on the function, then compute n-point DFT
% -------------- Write your code here
% you need to compute the Fourier series of function y here
Y = abs(fftshift(real(fft(y,n))));
% -------------- end of your code
freq = ((-n/2) : (n/2-1))/n;
figure(1);
subplot(2,1,1), plot(x,y), title('spatial domain');
subplot(2,1,2), plot(freq, Y), title('frequency domain'), xlabel('frequency / f s');

%% ======================== Fourier transform of 2-D image
img_1 = repmat(peaks(20),[10 10]);
img_2 = rgb2gray(imread('./img/dog.jpg'));
img = img_2;
% % -------------- Write your code here
% % you need to compute the Fourier transform of the image img here
Y = abs(fftshift(fft2(im2double(img))));

% % -------------- end of your code
figure(2);
subplot(1,2,1), imshow(mat2gray(img)), title('Spatial domain image');
subplot(1,2,2), imshow(mat2gray(log(Y+1))), title('Frequency domain image (log magnitude)');

% %% ======================== Subsampling
img = rgb2gray(imread('./img/zebra.jpg'));
k = 2; % subsample the image k times by a factor of 2
% -------------- Write your code here
% you need to subsample the image in two ways:
% 1. a naive method, put result in img_a
% 2. an anti-aliasing method, put result in img_b
img_a=img(1:k:end,1:k:end);
gaussian_filter=fspecial('gaussian', 7, 1);
im_blur = imfilter(img,gaussian_filter);
img_b =im_blur(1:2:end,1:2:end);
% % % -------------- end of your code
figure(3);
subplot(1,3,1), imshow(img), title(['Original ' num2str(size(img, 1)) 'x' num2str(size(img, 2)) ]);
subplot(1,3,2), imshow(img_a), title(['Bad subsampling ' num2str(size(img_a, 1)) 'x' num2str(size(img_a, 2)) ]);
subplot(1,3,3), imshow(img_b), title(['Good subsampling ' num2str(size(img_b, 1)) 'x' num2str(size(img_b, 2)) ]);

%% ========================== Low pass and high pass
img = rgb2gray(imread('./img/dog.jpg'));
% % -------------- Write your code here
% % you need to do low and high pass filtering in *frequency* domain
% % low_pass_img and high_pass_img should be the filtered images in spatial domain
% % for low pass filter, you can consider the Gaussian
% % refer to slides 76-80 for help
% 

img=fftshift(fft2(double(img)));
[img_y,img_x]=size(img);
low_pass_img=zeros(img_y,img_x);
high_pass_img=zeros(img_y,img_x);
for i=1:img_y 
    for j=1:img_x
        d=sqrt((i-floor(img_y/2))^2+(j-floor(img_x/2))^2);
        low_pass_img(i,j)=exp(-d^2/200)*img(i,j);%image processes with low pass filter
        high_pass_img(i,j)=(1-exp(-d^2/200))*img(i,j);%image processes with high pass filter
    end 
end
low_pass_img=uint8(real(ifft2(ifftshift(low_pass_img))));
high_pass_img = uint8(real(ifft2(ifftshift(high_pass_img))));

% % -------------- end of your code
figure(4)
subplot(1,3,1), imshow(img), title('Original image');
subplot(1,3,2), imshow(mat2gray(low_pass_img)), title('Low pass filtered image')
subplot(1,3,3), imshow(mat2gray(high_pass_img)), title('High pass filtered image')
