%% clearing 
clc;
clearvars;
%% main script/ function calls 
% File names for reference and deformed meshes
files = {
    'Basic2D_Reference.ucd', 'Basic2D_Deformed.ucd';
    'Adv2D_Reference.ucd', 'Adv2D_Deformed.ucd'
    % 'Basic3D_Reference.ucd', 'Basic3D_Deformed.ucd';
    % 'Adv3D_Reference.ucd', 'Adv3D_Deformed.ucd'
};

% Loop through each file pair
for i = 1:size(files, 1)
    % Determine if the file is 3D based on the filename
    is3D = contains(files{i, 1}, '3D');
    
    % open/read in the reference and deformed mesh data
    [reference, refer_element] = opfile(files{i, 1}, is3D);
    [deformed, ~] = opfile(files{i, 2}, is3D);
    
    % Project 3D elements to local 2D coordinates if 3D mesh
    if is3D
        % Create arrays to store projected coordinates
        reference_2d = zeros(size(refer_element, 1) * size(refer_element, 2), 2);
        deformed_2d = zeros(size(refer_element, 1) * size(refer_element, 2), 2);
        
        % Process each element
        for j = 1:size(refer_element, 1)
            % Get node IDs for current element
            node_ids = refer_element(j, :);
            
            % Project reference coordinates to 2D
            local_coords_ref = project_to_local_2d(reference, node_ids);
            reference_2d(node_ids, :) = local_coords_ref;
            
            % Project deformed coordinates to 2D using same coordinate system
            local_coords_def = project_to_local_2d(deformed, node_ids);
            deformed_2d(node_ids, :) = local_coords_def;
        end
        
        % Update reference and deformed to use 2D coordinates
        reference = reference_2d;
        deformed = deformed_2d;
    end
    
    % Compute strain using the strain compute function
    strains = findstrain(reference, deformed, refer_element);
    
    % Debug: Print strain results
    fprintf('Strain results for %s:\n', files{i, 1});
    disp('Strains (strain_xx, strain_yy, and shear_strain_xy):');
    disp(strains);
end