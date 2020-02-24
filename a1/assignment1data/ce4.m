% null(P) %computes the nullspace of P
% P(3,1:3) %extracts elements P31, P32 and P33.

% quiver3(a(1),a(2),a(3),v(1),v(2),v(3),s) 
% Plots a vector v starting from 
% the point a and rescales the sise by s

% plot(x1(1,:),x1(2,:),?.?,?Markersize?,2);
% Same as plot but with smaller points

D = load('compEx4.mat');
U = D.U;
P1 = D.P1;
P2 = D.P2;

image = imread('compEx4im1.jpg');
image2 = imread('compEx4im2.jpg');
%imshow(image)
c1 = center_of(P1)
c2 = center_of(P2)

 c2 = pflat(c2)

v1 = P1(3,1:3);
v2 = P2(3,1:3);
v1 = v1/norm(v1);
v2 = v2/norm(v2);

u = pflat(U);
%plot3(u(1,:),u(2,:),u(3,:),'.','Markersize',2);
hold on

x = [c1(1) c2(1)];
y = [c1(2) c2(2)];
z = [c1(3) c2(3)];

vx = [v1(1) v2(1)];
vy = [v1(2) v2(2)];
vz = [v1(3) v2(3)];
%quiver3(x, y, z, vx, vy, vz, 1)

% project points
%project_points(image, P1, U)
%project_points(image2, P2, U)


function project_points(image, P, U)
% project points into image
% v = PX
v = P*U;
v2D = pflat(v);
imshow(image)
hold on
plot(v2D(1,:),v2D(2,:), 'ro', 'MarkerSize', 1, 'LineWidth', 1);
end

function C = center_of(P)
% Get the camera center of the 3x4 matrix P
    P1_13 = P(1:3,1:3);
    P1_4 = P(1:3,4);
    C = -P1_13^(-1)*P1_4;
end
