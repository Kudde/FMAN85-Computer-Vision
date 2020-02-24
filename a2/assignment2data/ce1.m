data = load('compEx1data.mat');

% 3D points of the reconstruction : 4 × 9471
X = data.X;

% Camera Matrices : P{i} camera matrix of image i
P = data.P;

% Image points : x{i} points 3 × 9471 of image i
x = data.x;

% Images : i
imfiles = data.imfiles;

% 3D Reconstruction
%plot_3DReconstruction(X, P)


% PLot first image with all points
% plot_image(1, P, X, x, imfiles)

% Plot Transform
T1 = [1 0 0 0 ; 0 4 0 0 ; 0 0 1 0 ; 1/10 1/10 0 1]
T2 = [1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 1/16 1/16 0 1]
X1 = pflat(T1*X);
X2 = pflat(T2*X);
plot_3DReconstruction(X, P)
%plot_3DReconstruction(X1, P) 
%plot_3DReconstruction(X2, P) 

% Transform to image
% plot_image(1, P, X1, x, imfiles)
% plot_image(1, P, X2, x, imfiles)

function plot_image(i, P, X, x, imfiles)
imi = imread(imfiles{i});
xi = x{i};
Xi = P{i} * X;
project_points(imi, Xi, xi);
end

function plot_3DReconstruction(X, P) 
axis equal
plotcams(P)
hold on
plot3(X(1,:),X(2,:),X(3,:),'.','Markersize',2);
end

function project_points(image, X, x)
% Plot the image, the projected points, and the image points in the same figure.

% Plot image
imshow(image)
hold on

% Plot image points
visible = isfinite(x(1,:));
plot(x(1,visible), x(2,visible),'ro');
hold on
% Plot projected points
xproj = (X./ X(3,:))
plot(xproj(1,visible), xproj(2,visible),'bo');

end