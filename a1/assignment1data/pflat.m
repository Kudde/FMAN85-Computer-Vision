% x(end,:) 
%Extracts the last row of x

% repmat(a,[m n]) 
%Creates a block matrix with mn copies of a.

% a./b %Elementwise division.
%Divides the elements of a by the corresponding element of b.

% plot(a(1,:),a(2,:),?.?) 
%Plots a point at (a(1,i),a(2,i)) for each i. 

% plot3(a(1,:),a(2,:),a(3,:),?.?) 
%Same as above but 3D.

% axis equal 
%Makes sure that all axes have the same scale.

function x_flat = pflat(x)
% divides the homogeneous coordinates with their last 
% entry for points of any dimensionality

    last_entry = x(end,:);
    x_flat = x ./ last_entry;
end


