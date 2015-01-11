function [DispIm] = getDisp2(dzy1, dzy2,im1,im2) 
% Computing disparity image from daisy results

 dispTh=-100
 matched=0;

[kk,pp,tt]=size(im1);
DispIm=zeros(kk,pp);


h = waitbar(0,'Please wait...');

for ii=1:kk-1
    des1=dzy1.descs((ii-1)*pp+1:ii*pp ,:);
    des2=dzy2.descs((ii-1)*pp+1:ii*pp ,:);

    % For each descriptor in the first image, select its match to second image.
    des2t = des2';        % Precompute matrix transpose
    
    for jj = 1 : size(des1,1)
        
       sqrtDistV = distSqr(des1(jj,:)',des2t);  % (DxM & DxN e.g.200x1 & 200x561 => Mx N )
      
       [vals,indx] = min(sqrtDistV);

       if (vals(1) >dispTh) 
          matched(jj) = indx(1);
          DispIm(ii,jj)=abs(indx(1)-jj);
       else
          matched(jj) = 0;
       end
    end
    
    waitbar(ii / (kk-1))

end,

close(h)

num = sum(matched > 0);

fprintf('Found %d matches.\n', num);