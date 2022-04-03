function [adjacentSides] = findAdjacentSides(triangles)

% function for finding adjacent sides of the N given triangles
% the search is carried out by passing through all the triangles in a loop and looking at the sides of other triangles

% input: 
% triangles - 3xN matrix contains indexes of the triangle's vertices (f.e. [v11 v21 v31 ... vN1; v12 v22 v32 ... vN2; v13 v23 v33 ... vN3])

% output:
% adjacentSides - 2xM matrix contains indexes of the adjacent sides (f.e. [v11 v21 v31 ... vM1; v12 v22 v32 ... vM2])
    
    adjacentSides = [];

    trianglesLength = size(triangles, 2);

    for i = 1:(trianglesLength - 1)
        curTriangle = triangles(:, i);
        for j = (i + 1):trianglesLength
            counter = 0;
            sides = [];
            if (ismember(curTriangle(1), triangles(:, j)))
                counter = counter + 1;
                sides(end + 1) = curTriangle(1);
            end
            if (ismember(curTriangle(2), triangles(:, j)))
                counter = counter + 1;
                sides(end + 1) = curTriangle(2);
            end
            if (ismember(curTriangle(3), triangles(:, j)))
                counter = counter + 1;
                sides(end + 1) = curTriangle(3);
            end
            if (counter > 1)
                adjacentSides(:, end + 1) = [sides(1); sides(2)];
            end
        end
    end
end