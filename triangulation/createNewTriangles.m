% function that creates 3 new triangles from one old one and a point inside it

% input - index of the old triangle, index of insiding point and arrays of triangles
% output - column-vector, that contains indexes of new triangles

function [newTriangles] = createNewTriangles(oldTriangle, point, trianglesArray)

    % define vertices of the old triangle
    vertex1 = trianglesArray(1, oldTriangle);
    vertex2 = trianglesArray(2, oldTriangle);
    vertex3 = trianglesArray(3, oldTriangle);

    % recording the first new triangle in place of the old one
    trianglesArray(:, oldTriangle) = [point; vertex1; vertex2];

    % adding the remaining two triangles to the end of the matrix
    trianglesArray(:, end + 1) = [point; vertex2; vertex3];
    trianglesArray(:, end + 1) = [point; vertex1; vertex3];

    % saving indexes in the result column-vector 'newTriangles'
    newTriangles = [oldTriangle; size(trianglesArray, 2) - 1; size(trianglesArray, 2)];

    % code to change the matrix 'trianglesArray' passed to this function
    inname = inputname(3);
    if ~isempty(inname)
      assignin('caller', inname, trianglesArray);
    end

end