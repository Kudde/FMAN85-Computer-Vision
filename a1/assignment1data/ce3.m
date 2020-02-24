D = load('compEx3.mat');
startpoints = D.startpoints;
endpoints = D.endpoints;
% [xStart, xEnd] , [yStart, yEnd]
plot([startpoints(1,:); endpoints(1,:)], [startpoints(2,:); endpoints(2,:)],'b-');
axis equal
hold on


h1 = [sqrt(3) -1 1 ; 1 sqrt(3) 1 ; 0 0 2]
h2 = [1 -1 1 ; 1 1 0 ; 0 0 1]
h3 = [1 1 0 ; 0 2 0 ; 0 0 1]
h4 = [sqrt(3) -1 1 ; 1 sqrt(3) 1 ; 1/4 1/2 2]

plot_transform(startpoints, endpoints, h4)






function plot_transform(startpoints, endpoints, H)
xStart = startpoints(1,:);
yStart = startpoints(2,:);

xEnd = endpoints(1,:);
yEnd = endpoints(2,:);

start_transformed = transform_points(H, xStart, yStart);
end_transformed = transform_points(H, xEnd, yEnd);

plot([start_transformed(1,:); end_transformed(1,:)], [start_transformed(2,:); end_transformed(2,:)],'m-');

end

function np = transform_points(H, x, y)
% H is a 3x3 transformation matrix
sz = size(x(:));
points = [x(:) , y(:), ones(sz)];
np = pflat(H*points.');

end