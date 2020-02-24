

% Load and plot the image
image = imread('compEx2.jpg');
imshow(image)
hold on


% Plot the image points in the same figure as the image
D = load('compEx2.mat');

draw_line(D.p1(1,:), D.p1(2,:))
draw_line(D.p2(1,:), D.p2(2,:))
draw_line(D.p3(1,:), D.p3(2,:))

xy = plot_intersection(D)
d = distance(xy, D.p1(1,:), D.p1(2,:))

function draw_line(x_point, y_point)
    % Draw a line through the x and y points 
    % x_point, vector of x coord
    % y_point, vector of y coord
    k = (y_point(2) - y_point(1)) / (x_point(2) - x_point(1));

    x = [0 2000];
    y = k * (x - x_point(1)) + y_point(1);

    line(x, y, 'Color', 'm', 'LineWidth', 3);
end

function xy = plot_intersection(D)
    x1 = D.p2(1,1);
    x2 = D.p2(1,2);

    y1 = D.p2(2,1);
    y2 = D.p2(2,2);

    x3 = D.p3(1,1);
    x4 = D.p3(1,2);

    y3 = D.p3(2,1);
    y4 = D.p3(2,2);
    
    xy = [x1*y2-x2*y1,x3*y4-x4*y3]/[y2-y1,y4-y3;-(x2-x1),-(x4-x3)];
    plot(xy(1), xy(2),'Marker', 'o', 'MarkerSize', 10, 'Color', 'c', 'LineWidth', 3)
end

function d = distance(point , x_line, y_line) 
  
    a = y_line(1) - y_line(2);
    b = x_line(1) - x_line(2);
    c = x_line(2) * y_line(1) - y_line(2) * x_line(1);
    x = point(1);
    y = point(2);

    line(x, y, 'Color', 'r', 'LineWidth', 3);
    
    d = abs(a * x - b * y - c) / sqrt(a^2 + b^2);
end

