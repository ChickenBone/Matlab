function [nodes, elems] = opfile(file)
    % Check if the file exists
    if ~isfile(file)
        error('File does not exist: %s', file);
    end

    % Open the file
    fid = fopen(file, 'r');

    if fid == -1
        error('Error opening file: %s', file);
    end

    % Read the header
    header = fgetl(fid);
    header_data = sscanf(header, '%d %d %*d %*d %*d'); % extract the number of nodes and elements using sscanf (first 2)
    % %d ignores remaining values in header 
    num_nodes = header_data(1); % # of nodes 
    num_elems = header_data(2); % # of elements 
    
    % Read nodes
    nodes = zeros(num_nodes, 2);
    for i = 1:num_nodes
        datalines = fgetl(fid); % reads each node line by line 
        node_data = sscanf(datalines, '%d %f %f %*f'); % extracts x and y and ignores z 
        nodes(i, :) = node_data(2:3);  % Store x and y coordinates
    end
    
    % Read elements
    elems = zeros(num_elems, 3);
    for i = 1:num_elems
        datalines = fgetl(fid); % reads each line for elements 
        elem_data = sscanf(datalines, '%d %*d %*s %d %d %d'); % extracts node ids
        elems(i, :) = elem_data(2:4)';  % store node IDs
    end
    
    fclose(fid); % close file after reading 
end