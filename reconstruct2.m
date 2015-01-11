function X = reconstruct2(pts1, pts2, P1, P2)
% Reconstruct 3d points from corresponding point in 2 images and camera
% matrices
% X = [x, y, z, 1]'

L = size(pts1,1);
X = zeros(L,4);
A = zeros(4, 4);
for i=1:L
    % Establish the matrix A
    A(1,:) = pts1(i,1)*P1(3,:) - P1(1,:);
    A(2,:) = pts1(i,2)*P1(3,:) - P1(2,:);
    A(3,:) = pts2(i,1)*P2(3,:) - P2(1,:);
    A(4,:) = pts2(i,2)*P2(3,:) - P2(2,:);
    
    [U, S, V] = svd(A);
    X(i,:) = V(:,end);
    if X(i,4) ~= 0
        X(i,:) = X(i,:)/X(i,4);
    end
  
    
end

       
       
       
          