data    = load('compEx1data.mat');
im1     = imread('kronan1.JPG');
im2     = imread('kronan2.JPG');
x       = data.x;

% N transform.  
[x1n, N1] = transform_by_N(x{1});
[x2n, N2] = transform_by_N(x{2});

% Set up the matrix M
M = setup_M(x1n, x2n);

% Solve with SVD
[U,S,V] = svd(M);

% Check
v = V(:,end);
norm(M*v)

% Construct the normalized fundamental matrix
Fn = reshape(v,[3 3])
[U,S,V] = svd(Fn);
S(3,3) = 0;
Fn = U * S * V'; 

% Check determinant
det(Fn)

% Check epipolar constraints ~ 0
% plot(diag(x2n'*Fn*x1n));


% Compute the un-normalized fundamental matrix F
F = N2' * Fn * N1;
F = F./ F(3, 3)
save('f.mat','F');

% Compute epipolar lines l = Fx1
l = F * x{1};
l = l ./ sqrt(repmat( l(1 ,:).^2 + l(2 ,:).^2 ,[3 1]));

% Pick 20 points in the second image at random
rp = randi(length(x{2}), 20, 1);

% Plot these in the same figure as the image
figure;
imshow(im2);
hold on;
x2x = x{2}(1,rp);
x2y = x{2}(2,rp);
plot(x2x, x2y,'m*','Markersize', 30)
rital(l(:,rp));
hold off

% Compute the distance between all the points 
% and their corresponding epipolar lines
figure;
histogram(abs(sum(l.*x{2})),100);

% What is the mean distance?
md = mean(abs(sum(l.*x{2})))



function M = setup_M(x1n, x2n) 
    n = length(x1n);
    M = zeros(n ,9);

    for i = 1:n
        xx=x2n(:,i)*x1n(:,i)';
        M(i,:)=xx(:)';      
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