function [X_n pts1 pts2] = epipolar_matching(F,I1,I2,P1,P2,K1,K2,CON)

pts1 = [];
pts2 = [];
l = [];
figure(2);
imshow(I2);
hold on;
if length(size(I1)) > 2
    I1 = rgb2gray(I1);
end
if length(size(I2))>2
    I2 = rgb2gray(I2);
end
[M1 N1] = size(I1);
[M2 N2] = size(I2);

Size = 5;

for i = 1:CON
        disp(sprintf('Select points %d',i));    
        figure(1);
        pts1 = [pts1; ginput(1), 1];
        plot(pts1(i,1),pts1(i,2),'r.');  

        l = F*pts1(i,:)';
        l = l';
        
       figure(2);  
       
       hold on
        if (l(2) == 0)
            y = 1:M2;

            x = [-l(3)/l(1), -l(3)/l(1)];
            plot(x,y,'b','LineWidth',2);
            hold on
        else
            x = 1:N2;
            y = -l(1)/l(2)*x - l(3)/l(2);
            plot(x,y,'b','LineWidth',2);
            hold on
        end   
     
        x = round(x);
        y = round(y);
        %  find_matching: SSD
        a = round(pts1(i,1));
        b = round(pts1(i,2));
%         ref = zeros(2*Size+1, 2*Size+1);
%         region = zeros(2*Size+1, 2*Size+1);
        %disp('used_size');
        used_size = min([Size,a,b,M1-b,N1-b]);
        
        
        
        ref = I1(b-used_size:b+used_size,a-used_size:a+used_size);
        comp = zeros(1,N2);
        for ii = 1:length(y) 
            if (y(ii)<-used_size+1)||(y(ii)>M2+used_size)||(x(ii)<-used_size+1)||(x(ii)>N2 + used_size)
                continue;
            end
            
            
            if (y(ii)<1+used_size)
                ref1 = ref(used_size -y(ii) + 2:end,:);
            else if (y(ii)>M2-used_size)
                ref1 = ref(1:M2+used_size+1-y(ii),:);
                else
                    ref1 = ref;
                end               
            end
            if (x(ii)<1+used_size)
                ref2 = ref1(:,used_size-x(ii)+2:end);
            else if (x(ii) > N2 - used_size)
                    ref2 = ref1(:,1:N2 + used_size + 1 - x(ii));
                else
                    ref2 = ref1;
                end
            end
            
%             size(I2)
%             ii
%             max(y(ii)-used_size,1)
%             min(y(ii)+used_size,M2)
%             max(x(ii)-used_size,1)
%             min(x(ii)+used_size,N2)
%             N2 
            
%             disp('before')
            region = I2(max(y(ii)-used_size,1):min(y(ii)+used_size,M2),max(x(ii)-used_size,1):min(x(ii)+used_size,N2));
%             disp('after')
%             disp('x(ii)')
%             x(ii)
%             disp('N2');
%             N2
%             disp('y(ii)')
%             y(ii)
%             disp('M2')
%             M2
%             disp('size ref')
%             size(ref)
%             disp('size ref1');
%             size(ref1)
%             disp('size ref2');
%             size(ref2)
%             disp('size region');
%             size(region)
            comp(ii) = norm(double(ref2(:))-double(region(:)));
        end
        
        [trash ind] = min(comp(:));
%        ind = ind+20;

        %pause;
        plot(x(ind),y(ind),'g.');
        pts2 = [pts2; x(ind),y(ind),1];
        
        % pause
end


% Normalize points' coordinates (HUY)
% normalized_pts1 = (K1\pts1')';
% normalized_pts2 = (K2\pts2')';
% X_n = reconstruct2(normalized_pts1, normalized_pts2,P1, P2);
X_n = reconstruct2(pts1, pts2, K1*P1, K2*P2);

% figure();
% plot3(0,0,0,'gd');  % camera location 1
% hold on;grid on;
% plot3(P2(1,4),P2(2,4),P2(3,4),'md');  % camera location 2
% hold on;
% for i=1:CON
%     plot3(X_n(i,1),X_n(i,2),X_n(i,3),'r.');
%     hold on;
% end
% 
% ind = [1:4 1];
% plot3(X_n(ind,1),X_n(ind,2),X_n(ind,3),'-b')
% % ind = [4:8 4];
% % plot3(X_n(ind,1),X_n(ind,2),X_n(ind,3),'-b')
% % ind = [9:12 9];
% % plot3(X_n(ind,1),X_n(ind,2),X_n(ind,3),'-b')
% % xlabel('X');
% % ylabel('Y');
% % zlabel('Z(altitudes)');


% ind = [4 11 12 13 14 15 16];
% plot3(X_n(ind,1),-X_n(ind,2),X_n(ind,3),'-b')
% ind = [3 4 5 7 6 3];
% plot3(X_n(ind,1),-X_n(ind,2),X_n(ind,3),'-b')
% ind = [21:24 21];
% plot3(X_n(ind,1),-X_n(ind,2),X_n(ind,3),'-b')
% ind = [17:20 17];
% plot3(X_n(ind,1),-X_n(ind,2),X_n(ind,3),'-b')