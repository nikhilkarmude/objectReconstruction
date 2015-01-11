function Plane_Interpolation(X_n,K1,P1,I1)

n1 = X_n(1,1:3);
n2 = X_n(2,1:3);
n3 = X_n(3,1:3);
a1 = n2-n1;
a2 = n3-n1;
a = cross(a1,a2); % The plane




xmin = min(X_n(:,1));
xmax = max(X_n(:,1));
ymin = min(X_n(:,2));
ymax = max(X_n(:,2));
zmin = min(X_n(:,3));
zmax = max(X_n(:,3));

xo = n1(1);
yo = n1(2);
zo = n1(3);
% P1 = [eye(3),zeros(3,1)];
figure(3);
%plot3([0 0],[0 0],[0 0.5],'gd-');  % camera location 1
% inc = [0+1e-1 0+1e-1 1];
% arrow([0 0 0],inc,'g')
% hold on;grid on;
%plot3(P2(1,4),P2(2,4),P2(3,4),'md');  % camera location 2
% inc = inv(P2(:,1:3))*[0 0 1]';
% arrow([P2(1,4),P2(2,4),P2(3,4)],inc,'m');
% hold on;
% ind = [1:size(X_n,1) 1];
% plot3(X_n(ind,1),X_n(ind,2),X_n(ind,3),'-b')
% arrow of camera perspective

con = 0;
%out = [];
len = 0.2

for x = xmin:len:xmax
    for y = ymin:len:ymax
        % a(x-xo)+b(y-yo)+c(z-zo) = 0
        z = -a(1)/a(3)*(x-xo)-a(2)/a(3)*(y-yo)+zo;
        if z>zmax | z<zmin
            continue;
        end
        
        % judge inside the boundary 
        check = convex_checking(X_n,[x y z 1]);
        %check
        % check==0: outside the boundary; 
        % check==1: inside the region
        if check==0
            continue;
        end
        
        x1 = P1*[x y z 1]';
        x1 = K1*x1;
        x1 = x1/x1(3); % transform to Image1 plane
        %[x y z 1];
        val = double(I1(round(x1(2)),round(x1(1))));
        if length(val)==1 % is a gray image
            val = val*ones(1,3)/255;
        end
        hold on;
        
        %grid on;
        figure(3);
        plot3([x-len:len:x+len],[y-len:len:y+len],[z-len:len:z+len],'Color',val); hold on;
        %drawnow
        %out = [out; [x y z 1]];
        %pause;
        
    end
    
end
% [xmin xmax]
% [ymin ymax]
% [zmin zmax]
xlim([-5 5]);
ylim([-5 5]);
zlim([-5 20]);