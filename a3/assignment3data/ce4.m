load('e.mat')
load('compEx1data.mat')
load('compEx3data.mat')
im1 = imread('kronan1.JPG');
im2 = imread('kronan2.JPG');


% Triangulate the points using DLT for each of the four camera solutions
U = [1/sqrt(2) -1/sqrt(2) 0; 1/sqrt(2) 1/sqrt(2) 0 ; 0 0 1];
V = [1 0 0; 0 0 -1; 0 1 0];
W = [0 -1 0; 1 0 0; 0 0 1];
P1 = [eye(3) zeros(3, 1)];


u3 = (U(:,3));

P2a = [U * W * V' u3];
P2b = [U * W * V' -u3];
P2c = [U * W' * V' u3];
P2d = [U * W' * V' -u3];

x1n = K \ x{1};
x2n = K \ x{2};

Xa = triangulate(x1n, x2n, P1, P2a);
Xb = triangulate(x1n, x2n, P1, P2b);
Xc = triangulate(x1n, x2n, P1, P2c);
Xd = triangulate(x1n, x2n, P1, P2d);

plot_camera(P1, P2a, Xa)
plot_camera(P1, P2b, Xb)
plot_camera(P1, P2c, Xc)
plot_camera(P1, P2d, Xd)

plot_denorm(K, P2a, Xa, x{2}, im2)
plot_denorm(K, P2b, Xb, x{2}, im2)
plot_denorm(K, P2c, Xc, x{2}, im2)
plot_denorm(K, P2d, Xd, x{2}, im2)

X = pflat(Xa);
figure
plot3(X(1,:), X(2,:), X(3,:), 'm.')
hold on
plotcams({P1, P2a})
plotcams({P1, P2b})
plotcams({P1, P2c})
plotcams({P1, P2d})


function plot_denorm(K, P2, X, x, im)
    P2n = K * P2;
    xn = P2n * X;
    xn = pflat(xn);
    figure
    imagesc(im);
    hold on
    plot(xn(1,:), xn(2,:), 'mo');
    hold on
    plot(x(1,:),x(2,:),'g.');
    hold off

end

function plot_camera(P1, P2, X)
    
    X = pflat(X);
    figure;
    plot3(X(1,:), X(2,:), X(3,:), 'm.')
    hold on
    plotcams({P1, P2})
    hold off

end

function X = triangulate(x1, x2, P1, P2)

    X = [];
    n = length(x1);

    for i=1:n
        M = [P1, -x1(:,i), zeros(3, 1); P2, zeros(3, 1), -x2(:,i)];
        [U,S,V] = svd(M);
        v = V(:, end);
        X = [X, v(1:4,1)];
    end

end