function E = essential_matrix(pts1, pts2)
%%Compute the essential matrix from corresponding normalized points
% Input: pts1: List of points in first view (normalized)
%        pts2: List of points in second view (normalized)
% Output: E - essential matrix

% Using normalized 8-point algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%
% First set of points
L = size(pts1,1);
%centroid
centroid1= sum(pts1(:,1:2))./L;

%mean distance
S1 = 0;
for i=1:L
    S1= S1 + sqrt(sum((pts1(i,1:2)-centroid1).^2));
end
S1 = S1/L;

%transform matrix
T1 = [sqrt(2)/S1,  0,            -sqrt(2)/S1*centroid1(1);
      0         , sqrt(2)/S1,    -sqrt(2)/S1*centroid1(2);
      0         ,  0,            1                           ];
  
 normalized_pts1 = (T1*pts1')';

%%%%%%%%%%%%%%%%%%%%%%%%
 % Second set of points
%centroid
centroid2= sum(pts2(:,1:2))./L;

%mean distance
S2 = 0;
for i=1:L
    S2= S2 + sqrt(sum((pts2(i,1:2)-centroid2).^2));
end
S2 = S2/L;

%transform matrix
T2 = [sqrt(2)/S2,  0,            -sqrt(2)/S2*centroid2(1);
      0         , sqrt(2)/S2,    -sqrt(2)/S2*centroid2(2);
      0         ,  0,            1                           ];
  
 normalized_pts2 = (T2*pts2')';

 
 % Compose matrix A
 A = zeros(L, 9);
 for i = 1:L
     A(i,:) = [normalized_pts2(i,1)*normalized_pts1(i,1)   normalized_pts2(i,1)*normalized_pts1(i,2) normalized_pts2(i,1) normalized_pts2(i,2)*normalized_pts1(i,1) normalized_pts2(i,2)*normalized_pts1(i,2) normalized_pts2(i,2) normalized_pts1(i,1) normalized_pts1(i,2) 1];
 end
 
 % Linear solution - determine f from SVD
 [U S V] = svd(A);
 f_1 = V(:,end);
 E1 = reshape(f_1,3,3)';
 % Constraint enforcement
 [U1 S1 V1] = svd(E1);
 temp = (S1(1,1)+S1(2,2))/2;
 E2 = U1*diag([temp temp 0])*V1';
 E = T2'*E2*T1;
end
    


