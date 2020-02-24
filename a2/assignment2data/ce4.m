im1 = imread('cube1.jpg');
im2 = imread('cube2.jpg');

% Compute sift features
[f1, d1] = get_sifty(im1); 
[f2, d2] = get_sifty(im2);

% Match the descriptors
[matches ,scores] = vl_ubcmatch(d1,d2);

x1 = [f1(1,matches(1,:));f1(2,matches(1,:))]; 
x2 = [f2(1,matches(2,:));f2(2,matches(2,:))];

perm = randperm(size(matches ,2)); figure;
imagesc([im1 im2]);
hold on;
plot([x1(1,perm(1:10)); x2(1,perm(1:10))+size(im1,2)], [x1(2,perm(1:10)); x2(2,perm(1:10))],'-');
hold off;


function [f d] = get_sifty(im) 
% Computes the sift features and plots them with the image
figure
[f, d] = vl_sift( single(rgb2gray(im)), 'PeakThresh', 1);
imshow(im)
hold on
vl_plotframe(f);

end