function [P1, P2] =  get_camera_matrices_from_E(E, pt1,pt2)
%E: Essential matrix
%pt1, pt2: a pair of points to choose the correct camera matrices
% Estimate camera matrices from essential matrix
I = eye(3);
P1 = [I, [0;0;0]];
[U S V] =svd(E);
W = [0 -1 0; 
     1  0 0;
     0  0 1];

P21 = [U*W*V' U(:,end)];
P22 = [U*W*V' -U(:,end)];
P23 = [U*W'*V' U(:,end)];
P24 = [U*W'*V' -U(:,end)];

X1 = reconstruct2(pt1,pt2,P1, P21);
X2 = reconstruct2(pt1,pt2,P1, P22);
X3 = reconstruct2(pt1,pt2,P1, P23);
X4 = reconstruct2(pt1,pt2,P1, P24);

v1 = [0 0 1]';
O21 = P21(:,end);
v21 = P21(:,1:3)*v1;

O22 = P22(:,end);
v22 = P22(:,1:3)*v1;

O23 = P23(:,end);
v23 = P23(:,1:3)*v1;

O24 = P24(:,end);
v24 = P24(:,1:3)*v1;

% test
% 1st case
t21 = X1(1:3)' - O21;
test11 = X1(3);
test21 = v21'*t21;

% 2nd case
t22 = X2(1:3)' - O22;
test12 = X2(3);
test22 = v22'*t22;

% 3rd case
t23 = X3(1:3)' - O23;
test13 = X3(3);
test23 = v23'*t23;

% 4th case
t24 = X4(1:3)' - O24;
test14 = X4(3);
test24 = v24'*t24;

if (test11>0)&&(test21>0)
    P2 = P21;
elseif (test12>0)&&(test22>0)
    P2 = P22;
elseif (test13>0)&&(test23>0)
    P2 = P23;
elseif (test14>0)&&(test24>0)
    P2 = P24;
end;
