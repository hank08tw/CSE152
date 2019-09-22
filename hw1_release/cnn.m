%% ============================ Prepare data and model
[imgDataTrain, labelsTrain, imgDataTest, labelsTest] = prepareData;
load MNISTModel
net.Layers
% if you successfully installed the Deep Learning toolbox, you should see the architecture of the CNN in the command window

%% ============================ Try prediction
% Just try the following codes, they predict the class of an image
randIndx = randi(numel(labelsTest));
img = imgDataTest(:,:,1,randIndx);
actualLabel = labelsTest(randIndx);
predictedLabel = net.classify(img);
figure(1);
imshow(img);
title(['Predicted: ' char(predictedLabel) ', Actual: ' char(actualLabel)])

%% ============================= Visualize filters in conv1
% ------------------------------ Write your code here
% you need to visualize the filters in conv1, then explain the effect of two filters in your report
% fill the below blank
% you can write other codes before that
% 
figure(2);
for i = 1:16
    subplot(4,4,i), imshow(mat2gray( net.Layers(2).Weights(:,:,1,i)));
    title(['filter ' num2str(i)]);
end
% -------------- end of your code

%% ============================= Network activations of conv1
% ------------------------------ Write your code here
% select 5 samples in imgDataTest, and visualize the activations of conv1 based on the above 2 filters

figure(3);
for i = 1:5
    img=imgDataTest(:,:,1,9*i+1);
    subplot(5,2,(i-1)*2+1), imshow(mat2gray(filter2(img,net.Layers(2).Weights(:,:,1,2))));
    subplot(5,2,(i-1)*2+2), imshow(mat2gray(filter2(img,net.Layers(2).Weights(:,:,1,3))));
end
% -------------- end of your code

%% ============================= Image retrieval based on conv3
k = 5;
search_num = 1000;
% ------------------ Write your code here
% select 3 images in imgDataTest, for each image
% find the 5 most similar images in the first 1000 images of imgDataTrain
% use Euclidean distance on conv3's activations

% figure(4);
% %subplot(1,k+1,1), imshow( ____ );
% title('Original Image');
% for i = 1:k
%     %subplot(1,k+1,i+1), imshow( ____ );
% end
pic1=imgDataTest(:,:,1,100);
pic2=imgDataTest(:,:,1,500);
pic3=imgDataTest(:,:,1,200);

figure(4);
subplot(1,k+1,1), imshow(pic1);
title('leftmost pic is original.');
func=activations(net,pic1,'conv_3');
mat=zeros(1,search_num);
for i=1:search_num
    tmp=imgDataTest(:,:,1,i);
    tmp=activations(net,tmp,'conv_3');
    sd=(func-tmp).^2;
    mat(1,i)=sqrt(sum(sd(:)));
end
sorted_mat=sort(mat);
[first,second]=find(mat<=sorted_mat(5),5);
for i=1:k
    subplot(1,k+1,i+1), imshow(imgDataTest(:,:,1,second(i)) );
end

figure(5);
subplot(1,k+1,1), imshow(pic2);
title('leftmost pic is original.');
func=activations(net,pic2,'conv_3');
for i=1:search_num
    tmp=imgDataTest(:,:,1,i);
    tmp=activations(net,tmp,'conv_3');
    sd=(func-tmp).^2;
    mat(1,i)=sqrt(sum(sd(:)));
end
sorted_mat=sort(mat);
[first,second]=find(mat<=sorted_mat(5),5);
for i=1:k
    subplot(1,k+1,i+1), imshow(imgDataTest(:,:,1,second(i)) );
end

figure(6);
subplot(1,k+1,1), imshow(pic3);
title('leftmost pic is original.');
func=activations(net,pic3,'conv_3');
for i=1:search_num
    tmp=imgDataTest(:,:,1,i);
    tmp=activations(net,tmp,'conv_3');
    sd=(func-tmp).^2;
    mat(1,i)=sqrt(sum(sd(:)));
end
sorted_mat=sort(mat);
[first,second]=find(mat<=sorted_mat(5),5);
for i=1:k
    subplot(1,k+1,i+1), imshow(imgDataTest(:,:,1,second(i)) );
end

% -------------- end of your code
