function [radius, center] = computeCircumscribedCircle(vertices)

% a function that calculates for a triangle the radius and center of its circumscribed circle

% input: 
% vertices - 2x3 matrix contains vetrices coordinates of the triangle (f.e. [x1 x2 x3; y1 y2 y3])

% output:
% radius - radius of circumscribed circle
% center - 2x1 matrix contains coordinates of circumscribed circle (f.e. [x1; y1])

    % compute triangle's area
    area = polyarea(vertices(1, :), vertices(2, :));

    % compute the length of sides of the triangle
    s12 = norm((vertices(:, 1) - vertices(:, 2)).');
    s23 = norm((vertices(:, 2) - vertices(:, 3)).');
    s13 = norm((vertices(:, 1) - vertices(:, 3)).');

    % use formula: R = abc / (4 * area) to compute the circum radius
    radius = s12 * s23 * s13 / (4 * area);

    % compute the barycentric coordinates of the circum center
    bar = [s23^2 * (-s23^2+s13^2+s12^2), s13^2 * (s23^2-s13^2+s12^2), s12^2 * (s23^2+s13^2-s12^2)];

    % convert to the real coordinates
    center = bar(1) * vertices(:, 1) + bar(2) * vertices(:, 2) + bar(3) * vertices(:, 3);
    center = center / sum(bar);

end