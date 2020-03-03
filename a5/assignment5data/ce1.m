clear all;
im1=load('kronan1.JPG');
im2=load('kronan2.JPG');

% Load data from A3 computer exercise 4
load('a5data.mat'); 
P2 = K*P2b;
X = pflat(Xb);

P = {P1, P2};
U = pflat(X);
u = {x1n, x2n};

% Histogram before LM
[err_init,res_init] = ComputeReprojectionError(P,U,u);
figure
histogram(res_init);   


% Reprojection error plot
figure;
hold on

lambda = 1;
iterations = 50;

% Levenberg-Marquardt method
for i=1:iterations
    [err,res] = ComputeReprojectionError(P,U,u);
    [r,J] = LinearizeReprojErr(P,U,u);
    C = J'*J+lambda*speye(size(J,2));
    c = J'*r;
    deltav = - C\c;
    [P,U] = update_solution(deltav,P,U);
    plot(i,err,'*');
end

% Histogram after LM
figure;
histogram(res,100);

              

