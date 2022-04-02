% triangulation using built-in Matlab function

% reading an array of points
points = readtable('points.dat');
x = table2array(points(1:end,"X"));
y = table2array(points(1:end,"Y"));

% make triangulation
DT = delaunay(x, y);

% plot
triplot(DT, x, y);