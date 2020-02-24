load('f.mat')
load('compEx1data.mat')
im1 = imread('kronan1.JPG');
im2 = imread('kronan2.JPG');

% Compute the camera matrices
[x1n, N1] = transform_by_N(x{1});
[x2n, N2] = transform_by_N(x{2});

P1 = [eye(3) zeros(3, 1)]
P1n = N1*P1;

e2 = null(F');
e2x = [0 -e2(3) e2(2); e2(3) 0 -e2(1); -e2(2) e2(1) 0];

P2 = [e2x * F e2]
P2n = N2 * P2;

% Triangulate
[M, X] = triangulate(x1n,x2n, P1n, P2n);

% PLot images
project_to_image(im1, P1n, N1, X, x{1})
project_to_image(im2, P2n, N2, X, x{2})

% Plot figure
figure
X = pflat(X);
plot3(X(1,:), X(2,:), X(3,:), '.')


function project_to_image(im, Pn, N, X, x)
    figure
    xproj = pflat(Pn * X);
    xprojn = N\xproj;
    imagesc(im)
    hold on
    plot(xprojn(1,:), xprojn(2,:), 'm*')
    plot(x(1,:), x(2,:), 'bo')
end

function [M, X] = triangulate(x1,x2, P1, P2)

    X = [];
    n = length(x1);

    for i=1:n
        M = [P1, -x1(:,i), zeros(3, 1); P2, zeros(3, 1), -x2(:,i)];
        [U,S,V] = svd(M);
        v = V(:, end);
        X = [X, v(1:4,1)];
    end

end



function [xN, N] = transform_by_N(x) 
% subtract the mean of the points 
% re-scales the coordinates by the standard deviation in each coordinate
% returns normailized image points xN

    m = mean(x(1:2,:),2) ;
    s =  std(x(1:2,:),0,2) ;

    N = [1/s(1)   0       -m(1)/s(1)
         0       1/s(2)  -m(2)/s(2)
         0       0       1];

    xN = pflat(N*x);

end