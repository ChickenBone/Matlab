%% clearing 
clc;
clearvars;

%% main script/ function calls 

% File names for reference and deformed meshes
files = {
    '/Users/chickenbone/GitHub/Matlab/data/Basic2D_Reference.ucd', '/Users/chickenbone/GitHub/Matlab/data/Basic2D_Deformed.ucd';
    '/Users/chickenbone/GitHub/Matlab/data/Adv2D_Reference.ucd', '/Users/chickenbone/GitHub/Matlab/data/Adv2D_Deformed.ucd'
};

% Loop through each file pair
for i = 1:size(files, 1)
    % open/read in the reference and deformed mesh data
    [reference, refer_element] = opfile(files{i, 1});
    [deformed, ~] = opfile(files{i, 2});
    
    % Compute strain using the strain compute function
    strains = findstrain(reference, deformed, refer_element);
    
    % Display strain results 
    fprintf('Strain results for %s:\n', files{i, 1});
    disp('Strains (exx, eyy, exy):');
    disp(strains);
end
