function simulate(log_folder, gen_id, unique_best_idx, map_path, init_position, target_position, step_count)
    % simulate - triggers the simulation of a desired experiment with
    % desired population.
    %
    % usage:
    %   log_folder - is the folder where the data was stored during the
    %                evolution
    %   gen_id - the generation number identifying the appropriate mat file
    %   unique_bes_idx - is a vector representing ids of the population
    %                   member according to their relative fitness. (i.e.: if you would
    %                   want to simulate the best chromosome and the second and fift, the
    %                   vector would look like: [1, 2, 5]
    %   map_path - (optional) - path to file image. If you don't provide,
    %                           then original map(s) are used.
    %   init_position - (depends) - starting position - if you dont provide map_path, than this
    %                   will be ignored, if map_path is provided, then you also need to
    %                   provide the initial position.
    %   target_position - (depends) - target position - the same rules as
    %                   for init_position applies
    addpath(genpath('..\src'));
    addpath(genpath(log_folder));
    
    addpath(sprintf('%s/sim_callbacks', getThisFolder()));

    settings = load(sprintf('%s/settings', log_folder));

    global logger; logger = Logger(log_folder, 'simulation-run.log');

    %load population
    data = load(sprintf('%s/out-data-gen-%d.mat', log_folder, gen_id));
    pop = data.pop;
    fits = data.fits;
    
    % create a unique population
    pop = [fits; pop];
    pop = unique(pop', 'rows')';
    pop = pop(2:end, :);
    
    if exist('unique_best_idx', 'var') && ~isempty(unique_best_idx)
        rel_fits_valid_idx = unique_best_idx <= size(pop, 1);
        pop = pop(:, unique_best_idx(rel_fits_valid_idx));
    end
    
    if exist('map_path', 'var') && ~isempty(map_path)
        settings.sim.maps = {};
        settings.sim.maps{1} = mapFromImg(map_path, init_position, target_position);
    end
    
    if exist('step_count', 'var') && ~isempty(step_count)
       settings.step_count = step_count;
    end
    
    figure;

    my_state = BaseObject(settings, size(pop, 2));
    
    initNetsCb = @(pop) initNets(settings.net_layout, pop);
    newPopCb = [];
    controllerCb = @(nets, state) myControllCb(nets, state);
    stepEndCb = @(step_state) simStepEndCb(step_state, my_state);
    pathEndCb = @(path_state) simPathEndCb(path_state, my_state, log_folder);
    mapEndCb = @(map_state) simMapEndCb(map_state, my_state);
    simEndCb = @(sim_state) simSimEndCb(sim_state, my_state, log_folder);  
%   I find it usefull to enable/disable visualization during evolution
%   So I would recomend to always provide a draw callback and controll the 
%   actuall invocation trought this global variable
    global draw; draw = true;
    drawCb = @(state, map_id, path_id) drawMap(state, map_id, path_id, my_state.prior_states, 0.01, []);
    
    gen_count = 1;
    init_data = {};
    init_data.pop = pop;
    init_data.gen = 1;
    
    ga(init_data, gen_count, settings, initNetsCb, newPopCb, controllerCb, ...
        stepEndCb, pathEndCb, mapEndCb, simEndCb, drawCb);
end

function folder_path = getThisFolder()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
end

