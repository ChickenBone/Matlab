function strains = findstrain(refer_n, defor_n, elem)
    num_elem = size(elem, 1);
    strains = zeros(num_elem, 3);  % For exx, eyy, and exy

    % Calculate differences in position
    pos_diff = defor_n - refer_n;  % Deformed - Reference

    for i = 1:num_elem
        % Get nodal positions for the current element
        node_ids = elem(i, :);
        
        % Get displacements for the nodes of the current element
        displacements = pos_diff(node_ids, :);
        
        % Calculate the area using area compute function 
        area = areacomp(refer_n, node_ids);
        % Extract coordinates 
        coords = refer_n(node_ids, :);
        x1 = coords(1, 1); y1 = coords(1, 2);
        x2 = coords(2, 1); y2 = coords(2, 2);
        x3 = coords(3, 1); y3 = coords(3, 2);

        % Construct the B-matrix
        matrix = (1 / (2 * area)) * [
            y2 - y3, 0, y3 - y1, 0, y1 - y2, 0;
            0, x3 - x2, 0, x1 - x3, 0, x2 - x1;
            x2 - x3, y2 - y3, x1 - x3, y3 - y1, x2 - x1, y1 - y2
        ];

        % Reshape displacements to match B matrix
        disp_vec = reshape(displacements', [], 1);  % Convert to a column vector
        
        % Calculate strains
        strain_vec = matrix * disp_vec;

        strains(i, :) = strain_vec(1:3)';  % Store exx, eyy, exy
    end
end
