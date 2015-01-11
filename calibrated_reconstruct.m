close all
clear all
clc

IL = imread('rgb03.jpg'); %load the left image
IR = imread('rgb04.jpg'); %load the right image

[ma na]=size(IL);

if (length(size(IL))>2)&&(length(size(IR))>2)
    [num matches r1 c1 r2 c2] = match(rgb2gray(IL),rgb2gray(IR));
else
    [num matches r1 c1 r2 c2] = match(IL,IR);
end


L = size(matches,1);
pts1 = [c1(matches(:,1)), r1(matches(:,1)), ones(L,1)];
pts2 = [c2(matches(:,2)), r2(matches(:,2)), ones(L,1)];

%%  calibration matrices

% Normalize points
K1=[-525 0 320;
    0 -525 240;
    0  0    1];
K2=K1;
n_pts1 = (K1^(-1)*pts1')';
n_pts2 = (K2^(-1)*pts2')';
%% RANSAC - find Essential matrix 
% RANSAC

N = 766;
count = zeros(1,N);
temp = zeros(N,8);
t = 5; % threshold do identify inliers
for iter=1:N
    % generate model
    selected = zeros(1,8);
   
    for i=1:8
        j = randi(L, 1);
        while numel(find(j==selected))
            j = randi(L, 1);
        end
        selected(i) = j;
    end
    temp(iter,:) = selected;
    sample_pts1 = n_pts1(selected',:);
    sample_pts2 = n_pts2(selected',:);
    sample_E = essential_matrix(sample_pts1, sample_pts2);
    
    % Verification
    no_inliers = 0;
    for k=1:L
        if numel(find(k==selected))== 0
            error = Sampson_error(sample_E,n_pts1(k,:),n_pts2(k,:));
            if error <= t
                no_inliers  = no_inliers + 1;
            end
                      
        end
    end
    count(1,iter) = no_inliers;
end

% find best fit model and recalculate the model using all inliers
[max_count, index] = max(count);
selected = temp(index,:);
sample_pts1 = n_pts1(selected',:);
sample_pts2 = n_pts2(selected',:);
sample_E = essential_matrix(sample_pts1, sample_pts2);
inliers = [];
    
for k=1:L
    error = Sampson_error(sample_E,n_pts1(k,:),n_pts2(k,:));
    if error <= t
        inliers = [inliers, k];
    end
end

% re-calculate F
E  = essential_matrix(n_pts1(inliers,:),n_pts2(inliers,:))
new_matches = matches(inliers,:);
%%
[P1, P2]=get_camera_matrices_from_E(E,n_pts1(randi(L, 1) ,:),n_pts2(randi(L, 1),:));

%% Reconstruct
XP = reconstruct2(n_pts1, n_pts2, P1, P2);

F = (K2')^(-1)*E*K1^(-1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rectify the images
%Used the RectKit for generating rectified images 
pts1=pts1(:,1:2);
pts2=pts2(:,1:2);
[ILr, IRr, TL, TR, bbL, bbR, err] = rectifyImageU(IL, IR, E, pts1', pts2');
figure,
subplot(1,2,1),imshow(ILr,[]),title('The rectified left image');
subplot(1,2,2),imshow(IRr,[]),title('The rectified right image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%computing daisy descriptors using available Daisy Package online
[dzyL] = compute_daisy(ILr);
[dzyR] = compute_daisy(IRr);
[DispIm] = getDisp2(dzyL, dzyR,ILr,IRr);
figure,imagesc(DispIm)
figure,imshow(DispIm,[]), colormap(jet),title('the whole disparity map for left image')
DispImM=DispIm;
tp=find(DispImM >max(max(DispIm))/10);
DispImM(tp)=zeros(length(tp),1);
figure,imshow(DispImM,[]), colormap(jet),title('the modified disparity map for left image')
figure,surf(DispImM),title('the surface of the disparity map for left image')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DispImMs=imresize(DispImM,6.4); % resizing the disparity map, due we got the rectificstion for bigger scale
[m,n]=size(DispImMs);
[newDispImM, newT] = imTrans(DispImM, inv(TL),[],max(size(IL,1),size(IL,2))+1);
[a,b]=size(newDispImM);
[c,d,e]=size(IL);
tpCut=(a-c)/2;
MyImage=newDispImM(ceil(tpCut):tpCut+c,:);
size(MyImage),
figure,
subplot(2,2,1),imshow(IL,[]),title('the left image and in original position')
subplot(2,2,2),imshow(ILr,[]),title('the rectified and scaled of left image ')
subplot(2,2,3),imshow(MyImage,[]), colormap(jet),title('the modified disparity map for left image ')
subplot(2,2,4),imshow(DispImM,[]), colormap(jet),title('the modified disparity map for left rectified image ')
% imwrite(MyImage,'newDispImMM.jpg');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generating color map and 3D model  
MyImage = im2double(MyImage);
MyImage=imresize(MyImage,[ma na]);
[pp,qq]=size(MyImage);
[kx,ky]=ind2sub([pp,qq],1:pp*qq);
thePtsPosition=[kx',ky'];
kz=reshape(MyImage,[length(kx),1]);
R=IL(:,:,1);
[a b]=size(R);
r=double(reshape(R,[length(kx),1]))./255;
G=IL(:,:,2);
g=double(reshape(G,[length(kx),1]))./255;
B=IL(:,:,3);
b=reshape(B,[length(kx),1]);
xyzrgb=[kx',ky',kz,r,g,b];
generateVRMLfromXYZRGB(xyzrgb, 'Myroom1.wrl')