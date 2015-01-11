function K = calibration_matrix(I)

%% Find vanishing points
vp1 = getVanishingPoint(I, 'Finding first vanising point');
vp2 = getVanishingPoint(I, 'Finding second vanising point');
vp3 = getVanishingPoint(I, 'Finding third vanishing point');
% lines = [lines1, lines2];
% 
% % Horizon line
% horizon = real(cross(vp1, vp2))
% disp(sprintf('First vanishing point: (%8.3f,%8.3f,%8.3f)',vp1(1),vp1(2),vp1(3)));
% disp(sprintf('Second vanishing point: (%8.3f,%8.3f,%8.3f)',vp2(1),vp2(2),vp2(3)));
% disp(sprintf('Third vanishing point: (%8.3f,%8.3f,%8.3f)',vp3(1),vp3(2),vp3(3)));
% % Display
% figure;
% imagesc(A);
% hold on
% 
% bx1 = min([1, vp1(1)/vp1(3), vp2(1)/vp2(3)])-10; bx2 = max([size(A,2), vp1(1)/vp1(3),vp2(1)/vp2(3)])+10;
% by1 = min([1, vp1(2)/vp1(3),vp2(2)/vp2(3)])-10; by2 = max([size(A,1), vp2(2)/vp2(3),vp2(2)/vp2(3)])+10;
% for k = 1:size(lines, 2)
%     if lines(1,k)<lines(2,k)
%         pt1 = real(cross([1 0 -bx1]', lines(:, k)));
%         pt2 = real(cross([1 0 -bx2]', lines(:, k)));
%     else
%         pt1 = real(cross([0 1 -by1]', lines(:, k)));
%         pt2 = real(cross([0 1 -by2]', lines(:, k)));
%     end
%     pt1 = pt1/pt1(3);
%     pt2 = pt2/pt2(3);
%     plot([pt1(1) pt2(1)], [pt1(2) pt2(2)], 'g', 'Linewidth', 1);
% end
% plot(vp1(1)/vp1(3), vp1(2)/vp1(3), '*r')
% plot(vp2(1)/vp2(3), vp2(2)/vp2(3), '*r')
% plot([vp1(1)/vp1(3) vp2(1)/vp2(3)], [vp1(2)/vp1(3) vp2(2)/vp2(3)], 'k-.', 'Linewidth', 2);
% axis image
% text = sprintf('Two vanishing point and horizon line with equation %8.3f*u + %8.3f*v + %8.3f = 0',horizon(1),horizon(2),horizon(3));
% title(text);
% axis([bx1 bx2 by1 by2]); 

%% Estimate camera focal length & optical center
[f u0 v0] = estimate_camera(vp1, vp2, vp3);
K = [f 0 u0;
     0 f v0;
     0 0  1];
% disp(sprintf('Focal length = %8.3f',f));
% disp(sprintf('Camera center: (%8.3f,%8.3f)',u0,v0));
% plot(u0,v0,'*r');
% 
% 
% %% Problem 1c - Estimate camera tilt & roll
% 
% % Estimate camera till
% optical_center =[u0 v0 1]';
% % The distance from the optical center to the horizon
% d = - horizon'*optical_center./sqrt(horizon(1)^2 + horizon(2)^2);
% % let alpha be the tilt --> d = f*tan(alpha)
% tilt = 180*atan(d/f)/pi; % Tilt in degree
% disp(sprintf('The tilt of camera is: %4.2f degrees',tilt));
% 
% % Estimate the roll
% % the roll is estimate from the slope of the horizon
% roll = 180*atan(horizon(1)/horizon(2))/pi;
% disp(sprintf('The roll of camera is: %4.2f degrees',roll));
% 
% 
% % Calculate 35mm equivalent focal length
% % Let f0 is the 35mm equivalent focal length --> the field of view should
% % be the same
% % --> width of image/(2f) = 36 mm/(2f0) (the width of 35mm film is 36 mm)
% % --> f0 = 36*f/(width of image)
% 
% % The width of the image
% info = imfinfo('kyoto_street.JPG');
% w = info.Width;
% f0 = 36*f/w;
% disp(sprintf('The 35mm equivalent focal length is: %d mm',f0));
% 




