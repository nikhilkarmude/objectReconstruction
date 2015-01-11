function e = Sampson_error(F,pt1,pt2)
epsilon = pt2*F*pt1';
J = [F(1,1)*pt2(1) + F(2,1)*pt2(2) + F(3,1),...
     F(1,2)*pt2(1) + F(2,2)*pt2(2) + F(3,2),...
     F(1,1)*pt1(1) + F(1,2)*pt1(2) + F(1,3),...
     F(2,1)*pt1(1) + F(2,2)*pt1(2) + F(2,3)];

e = epsilon^2/(J*J');
