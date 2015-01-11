function draw_model(X_n)

n1 = X_n(1,1:3);
n2 = X_n(2,1:3);
n3 = X_n(3,1:3);
a1 = n2-n1;
a2 = n3-n1;
a = cross(a1,a2); % The plane
xo = n1(1);
yo = n1(2);
zo = n1(3);
X_n1 = X_n;
for i=1:size(X_n,1)
    X_n1(i,3) = -a(1)/a(3)*(X_n(i,1)-xo)-a(2)/a(3)*(X_n(i,2)-yo) + zo;
    %z = -a(1)/a(3)*(x-xo)-a(2)/a(3)*(y-yo)+zo;
    
end

figure(4);
patch(X_n1(:,1),X_n1(:,2),X_n1(:,3),1);
hold on;

