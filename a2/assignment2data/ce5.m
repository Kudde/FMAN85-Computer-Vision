im1 = imread('cube1.jpg');
im2 = imread('cube2.jpg');

% Compute sift features
[f1, d1] = vl_sift( single(rgb2gray(im1)), 'PeakThresh', 1); 
[f2, d2] = vl_sift( single(rgb2gray(im2)), 'PeakThresh', 1);

% Match the descriptors
[matches ,scores] = vl_ubcmatch(d1,d2);

x1 = [f1(1,matches(1,:));f1(2,matches(1,:))]; 
x2 = [f2(1,matches(2,:));f2(2,matches(2,:))];

% Set up the DLT
data = load('compEx3data.mat');
Xmodel = data.Xmodel;
x = data.x;
startind = data.startind;
endind = data.endind;

[Pa, Pb] = DLT(x, Xmodel);

% Solve the homogeneous least squares system
X = [];
O = zeros(3, 1);
for i=1:length(x1)
    x1i = [x1(:,i);1];
    x2i = [x2(:,i); 1];
    M = [Pa -x1i O ; Pb O -x2i];
    [U,S,V] = svd(M);
    v = V(:, end);
    X = [X v(1:4,:)];
end


% Remove points that are not good enough
xproj1 = pflat(Pa*X); 
xproj2 = pflat(Pb*X); 

% Finds the points with reprojection error less than 3 pixels in both images
good_points = (sqrt(sum((x1-xproj1(1:2,:)).^2)) < 3 & ... 
    sqrt(sum((x2-xproj2(1:2,:)).^2)) < 3);
X = X (: , good_points );

% Update projections
xproj1 = pflat(Pa*X);
xproj2 = pflat(Pb*X);

% PLot 
plot_image(xproj1, x1, im1)
plot_image(xproj2, x2, im2)

%3d plot
figure
X = pflat(X);
plot3(X(1,:), X(2,:), X(3,:), '.m','Markersize', 5)
hold on
plot3([Xmodel(1,startind);  Xmodel(1,endind)],...
      [Xmodel(2,startind );  Xmodel(2,endind )],...
      [Xmodel(3,startind );  Xmodel(3,endind)],'b-');
plotcams({Pa, Pb})

function plot_image(xproj, x, im)
    figure
    imshow(im);
    hold on;
    plot(xproj(1,:),xproj(2,:),'+m','Markersize', 10);
    plot(x(1,:),x(2,:),'og')
    hold off;
end

function [Pa, Pb] = DLT(x, Xmodel)
    
    [x1n, N1] = transform_by_N(x{1});
    [x2n, N2] = transform_by_N(x{2});

    % DLT
    M1 = setup_DLT(x1n, Xmodel);
    M2 = setup_DLT(x2n, Xmodel);

    % Solve
    v1 = solve_DLT(M1);
    v2 = solve_DLT(M2);

    % Camera Matrix
    Pa = N1 \ reshape(-v1(1:12),[4 3])';
    Pb = N2 \ reshape(-v2(1:12),[4 3])';



end

function v = solve_DLT(M)
% Solves the homogeneous least squares system

    %Computes the singular value decomposition of M
    [U,S,V] = svd(M); 
    v = V(:,end);

end

function M = setup_DLT(xN, Xmodel) 
% Set up the DLT equations for resectioning, 

    l = size(Xmodel,2);
    rows = l * 3;
    cols = l + 4*3;
    M = zeros(rows, cols);

    for i = 1:l
        M(((i-1) * 3) + 1, 1:4) = [Xmodel(:,i); 1]';
        M(((i-1) * 3) + 2, 5:8) = [Xmodel(:,i); 1]';
        M(i * 3,          9:12) = [Xmodel(:,i); 1]';
        M(((i-1) * 3) + 1:3 * i, 12 + i) = -xN(:,i);
    end

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



