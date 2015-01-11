%3D reconstruction main routine
function reconstruction_3DImg(F,P1,P2,K1,K2,I1,I2)
close all
figure(1);
%figure;
%I1 = imread('chapel00.png');
imshow(I1); hold on;
%%%
% figure(2);
% %figure;
% %I2 = imread('chapel01.png');
% imshow(I2); hold on;
%%%
% figure(3);
% inc = [0 0 1];
% arrow([0 0 0],inc,'g')
% hold on;grid on;
% %%%%
% inc = inv(P2(:,1:3))*[0 0 1]';
% arrow([P2(1,4),P2(2,4),P2(3,4)],inc,'m');
% %%%%
set_num = 0;
while 1
    num = input('How many points to constitue a plane?(press q for exit) ','s');
    if strcmp(num,'q')==1
        break;
    else
        num = str2num(num);
    end
    
    set_num = set_num+1;
    % choose several points in Img1 to form a plane (pls. input in
    % clockwise order)
    [X_n disp_pts1 disp_pts2] = epipolar_matching(F,I1,I2,P1,P2,K1,K2,num);
    Set{set_num}.X = X_n;
    Set{set_num}.disp_pts1 = disp_pts1;
    Set{set_num}.disp_pts2 = disp_pts2;
    draw_model(X_n);
    grid on;
    view(-15,-52);
    % Interpolation
    Plane_Interpolation(X_n,K1,P1,I1);
    grid on;
    view(-15,-52)
%     figure(3)
%     patch(X_n(:,1),-X_n(:,2),X_n(:,3),1);
%     hold on
    

end

% save('Reconstruction_Points','Set');