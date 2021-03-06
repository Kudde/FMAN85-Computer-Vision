imA = imread('a2.jpg');
imB = imread('b2.jpg');

% Begin by loading the two images in Matlab and displaying them
figure
imshow(imA);
figure
imshow(imB);

% se VLFeat to compute SIFT features for both images and match them
[fA, dA] = vl_sift( single(rgb2gray(imA)) ); 
[fB, dB] = vl_sift( single(rgb2gray(imB)) );

matches = vl_ubcmatch(dA,dB);

xA = fA(1:2,matches(1,:)); 
xB = fB(1:2,matches(2,:));

% How many SIFT features did you find for the two images, respectively? 
% How many matches did you find?
featuresA = size(fA)
featuresB = size(fB)
matchSize = size(matches)

% Use RANSAC to find a set of good correspondences

xA(3,:) = 1;
xB(3,:) = 1;

bestH = [];
bestInliers = 0;

iterations = 10;
threshold = 5;
n = size(matches,2);


for i=1:iterations
    
    randind = randperm(n,4);    
    xAi = xA(:,randind);                          
    xBi = xB(:,randind);
    
    M       = setup_M(xAi,xBi);
    [U,S,V] = svd(M);                         
    v       = V(:,end);
    H       = reshape(v(1:9,1),[3 3])';                     
    mayH    = pflat(H*xA);
    inliers = 0;
  
    for k = 1:n
        if norm(abs(mayH(:,k) - xB(:,k))) <= threshold
            inliers = inliers+1;
        end
    end
    
    if inliers >= bestInliers
        bestH = H;
        bestInliers = inliers
    end
end

bestH
bestInliers

tform = maketform('projective',bestH');

transfbounds = findbounds(tform ,[1 1; size(imA,2) size(imA,1)]);
xdata = [min([transfbounds(:,1); 1]) max([transfbounds(:,1); size(imB,2)])]; 
ydata = [min([transfbounds(:,2); 1]) max([transfbounds(:,2); size(imB,1)])];

[newA] = imtransform(imA,tform,'xdata',xdata,'ydata',ydata);
tform2 = maketform('projective',eye(3));
[newB] = imtransform(imB,tform2,'xdata',xdata,'ydata',ydata,'size',size(newA));
newAB = newB;
newAB(newB < newA) = newA(newB < newA);

figure()
imagesc(newAB);

function M = setup_M(v, u) 
    l1 = size(v,1);
    l2 = size(v,2);
    M = zeros(l2 * 3, l1*3 + l2);
    for i=1:size(v,2)
        M(3*(i-1)+1    ,1:l1)        = v(:,i)';
        M(3*(i-1)+2    ,l1+1:2*l1)   = v(:,i)';
        M(3*i          ,l1*2+1:l1*3) = v(:,i)';
        M(3*(i-1)+1:3*i,3*l1+i)      =-u(:,i);
    end
end