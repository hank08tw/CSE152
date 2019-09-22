%% ========================================== Harris & Feature matching
I1 = double(rgb2gray(imread('./img/building_1.jpg')));
response1 = harris_corners(I1); % get response map by Harris corner dector
keypoints1 = corner_peaks(response1, 45); % find keypoints(corners) according to the response
desc1 = describe_keypoints(I1, keypoints1); % describe the keypoints by your self-designed descriptor

I2 = double(rgb2gray(imread('./img/building_2.jpg')));
response2 = harris_corners(I2);
keypoints2 = corner_peaks(response2, 45);
desc2 = describe_keypoints(I2, keypoints2);

figure(1);
subplot(1,2,1), plot_keypoints(I1, keypoints1), title('Keypoints in image 1');
subplot(1,2,2), plot_keypoints(I2, keypoints2), title('Keypoints in image 2');
pause(0.5);

matches = match_descriptors(desc1, desc2); % match the keypoints accroding to your descriptors
points1 = keypoints1( matches(:, 1), :);
points2 = keypoints2( matches(:, 2), :);
match_plot(I1, I2, points1, points2); % visualize the match

%% ========================================== Try SURF features
I1 = rgb2gray(imread('./img/building_1.jpg'));
I2 = rgb2gray(imread('./img/building_2.jpg'));

% ------------------------------ Write your code here
% you need to find the corresponding points between two images by SURF feature, then visualize the matches
% you can use any built-in functions for this problem
 
[feature1, v1] = extractFeatures(I1, detectSURFFeatures(I1));
[feature2, v2] = extractFeatures(I2, detectSURFFeatures(I2));

indexPairs = matchFeatures(feature1, feature2, 'Prenormalized', true);

figure('name','SURF features');
showMatchedFeatures(I1,I2,v1(indexPairs(:, 1)),v2(indexPairs(:, 2)));
legend('points','corresponding points');

% -------------- end of your code


%% ================================= Functions for Harris
function y = harris_corners(I) % get response map by Harris corner dector
    [m, n] = size(I);
    border=6;
    sigma=2;
    g = fspecial('gaussian', max(1,6*sigma), sigma); % Gaussian window function
    alpha = 0.04; % The constant in corner response function
    % ---------------------------------- Write your code here
    % you need to compute the response map according to corner response function
    % before that, you may need to get the image derivatives and the matrix M
    % since our local feature descriptor needs a patch, we only consider the area I(border+1:n-border,border+1:m-border)
 
    x_gradiance=filter2([-1,0,1],I);%compute gradiance in x direction by [-1,0,1]
    y_gradiance=filter2([-1;0;1],I);%compute gradiance in y direction by [-1;0;1]

    x_gradiance2=x_gradiance.^2;
    y_gradiance2=y_gradiance.^2;
    xy_gradiance2=x_gradiance.*y_gradiance;
    x_gradiance2=filter2(g,x_gradiance2);
    y_gradiance2=filter2(g,y_gradiance2);
    xy_gradiance2=filter2(g,xy_gradiance2);
    [img_y,img_x]=size(I);
    y=zeros(img_y,img_x);

    for i=1:img_y
        for j=1:img_x
            mat=[x_gradiance2(i,j) xy_gradiance2(i,j);xy_gradiance2(i,j) y_gradiance2(i,j)];
            y(i,j)=det(mat)-alpha*(trace(mat))^2;
        end
    end
    y=y(border+1:m-border,border+1:n-border);   

    % -------------- end of your code
end

function y = corner_peaks(response, threshold) % find corners according to the response
    border=6;
    r=6;
    response=(1000/max(max(response)))*response;
    R=response;
    sze = 2*r+1; 
    MX = ordfilt2(R,sze^2,ones(sze));
    response = (R==MX)&(R>threshold); 
	R=R*0;
    R(5:size(response,1)-5,5:size(response,2)-5)=response(5:size(response,1)-5,5:size(response,2)-5);
	[r1,c1] = find(R);
    y = [r1+border+1,c1+border+1]; 
end

function y = plot_keypoints(I, PIP)
   Size_PI=size(PIP,1);
   for r=1: Size_PI
       I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)-2)=255;
       I(PIP(r,1)-2:PIP(r,1)+2,PIP(r,2)+2)=255;
       I(PIP(r,1)-2,PIP(r,2)-2:PIP(r,2)+2)=255;
       I(PIP(r,1)+2,PIP(r,2)-2:PIP(r,2)+2)=255;
   end
   imshow(uint8(I));
   y = 0;
end

%% ================================= Functions for feature matching
function y = simple_descriptor(patch)
% design you own local feature descriptor
    % ---------------------------------- Write your code here          
    Iy=imfilter(patch,[-1 0 1],'replicate');   
    Ix=imfilter(patch,[-1;0;1],'replicate');   
    I_distance=sqrt(Ix.^2+Iy.^2);            
    I_degree=Iy./Ix;               
    num=9;             
    degree=360/num;
    tmpx=Ix;
    tmp_dist=I_distance;
    tmp_dist=tmp_dist/sum(sum(tmp_dist));        
    tmp_degree=I_degree;
    y=zeros(1,num);
     for i=1:12
        for j=1:12
            if isnan(tmp_degree(i,j))==1  
                tmp_degree(i,j)=0;
            end
            angle=mod(atan(tmp_degree(i,j))*180/pi,360);   
            if tmpx(i,j)<0              
                if angle>270           
                    angle=angle-180;      
                end
                if angle<90               
                    angle=angle+180;       
                end
            end
            angle=angle+0.0000001;       
            y(ceil(angle/degree))=y(ceil(angle/degree))+tmp_dist(i,j);   
        end
     end
    y=y/sum(y);
    % -------------- end of your code
end

function ret = describe_keypoints(I, keypoints)
% using the above simple_descriptor() to describle the keypoints
% you may need to find a patch for each keypoint, then call the simple_descriptor()
% your output size should be [num_of_keypoints, feature_size]
    patch_size = 12;
    % ---------------------------------- Write your code here
    I=sqrt(double(I)); 
    [img_y,img_x]=size(keypoints);
    ret=zeros(img_y,10);
    for i=1:img_y
        patch=I(keypoints(i,1):keypoints(i,1)+patch_size-1,keypoints(i,img_x):keypoints(i,img_x)+patch_size-1);       
        y=simple_descriptor(patch);
        ret(i,2:10)=y;
        ret(i,1)=i;
    end
    % -------------- end of your code
end

function num = match_descriptors(desc1, desc2)
% match the keypoints according to your descriptors
% you may need to adjust the threshold according to your distance function
% your output size should be [num_of_matches, 2]
    % ---------------------------------- Write your code here
     [img1_y,img1_x]=size(desc1);
     [img2_y,img2_x]=size(desc2);
     tmp=1;
     num=rand(1,2);
     for i=1:img2_y
         f=desc2(i,2:10);
         for j=1:img1_y
             g=desc1(j,2:10);
             sd=(f-g).^2;
             d=sqrt(sum(sd(:)));
             if d<=0.10
                 num(tmp,1)=desc1(j,1);
                 num(tmp,2)=desc2(i,1);
                 tmp=tmp+1;
             end
         end
     end
    % -------------- end of your code
end

function h = match_plot(img1,img2,points1,points2)
    h = figure;
    colormap = {'b','r','m','y','g','c'};
    height = max(size(img1,1),size(img2,1));
    match_img = zeros(height, size(img1,2)+size(img2,2), size(img2,3));
    match_img(1:size(img1,1),1:size(img1,2),:) = img1;
    match_img(1:size(img2,1),size(img1,2)+1:end,:) = img2;
    imshow(uint8(match_img));
    hold on;
    for i=1:size(points1,1)
        plot([points1(i,2) points2(i,2)+size(img1,2)],[points1(i,1) points2(i,1)],colormap{mod(i,6)+1});
    end
    title('Correspondence');
    hold off;
end
