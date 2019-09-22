%% ======================== Images
% Open image and convert it to grayscale
img_1 = imread('./img/dog.jpg');
img_1 = rgb2gray(img_1);
% Another very simple image
img_2 = zeros(9);
img_2(4:6, 4:6)=1;
% Show image
img = img_1; % you can choose img_1 or img_2 here, or other images you like
figure(1);
imshow(img);
title('Original image');
pause(0.1);

%% ======================== Filters
filter_1 = [
1 0 -1;
2 0 -2;
1 0 -1;
];
filter_2 = [
1 1 1 1;
1 1 1 1;
1 1 1 1;
1 1 1 1;
] * (1/16);

filter = filter_1; % you can choose filter_1 or filter_2 here, or other filters you like

%% ======================== Convolution
my_output = my_conv2d(img, filter);
expected_outoput = conv2(img, filter, 'same');
figure(2);
subplot(1,2,1), imshow(uint8(my_output)), title('My output');
subplot(1,2,2), imshow(uint8(expected_outoput)), title('Expected output');
pause(0.1);

% ----- Your my_conv2d function should get the same results with the built-in function
if max(my_output - expected_outoput) < 1e-6
    fprintf('Your conv function is correct.\n');
else
    fprintf('Your conv function is not correct.\n');
end

%% ======================== Correlation
my_output = my_corr2d(img, filter);
expected_outoput = filter2(filter, img);
figure(3);
subplot(1,2,1), imshow(uint8(my_output)), title('My output');
subplot(1,2,2), imshow(uint8(expected_outoput)), title('Expected output');
pause(0.1);

% ----- Your my_corr2d function should get the same results with the built-in function
if max(my_output - expected_outoput) < 1e-6
    fprintf('Your corr function is correct.\n');
else
    fprintf('Your corr function is not correct.\n');
end

%% =========================
function y = my_conv2d(I,f)
% I is the image, f is the filter
    I = double(I);[I_y,I_x]=size(I);
    [f_y,f_x]=size(f);
    
    % ------------------------ Write your code here
    y = double(zeros(I_y,I_x));
    for i=1:I_y
        for j=1:I_x
            sum=0;
            for k=1:f_y
                for z=1:f_x
                    if k+i-ceil(f_y/2)>=1 && k+i-ceil(f_y/2)<=I_y && z+j-ceil(f_x/2)>=1 && z+j-ceil(f_x/2)<=I_x
                        sum=sum+I(i+k-ceil(f_y/2),j+z-ceil(f_x/2))*f(f_y-k+1,f_x-z+1);
                    end
                end
            end
            y(i,j)=sum;
        end
    end
    % -------------- end of your code
end

function y = my_corr2d(I,f)
% I is the image, f is the filter
    I = double(I);
    [I_y,I_x]=size(I);
    [f_y,f_x]=size(f);
    % ------------------------ Write your code here
    y = double(zeros(I_y,I_x));
    for i=1:I_y
        for j=1:I_x
            sum=0;
            for k=1:f_y
                for z=1:f_x
                    if k+i-ceil(f_y/2)>=1 && k+i-ceil(f_y/2)<=I_y && z+j-ceil(f_x/2)>=1 && z+j-ceil(f_x/2)<=I_x
                        sum=sum+I(i+k-ceil(f_y/2),j+z-ceil(f_x/2))*f(k,z);
                    end
                end
            end
            y(i,j)=sum;
        end
    end
    % -------------- end of your code
end