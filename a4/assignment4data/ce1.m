load('compEx1data.mat')
im1 = imread('house1.jpg');
im2 = imread('house2.jpg');

% Solve the total least squares problem with all the points

X = pflat(X);


[plane, eRMS] = least_square(X);

% How many inliers do you get?
inliers = abs(plane'*X) <= 0.1;
inliers_nbr = sum(inliers(:) == 1)

% Compute the RMS distance between the plane obtained with RANSAC 
% and the distance to the 3D points 
% Plot the absolute distances between the plane and the points in a histogram with 100 bins.
figure;
histogram(abs(plane' * X), 100);

% Solve the total least squares problem with only the inliers
X = X(:,inliers);
[plane, eRMS] = least_square(X);
figure;
histogram(abs(plane' * X), 100);

% Plot the projection of the inliers into the images
plot_to_image(im1, P{1}, X);
plot_to_image(im2, P{2}, X);


% Compute Homography
P1n = K \ P{1};
P2n = K \ P{2};
V = pflat(P1n * X);
U = pflat(P2n * X);

R = P2n(1:3,1:3);
t = P2n(:,4);
pi = pflat(plane);
H = (R -t * pi(1:3)');

% Transform the points using the homography
H = pflat(H*V);
u = K * U;
v = K * H;

figure;
imshow(im2);
hold on
plot(u(1,:), u(2,:), 'mo');
plot(v(1,:), v(2,:), 'g*');


function plot_to_image(im, P, X)
    figure
    imagesc(im);
    hold on
    x = P * X;
    x = pflat(x);
    plot(x(1,:), x(2,:), 'm*')

end

function [plane, eRMS] = least_square(X)
% Solves the total least squares problem with all the points
  
    meanX = mean(X,2);
    Xtilde = (X - repmat(meanX ,[1 size(X,2)]));
    M = Xtilde(1:3,:)*Xtilde(1:3,:)'; 
    
    % Compute eigenvalues and eigenvectors of M
    [V,D] = eig(M); 
    
    % Create plane
    t = V(:,1);
    d = -t' * meanX(1:3);
    plane = [t; d];
    plane = plane./norm(plane(1:3));
    
    % Compute the RMS error
    eRMS = sqrt(sum((plane'*X).^2)/size(X,2));
end