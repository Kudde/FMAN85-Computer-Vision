data = load('compEx3data.mat');

% 3D point model of the visible cube sides : 3x37
Xmodel = data.Xmodel;

% the measured projections of the model points in the two images 2x(3x37)
x = data.x;

% index used for plotting lines on  the model surface : 126x1
startind = data.startind;
endind = data.endind;

% Plot points
figure(1)
plot_points(x{1}, 'r*')
figure(1)
plot_points(x{2}, 'b*')

% N transform.  
[x1n, N1] = transform_by_N(x{1});
[x2n, N2] = transform_by_N(x{2});

%[x1n, N1] = transform_by_I(x{1});
%[x2n, N2] = transform_by_I(x{2});
%[x, Xmodel] = remove_points(x, Xmodel)

figure(2)
plot_points(x1n, 'r*')
figure(2)
plot_points(x2n, 'b*')


% DLT
M1 = setup_DLT(x1n, Xmodel);
M2 = setup_DLT(x2n, Xmodel);

% Solve
v1 = solve_DLT(M1);
v2 = solve_DLT(M2);

% Camera Matrix
P1 = setup_camera(v1, N1)
P2 = setup_camera(v2, N2)

% Project the model points onto the images
image1 = imread('cube1.jpg');
image2 = imread('cube2.jpg');

X = [Xmodel ; ones(1, size(Xmodel, 2))];
px1 = pflat(P1 * X);
px2 = pflat(P2 * X);

figure(3);
plot_image(image1, px1, x{1})

figure(4);
plot_image(image2, px2, x{2})

figure(5);
plot_model(Xmodel, startind, endind, {P1, P2})

% Inner parameter s
[K1, R1] = rq(P1)
[K2, R2] = rq(P2)

function [xNew, XmodelNew] = remove_points(x, Xmodel)
% removes all points except 1, 4, 13, 16, 25, 28, 31
XmodelNew = Xmodel(:,[1, 4, 13, 16, 25, 28, 31])
xNew{1} = x{1}(:,[1, 4, 13, 16, 25, 28, 31])
xNew{2} = x{2}(:,[1, 4, 13, 16, 25, 28, 31])
end

function plot_image(image, px, x)
% Project the model points and measured points on the image

imshow(image)
hold on
plot(px(1,:), px(2,:), 'y*', 'Markersize', 10)
plot(x(1,:), x(2,:), 'g*', 'Markersize',10)
hold off;
end

function plot_model(Xmodel, startind, endind, P)
% Plot model, camera centers and viewing directions 
plot3([Xmodel(1,startind); Xmodel(1,endind)],... 
    [Xmodel(2,startind); Xmodel(2,endind)],... 
    [Xmodel(3,startind); Xmodel(3,endind)],'b-');
hold on;
plot3(Xmodel(1,:), Xmodel(2,:), Xmodel(3,:),'*m','Markersize',5)
plotcams(P)
hold off;

end

function P = setup_camera(v, N)
% set up the camera matrix
 
% Takes the first 12 entries of sol and row-stacks them in a 3x4 matrix
% and solves P
P = N \ reshape(-v(1:12),[4 3])';

end

function v = solve_DLT(M)
% Solves the homogeneous least squares system

%Computes the singular value decomposition of M
[U,S,V] = svd(M); 

% v = last col of V
v = V(:,end);

% Euclidean length
min = norm(M*v)

end

function M = setup_DLT(xN, Xmodel) 
% Set up the DLT equations for resectioning, 

l = size(Xmodel,2);
rows = l * 3;
cols = 4*3 + l;
M = zeros(rows,cols);

for i = 1:l
    M(((i-1) * 3) + 1, 1:4) = [Xmodel(:,i); 1]';
    M(((i-1) * 3) + 2, 5:8) = [Xmodel(:,i); 1]';
    M(i * 3,          9:12) = [Xmodel(:,i); 1]';
    M(((i-1) * 3) + 1:3 * i, 12 + i) = -xN(:,i);
end

end

function [xN, N] = transform_by_I(x) 
% returns an transform matrix equal to the identity matrix

N = [1   0  0
     0   1  0
     0   0  1];

xN = N*x;

end

function [xN, N] = transform_by_N(x) 
% subtract the mean of the points 
% re-scales the coordinates by the standard deviation in each coordinate

m = mean(x(1:2,:),2) ;
s =  std(x(1:2,:),0,2) ;

N = [1/s(1)   0       -m(1)/s(1)
     0       1/s(2)  -m(2)/s(2)
     0       0       1];

xN = N*x;

end

function plot_points(x, dots)
hold on
plot(x(1,:),x(2,:), dots, 'MarkerSize', 3);
end

