function area = areacomp(refer_n, node_ids)
    % Extract coordinates of the triangle's vertices 
    cords = refer_n(node_ids, :);
    x1 = cords(1, 1); y1 = cords(1, 2);
    x2 = cords(2, 1); y2 = cords(2, 2);
    x3 = cords(3, 1); y3 = cords(3, 2);
    
    % Calculate area of a triangle using the determinant method
    area = 0.5 * abs(x1*(y2 - y3) + x2*(y3 - y1) + x3*(y1 - y2));
end
