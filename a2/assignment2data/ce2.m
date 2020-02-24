data = load('compEx1data.mat');

% 3D points of the reconstruction : 4 × 9471
X = data.X;

% Camera Matrices : P{i} camera matrix of image i
P = data.P;

% Image points : x{i} points 3 × 9471 of image i
x = data.x;

% Images : i
imfiles = data.imfiles;

% Transform
T1 = [1 0 0 0 ; 0 4 0 0 ; 0 0 1 0 ; 1/10 1/10 0 1]
T2 = [1 0 0 0 ; 0 1 0 0 ; 0 0 1 0 ; 1/16 1/16 0 1]
X1 = pflat(T1*X);
X2 = pflat(T2*X);


[K1,R1] = rq(X1);
K1 = K1./ K1(3,3)

[K2,R2] = rq(X2);
K2 = K2./ K2(3,3)