%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Written and (C) by                                                      %
% Engin Tola                                                              %
%                                                                         %
% web   : http://cvlab.epfl.ch/~tola/                                     %
% email : engin.tola@epfl.ch                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out=display_descriptor(dzy, y, x)
% You can  extract the descriptor  of a point (y,x) with
% out = display_descriptor(dzy,y,x);
% In the matrix 'out', each row is a normalized histogram ( by default ).
% R  : radius of the descriptor
% RQ : number of rings
% TQ : number of histograms on each ring
% HQ : number of bins of the histograms
% 
% SI : spatial interpolation enable/disable
% LI : layered interpolation enable/disable
% NT : normalization type:
%      0 = No normalization
%      1 = Partial Normalization
%      2 = Full Normalization
%      3 = Sift like normalization


if y<0 || x<0 || y>dzy.h-1 || x>dzy.w-1
    error('index out of bounds');
end
    
out = reshape( dzy.descs( y*dzy.w+x+1, :), dzy.HQ, dzy.HN )';
