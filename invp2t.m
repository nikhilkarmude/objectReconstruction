function mt = invp2t(H,m,bb)
%invp2t Apply a projective transformation in 2D.
%
% mt = invp2t(H,m) given a Homography H plan
% projective and one clear image points m
% calculates the transformation of the image plane and its points at the
% same time

% Author: Andrea Fusiello

% m = m + repmat(bb(1:2),[1,size(m,2)]);
% H = inv(H);

if nargin < 3
    bb = [0;0;0;0];
end

[na,ma]=size(H);
if na~=3 | ma~=3
    error('Formato errato della matrice di trasformazione (3x3)!!');
end

[rml,cml]=size(m);
if (rml ~= 2)
    error('Le coordinate immagine devono essere cartesiane!!');
end


dime = size(m,2);
 
c3d = [m;  ones(1,dime)];
h2d = H * c3d;
c2d = h2d(1:2,:)./ [h2d(3,:)' h2d(3,:)']';

mt = c2d(1:2,:);


