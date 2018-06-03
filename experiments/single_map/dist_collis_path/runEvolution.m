function runEvolution()
    cd_here();    
    addPaths();
    
    global logger;
    [logger, log_folder, experiment] = initLogging();

    logger.debug('Initializings settings');
    net_layout = [9 5 2];
    step_count = 500;
    maps = {};
    maps{1} = mapFromImg('../../../maps/simple_map.png', [25 25], [215 215]);
    r_radius = 5;
    r_sensor_angles = [-60:20:60]';
    r_sensor_len = 40;
    r_max_speed = 25;
    r_init_angle = 0;
    settings = initSettings(net_layout, step_count, maps, r_radius, ...
        r_sensor_angles, r_sensor_len, r_max_speed, r_init_angle);
    save(sprintf('%s/settings', log_folder), '-struct', 'settings')

    logger.debug('Initializing callbacks');
    my_state = MutableObject();    
    
    initNetsCb = @(pop) initNets(net_layout, pop);
    newPopCb = @(pop, fits, settings) myGenPopCb(pop, fits, settings, my_state);
    controllerCb = @(nets, state) myControllCb(nets, state, my_state);
%     stepEndCb = @(state) myStepEndCb(state, my_state);
    stepEndCb = [];
    pathEndCb = @(state) myPathEndCb(state, my_state);
    mapEndCb = [];
    simEndCb = @(state) mySimEndCb(state, my_state, log_folder);
    
%   I find it usefull to enable/disable visualization during evolution
%   So I would recomend to always provide a draw callback and controll the 
%   actuall invocation trought this global variable
    global draw; draw = false;
    drawCb = @(state, map_id, path_id) drawMap(state, map_id, path_id,0.01, []);
    
    logger.debug('Initializing first population');
    init_data = {};
    init_pop = zeros(settings.genom_len, 150);
    init_fits = zeros(1, 150)+100000;
    init_data.pop = newPopCb(init_pop, init_fits, settings);
    init_data.gen = 1;
    
    gen_count = 1000;
    ga( ...
        init_data, ... % {}.pop, {}.gen
        gen_count, ...
        settings, ...
        initNetsCb, ...
        newPopCb, ...
        controllerCb, ...
        stepEndCb, ...
        pathEndCb, ...
        mapEndCb, ...
        simEndCb, ... % needs to return fitnesses
        drawCb);
    logger.debug(sprintf('End of simulation: %s', experiment));
end

function [logger, log_folder, experiment_id] = initLogging()
    rng_id = round(now*1000);
    run_id = sprintf('%9.0f', rng_id);
    rng(rng_id)
    
    % Extract folder name, that serves as experiment root id
    experiment_root = extract_experiment_name();
    experiment_id = sprintf('%s/%s', experiment_root, run_id);
    log_folder = sprintf('../../../logs/%s', experiment_id);
    
    logger = Logger(log_folder, 'experiment.log');    
    
    logger.debug('Coppining src / config files to log folder');
%     Just copping src along the logs and data for clarity
    copy_src([{'runEvolution.m'}, {'addPaths.m'}, {'MutableObject.m'}], ...
        log_folder);
end

function cd_here()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    cd(folder_path);
end

function name = extract_experiment_name()
    str = pwd;
    idx = strfind(str,'\');
    name = str(idx(end-1)+1:end);
end

function copy_src(to_copy, log_folder)
    for i = 1:length(to_copy)
        copyfile(to_copy{i}, log_folder);
    end
end

