function simulateThis(gen_id, unique_best_idx, init_position, target_position, step_count)
    this_folder = getThisFolder();
    addpath(sprintf('%s\callbacks', this_folder));

    settings = load(sprintf('%s\settings', this_folder));

    global logger; logger = Logger(path, 'simulation-run.log');
    global draw; draw = true;

    %load population
    data = load(sprintf(sprintf('%s\out-data-gen-%d.mat', this_folder, gen_id)));
    pop = data.pop;
    fits = data.fits;
    
    % create a unique population
    pop = [fits; pop];
    pop = unique(pop, 'columns');
    pop = pop(2:end, :);
    
    if exist('unique_best_idx', 'var') && ~isempty(unique_best_idx)
        rel_fits_valid_idx = unique_best_idx <= size(pop, 1);
        pop = pop(unique_best_idx(rel_fits_valid_idx), :);
    end
    
    if exist('init_position', 'var') && ~isempty(init_position)
       settings.initPosition = reshape(init_position, [1, 1, 2]); 
    end
    
    if exist('target_position', 'var') && ~isempty(target_position)
        settings.targetPosition = reshape(target_position, [1, 1, 2]); 
    end
    
    if exist('step_count', 'var') && ~isempty(step_count)
       settings.step_count = step_count;
    end
    
    figure;

    my_state = MutableObject();   
    
    initNetsCb = @(pop) initNets(net_layout, pop);
    newPopCb = @(pop, fits, settings) myGenPopCb(pop, fits, settings, my_state);
    controllerCb = @(nets, state) myControllCb(nets, state);
    stepEndCb = [];
    pathEndCb = [];
    mapEndCb = [];
    simEndCb = @(state) mySimEndCb(state, my_state, log_folder);  
%   I find it usefull to enable/disable visualization during evolution
%   So I would recomend to always provide a draw callback and controll the 
%   actuall invocation trought this global variable
    global draw; draw = false;
    drawCb = @(state, prior_state, map_id, path_id) drawMap(state, prior_state, map_id, path_id,0.01, []);
    
    simulate(settings, pop, initNetsCb, newPopCb, controllerCb, ...
        stepEndCb, pathEndCb, mapEndCb, simEndCb, drawCb);
    
end

function folder_path = getThisFolder()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    folder_path;
end

