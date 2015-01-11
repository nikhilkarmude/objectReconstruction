function check = convex_checking(X_n,P)
% Checking whether point P is inside the region bounded by X_n
% Input: world homogeneous coordinates
%   X_n: K x 4 ( the order of the points should be clockwise)
%   P: 1 x 4
% Output:
%   check: check==1 inside; check==0 outside

N = size(X_n,1);
% vector from each vertec to P
vec_P = repmat(P,N,1)-X_n;
vec_P = vec_P(:,1:3);
% vector from one vertex to the next in the clockwise order
X_add = [X_n;X_n(1,:)];
vec_vertex = X_add(2:end,:)-X_add(1:end-1,:);
vec_vertex = vec_vertex(:,1:3);

% % find the normal vector of this plane made by X_n
% n1 = X_n(1,1:3);
% n2 = X_n(2,1:3);
% n3 = X_n(3,1:3);
% a1 = n1-n2;
% a2 = n3-n2;
% alpha_plane = cross(a1,a2);
% z = -a(1)/a(3)*(x-xo)-a(2)/a(3)*(y-yo)+zo;

check = 1;
for ii = 1:N

    v1 = vec_P(ii,:);
    v2 = vec_vertex(ii,:);
    
    alpha = cross(v1,v2);
    if ii == 1
        test = alpha(3);
    else
        test2 = alpha(3);
        if test*test2<0
           check = 0;
           break;
         end
    end
    
end