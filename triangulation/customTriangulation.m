% plot update speed (in seconds)
updateTime = 0;

% reading an array of points
points = readtable('points.dat');
length = size(points, 1);

% finding dots forming a "super-rectangle" covering the entire area
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
% first 4 points are the extreme points of the "super-rectangle"
workArray = [xMin xMin xMax xMax; yMin yMax yMax yMin];

% array that contain vertices of triangles
% each triangle is represented by a column with following structure:
% 1 row - 1 triangle vertex
% 2 row - 2 top of the triangle
% 3 row - 3 top of the triangle
% 4 row - the radius of the circumscribed circle
% 5 row - X coordinate of the center of the circumscribed circle
% 6 row - Y coordinate of the center of the circumscribed circle
trianglesArray = [];

% an array containing triangle line objects on the chart
% associated with an array (the column indices for "linesArray" and "trianglesArray" represent one triangle)
% necessary for the visualization of the triangulation algorithm
% 1 row - line connecting vertices 1 and 2
% 2 row - line connecting vertices 2 and 3
% 3 row - line connecting vertices 3 and 1
linesArray = [];

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

        for j = 1:4

            % crutch to add the 4th triangle
            nextj = j + 1;
            if j == 4 
                nextj = 1; 
            end

            % compute radius and center of circumscribed circle
            [radius, center] = computeCircumscribedCircle([workArray(1, j) workArray(1, 5) workArray(1, nextj); workArray(2, j) workArray(2, 5) workArray(2, nextj)]);
            
            % adding triangle into array
            trianglesArray(:, end + 1) = [j 5 nextj radius center(1) center(2)];

            % adding line
            if (j == 1) 
                botLeftLine = plot([workArray(1, 1) workArray(1, 5)], [workArray(2, 1) workArray(2, 5)], 'b');
                topLeftLine = plot([workArray(1, 2) workArray(1, 5)], [workArray(2, 2) workArray(2, 5)], 'b');
                leftLine = plot([workArray(1, 1) workArray(1, 2)], [workArray(2, 1) workArray(2, 2)], 'b');
                linesArray(:, end + 1) = [botLeftLine topLeftLine leftLine]; 
            end
            if (j == 2) 
                topLeftLine = plot([workArray(1, 2) workArray(1, 5)], [workArray(2, 2) workArray(2, 5)], 'b');
                topRightLine = plot([workArray(1, 3) workArray(1, 5)], [workArray(2, 3) workArray(2, 5)], 'b');
                topLine = plot([workArray(1, 3) workArray(1, 2)], [workArray(2, 3) workArray(2, 2)], 'b');
                linesArray(:, end + 1) = [topLeftLine topRightLine topLine]; 
            end
            if (j == 3) 
                topRightLine = plot([workArray(1, 3) workArray(1, 5)], [workArray(2, 3) workArray(2, 5)], 'b');
                botRightLine = plot([workArray(1, 4) workArray(1, 5)], [workArray(2, 4) workArray(2, 5)], 'b');
                rightLine = plot([workArray(1, 3) workArray(1, 4)], [workArray(2, 3) workArray(2, 4)], 'b');
                linesArray(:, end + 1) = [topRightLine botRightLine rightLine]; 
            end
            if (j == 4) 
                botRightLine = plot([workArray(1, 4) workArray(1, 5)], [workArray(2, 4) workArray(2, 5)], 'b');
                botLine = plot([workArray(1, 1) workArray(1, 4)], [workArray(2, 1) workArray(2, 4)], 'b');
                botLeftLine = plot([workArray(1, 1) workArray(1, 5)], [workArray(2, 1) workArray(2, 5)], 'b');
                linesArray(:, end + 1) = [botRightLine botLeftLine botLine]; 
            end
        end
        pause(updateTime);
        continue
    end
    
    % find all triangles whose circumscribed circles contain a new point
    % and add their vertices in "badTriangles" array
    % also remember these triangles indexes in "deletedTrianglesIndexes"
    badTriangles = [];
    badTrianglesIndexes = [];
    for j = 1:size(trianglesArray, 2)
        % go through all the triangles and check if point lie in the circumscribed circle
        % i.e., we compare the distance from the center of the circle to a point with the radius of the circle
        distFromCenterToPoint = norm((workArray(:, end) - trianglesArray(5:6, j)).');
        if (trianglesArray(4, j) >= distFromCenterToPoint)
            badTriangles(:, end + 1) = trianglesArray(1:3, j);
            badTrianglesIndexes(end + 1) = j;
        end
    end

    % all detected "bad" triangles must be removed from triangulation
    % (!) an edge is removed only if all adjacent triangles are removed; 
    % (!) while the edges of the "super-rectangle" are never deleted
    % in this case, a polyhedron containing a given point will be obtained in the grid
    % new triangles are formed by inserting edges between a given point and the vertices of this polyhedron
    % it is proved that this yields the Delaunay triangulation

    % find adjacent sides
    adjacentSides = findAdjacentSides(badTriangles);

    % delete triangle-columns in arrays
    for j = 1:size(badTrianglesIndexes, 2)
        delete(linesArray(1, badTrianglesIndexes(j)));
        delete(linesArray(2, badTrianglesIndexes(j)));
        delete(linesArray(3, badTrianglesIndexes(j)));
    end
    trianglesArray(:, badTrianglesIndexes(:)) = [];
    linesArray(:, badTrianglesIndexes(:)) = [];

    % form triangles from the given point and the vertices of this polygon

    % the formation of triangles from a polygon will be done as follows:
    % going through all the "bad" triangles,
    % compose all possible combinations from the current point and the vertices of the current triangle
    % (replacing sequentially the points forming the removed adjacent faces)
    % so that in the resulting combinations (which are triangles) there are no adjacent sides to be removed
    for j = 1:size(badTriangles, 2)

        if (size(adjacentSides, 2) == 0 || ismember(badTriangles(1, j), adjacentSides) && ~ifAdjacentSides(adjacentSides, badTriangles(2, j), badTriangles(3, j)))
            % creating triangle
            [radius, center] = computeCircumscribedCircle([workArray(1, end) workArray(1, badTriangles(2, j)) workArray(1, badTriangles(3, j)); workArray(2, end) workArray(2, badTriangles(2, j)) workArray(2, badTriangles(3, j))]);
            trianglesArray(:, end + 1) = [(i + 4) badTriangles(2, j) badTriangles(3, j) radius center(1) center(2)];

            % plot triangle
            line1 = plot([workArray(1, end) workArray(1, badTriangles(2, j))], [workArray(2, end) workArray(2, badTriangles(2, j))], 'b');
            line2 = plot([workArray(1, badTriangles(2, j)) workArray(1, badTriangles(3, j))], [workArray(2, badTriangles(2, j)) workArray(2, badTriangles(3, j))], 'b');
            line3 = plot([workArray(1, end) workArray(1, badTriangles(3, j))], [workArray(2, end) workArray(2, badTriangles(3, j))], 'b');
            
            % adding to the line array
            linesArray(:, end + 1) = [line1 line2 line3];
        end
        if (size(adjacentSides, 2) == 0 || ismember(badTriangles(2, j), adjacentSides) && ~ifAdjacentSides(adjacentSides, badTriangles(1, j), badTriangles(3, j)))
            % creating triangle
            [radius, center] = computeCircumscribedCircle([workArray(1, end) workArray(1, badTriangles(1, j)) workArray(1, badTriangles(3, j)); workArray(2, end) workArray(2, badTriangles(1, j)) workArray(2, badTriangles(3, j))]);
            trianglesArray(:, end + 1) = [(i + 4) badTriangles(1, j) badTriangles(3, j) radius center(1) center(2)];

            % plot triangle
            line1 = plot([workArray(1, end) workArray(1, badTriangles(1, j))], [workArray(2, end) workArray(2, badTriangles(1, j))], 'b');
            line2 = plot([workArray(1, badTriangles(1, j)) workArray(1, badTriangles(3, j))], [workArray(2, badTriangles(1, j)) workArray(2, badTriangles(3, j))], 'b');
            line3 = plot([workArray(1, end) workArray(1, badTriangles(3, j))], [workArray(2, end) workArray(2, badTriangles(3, j))], 'b');
            
            % adding to the line array
            linesArray(:, end + 1) = [line1 line2 line3];

        end
        if (size(adjacentSides, 2) == 0 || ismember(badTriangles(3, j), adjacentSides) && ~ifAdjacentSides(adjacentSides, badTriangles(2, j), badTriangles(1, j)))
            % creating triangle
            [radius, center] = computeCircumscribedCircle([workArray(1, end) workArray(1, badTriangles(2, j)) workArray(1, badTriangles(1, j)); workArray(2, end) workArray(2, badTriangles(2, j)) workArray(2, badTriangles(1, j))]);
            trianglesArray(:, end + 1) = [(i + 4) badTriangles(1, j) badTriangles(2, j) radius center(1) center(2)];

            % plot triangle
            line1 = plot([workArray(1, end) workArray(1, badTriangles(1, j))], [workArray(2, end) workArray(2, badTriangles(1, j))], 'b');
            line2 = plot([workArray(1, badTriangles(2, j)) workArray(1, badTriangles(1, j))], [workArray(2, badTriangles(2, j)) workArray(2, badTriangles(1, j))], 'b');
            line3 = plot([workArray(1, end) workArray(1, badTriangles(2, j))], [workArray(2, end) workArray(2, badTriangles(2, j))], 'b');
            
            % adding to the line array
            linesArray(:, end + 1) = [line1 line2 line3];
        end
    end
    pause(updateTime);
end

% removal from the mesh of all triangles whose vertices include auxiliary
% nodes used to build the "super-rectangle"
% the result is a mesh built only on the given nodes from "points.dat"
removingTrianglesIndexes = [];
for i = 1:size(trianglesArray, 2)
    condition = ismember(1, trianglesArray(1:3, i)) || ...
                ismember(2, trianglesArray(1:3, i)) || ...
                ismember(3, trianglesArray(1:3, i)) || ...
                ismember(4, trianglesArray(1:3, i));
    if (condition)
        delete(linesArray(1, i));
        delete(linesArray(2, i));
        delete(linesArray(3, i));
        removingTrianglesIndexes(end + 1) = i;
    end
end
trianglesArray(:, removingTrianglesIndexes(:)) = [];
linesArray(:, removingTrianglesIndexes(:)) = [];

% remove super-rectangle vertices
scatter_plot.XData = workArray(1, 5:end);
scatter_plot.YData = workArray(2, 5:end);