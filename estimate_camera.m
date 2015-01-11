function [f, u0, v0] = estimate_camera(vp1, vp2, vp3)
A = [vp1(3) -(vp1(1)*vp2(3)+vp1(3)*vp2(1)) -(vp1(3)*vp2(2)+vp1(2)*vp2(3));
     vp1(3) -(vp1(1)*vp3(3)+vp1(3)*vp3(1)) -(vp1(3)*vp3(2)+vp1(2)*vp3(3));
     vp2(3) -(vp2(1)*vp3(3)+vp2(3)*vp3(1)) -(vp2(3)*vp3(2)+vp2(2)*vp3(3))];
B = [-vp1(1:2)'*vp2(1:2); -vp1(1:2)'*vp3(1:2);-vp2(1:2)'*vp3(1:2)];
temp = A\B;
u0 = temp(2);
v0 = temp(3);
f = sqrt(temp(1) - u0*u0 - v0*v0);


    