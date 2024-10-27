function local_coords = project_to_local_2d(reference, element_nodes)
    % Extract the 3D coordinates of the nodes
    coords_3d = reference(element_nodes, :);
    
    
    % Calculate the normal vector of the plane formed by the first three points
    % v1 and v2 are vectors along the edges of the triangle formed by the first three nodes
    v1 = coords_3d(2, :) - coords_3d(1, :);
    v2 = coords_3d(3, :) - coords_3d(1, :);
    % The normal vector is perpendicular to the plane of the triangle
    normal = cross(v1, v2);
    % Normalize the normal vector to make it a unit vector
    normal = normal / norm(normal);
    
    % Define a new coordinate system with the origin at the first node
    origin = coords_3d(1, :);
    % x_axis is a unit vector along the first edge of the triangle
    x_axis = v1 / norm(v1);
    % y_axis is a unit vector orthogonal to both x_axis and the normal vector
    y_axis = cross(normal, x_axis);
    
    % Project the 3D coordinates onto the 2D plane
    local_coords = zeros(size(coords_3d, 1), 2);
    for i = 1:size(coords_3d, 1)
        % vec is the vector from the origin to the current node
        vec = coords_3d(i, :) - origin;
        % The x-coordinate in the local 2D plane is the projection of vec onto x_axis
        local_coords(i, 1) = dot(vec, x_axis);
        % The y-coordinate in the local 2D plane is the projection of vec onto y_axis
        local_coords(i, 2) = dot(vec, y_axis);
    end
end