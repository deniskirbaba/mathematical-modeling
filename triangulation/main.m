% plot update speed (in seconds)
updateTime = 0.5;

% reading an array of points
points = readtable('points.dat');
length = size(points, 1);

% finding dots forming a rectangle covering the entire area
xMax = max(table2array(points(1:end,"X")));
xMin = min(table2array(points(1:end,"X")));
xMargin = abs((abs(xMax) - abs(xMin)) / 100);
xMax = xMax + xMargin;
xMin = xMin - xMargin;
yMax = max(table2array(points(1:end,"Y")));
yMin = min(table2array(points(1:end,"Y")));
yMargin = abs((abs(yMax) - abs(yMin)) / 100);
yMax = yMax + yMargin;
yMin = yMin - yMargin;

% creating "work" array to which we will gradually add points
% point coordinates are written in columns in this matrix
% first 4 points are the extreme points of the rectangle
workArray = [xMin xMin xMax xMax; yMin yMax yMax yMin];

% creating array that contain vertices of triangles
% each triangle is represented by a column of point indices in 'workArray' in this matrix
trianglesArray = [];

% Plot the forming dots
hold on;
axis([(xMin-3*xMargin) (xMax+3*xMargin) (yMin-3*yMargin) (yMax+3*yMargin)]);
scatter_plot = scatter(workArray(1,:), workArray(2,:), 30, 'b', 'filled');
pause(updateTime);

% main loop
% at each iteration we add a point and build the current triangulation
for i = 1:length

    % adding a point at work array and at the plot
    workArray(:, end + 1) = [table2array(points(i,"X")); table2array(points(i,"Y"))];
    scatter_plot.XData = workArray(1, :);
    scatter_plot.YData = workArray(2, :);
    pause(updateTime);
   
    % condition for the very first point
    if i == 1

        % plot the initial triangles
        plot([workArray(1, 1:4) workArray(1, 1)], [workArray(2, 1:4) workArray(2, 1)], 'b');
        for j = 1:4
            plot([workArray(1, j) workArray(1, 5)], [workArray(2, j) workArray(2, 5)], 'b');

            % adding triangles in an array
            nextj = j + 1;
            if j == 4 nextj = 1; end
            trianglesArray(:, end + 1) = [j 5 nextj];
        end
        pause(updateTime);
        continue
    end

    % find a triangle containing a point
    containingTriangle = findTriangle(i + 4, workArray, trianglesArray);

    % plot the new triangles
    for j = 1:3
        plot([workArray(1, i + 4) workArray(1, trianglesArray(j ,containingTriangle))], [workArray(2, i + 4) workArray(2, trianglesArray(j ,containingTriangle))], 'b');
    end
    pause(updateTime);

    % replace the old triangle with 3 new ones
   newTriangles = createNewTriangles(containingTriangle, i + 4, trianglesArray);

end
