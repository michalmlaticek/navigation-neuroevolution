function addPaths()
    % addPaths - add paths with required code
    %
    % Before you can run the experiment, you need to add the required code,
    % that mainly means, adding 'src' folder and it's subfolder as well as
    % 'genetic' toolbox folder. Depending on your implementation, you are
    % likely to add the folder containing callback functions as well.
    addpath('..\', ...
        '..\..\maps', ...
        '..\..\src', ...
        '..\..\src\utils', ...
        '..\..\src\simulator', ...
        '..\..\libs\genetic', ...
        'callbacks');
end


