load('compEx1data.mat') 
load('compEx3data.mat')
im1 = imread('kronan1.JPG');
im2 = imread('kronan2.JPG');

% Normalize the image points using the inverse of K
x1n = K \ x{1};
x2n = K \ x{2};

% Set up the matrix M
M = setup_M(x1n, x2n);

% Solve with SVD
[U,S,V] = svd(M);

% Check
v = V(:,end);
norm(M*v)

% Construct the Essential matrix from the solution v.
Eapprox = reshape(v,[3 3]);
[U,S,V] = svd(Eapprox);
if det(U * V') > 0
    E = U * diag([1 1 0]) * V';
else
    V = -V;
    E = U * diag([1 1 0]) * V'; 
end

% Check the epipolar constraints ~ 0
m = mean(diag(x2n' * E * x1n))
E = E./E(3,3)
save('e.mat','E');

% Compute the fundamental matrix for the un-normalized coordinate system
F = K' \ E / K

% Compute the epipolar lines

l = F * x{1};
l = l./sqrt(repmat(l(1 ,:).^2 + l(2 ,:).^2 ,[3 1]));

% Pick 20 points in the second image at random
rp = randi(length(x{2}), 20, 1);

% Plot these in the same figure as the image
figure;
imshow(im2);
hold on;
x2x = x{2}(1,rp);
x2y = x{2}(2,rp);
plot(x2x, x2y,'c.','Markersize', 30)
rital(l(:,rp));
hold off

% Compute the distance between all the points 
% and their corresponding epipolar lines
figure;
histogram(abs(sum(l.*x{2})),100);
md = mean(abs(sum(l.*x{2})))

function M = setup_M(x1n, x2n) 
    n = length(x1n);
    M = zeros(n ,9);

    for i = 1:n
        xx = x2n(:,i) * x1n(:,i)';
        M(i,:) = xx(:)';      
    end

end







