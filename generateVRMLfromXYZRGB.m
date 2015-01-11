%author: shaimik khatib
% this code is taken from above author
function generateVRMLfromXYZRGB(xyzrgb, outputFileName)
fOut = fopen(outputFileName,'w');
fprintf(fOut,'#VRML v2.0 utf8\nShape { geometry PointSet { color Color {color [\n');
for i=1:size(xyzrgb,1)
   fprintf(fOut,'%f %f %f\n',xyzrgb(i,4),xyzrgb(i,5),xyzrgb(i,6));
end
fprintf(fOut,'] } coord Coordinate { point [\n');
for i=1:size(xyzrgb,1)
   fprintf(fOut,'%f %f %f\n',xyzrgb(i,1),xyzrgb(i,2),xyzrgb(i,3));
end
fprintf(fOut,'] } } }\n');
fclose(fOut);