D = load('compEx1.mat');
x2d = D.x2D;
x2d_flat = pflat(x2d);
%plot(x2d_flat(1,:),x2d_flat(2,:),'.')

x3d = D.x3D;
x3d_flat = pflat(x3d);
plot3(x3d_flat(1,:),x3d_flat(2,:),x3d_flat(3,:),'.');