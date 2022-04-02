function [containingTriangle] = findTriangle(point, workArray, trianglesArray)

% function that check which of the triangles the new point is in

% input - index of the studied point, arrays of points and triangles
% output - index of the resulting triangle in triangles array

% function algorithm
% relativity method - the orientation of movement along the vertices of the
% triangle is selected (counterclockwise). According to this orientation, 
% we pass through all sides of the triangle, considering them as straight lines, 
% and calculate on which side of the current line our point lies. 
% If the point for all lines lies on the left side, then the point belongs to the triangle, 
% if at least for some line it lies on the right side, then the condition is not satisfied.

    triangleArrayLength = size(trianglesArray, 2);
    
    % iterate through all triangles
    for i = 1:triangleArrayLength

        % define vertices of current triangle
        vertex1 = workArray(: ,trianglesArray(1, i));
        vertex2 = workArray(: ,trianglesArray(2, i));
        vertex3 = workArray(: ,trianglesArray(3, i));

        % representing the sides of a triangle as vectors pointing counterclockwise
        vector21 = vertex1 - vertex2;
        vector32 = vertex2 - vertex3;
        vector13 = vertex3 - vertex1;

        % condition for a point to belong to a triangle

        % for each side, consider two pairs of vectors: 
        % 1) the vector of this side and the vector coming to the end of this side 
        % 2) the vector of this side and the vector whose beginning is the point under study, 
        % and the end is the vertex of the angle composed by the first pair of vectors

        % in order for a point to lie to the left of a given side, 
        % it is necessary that the orientation of the pairs of vectors described above be the same

        % we will calculate the orientation by calculating the determinant of the matrix, 
        % the rows of which are vectors from the corresponding pairs

        if sign(det([vector13.'; vector32.'])) * sign(det([(vertex3 - workArray(:, point)).'; vector32.'])) >= 0 && ... % side 2-3
           sign(det([vector21.'; vector13.'])) * sign(det([(vertex1 - workArray(:, point)).'; vector13.'])) >= 0 && ... % side 3-1
           sign(det([vector32.'; vector21.'])) * sign(det([(vertex2 - workArray(:, point)).'; vector21.'])) >= 0 % side 1-2
            containingTriangle = i; % save and return index
            return;
        end
    end
end