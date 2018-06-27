function runEvolution()  
    addPaths(); % read function description
    
    global logger; % I found it easiest to use a global variable representing a logger
    
    % Let's initialize folder structure for logging
    [logger, log_folder, experiment] = initLogging();

    % Let's now initialize the key experiment parameters
    logger.debug('Initializings settings');
    % network configuration (9 - node input layer, 5 - node hidden layer, 2 - node output layer)
    net_layout = [9 5 2]; 
    
    % Simulation step count - define how many steps the agent is allowed to
    % take, while trying to reach the target
    step_count = 500;
    
    % Initialize map(s) object(s) - read the mapFromImg for more details
    maps = {};
    maps{1} = mapFromImg('../../maps/moon.png', ...
        [23 23; 230 120; 220 225; 23 23], [220 30; 25 215; 23 23; 220 225]);
    maps{2} = mapFromImg('../../maps/factory.png', ...
        [25 20; 75 230; 225 235; 25 20; 175 20; 80 20], [200 145; 70 20; 50 120; 230 230; 150 180; 115 20]);
    
    % Define robots properties
    r_radius = 5;
    % The following config initializes the sensors spread every 20
    % degrees starting from -60 to 60 from the initial rotation
    r_sensor_angles = [-60:20:60]';
    % Length of the sensors (essentially in pixels)
    r_sensor_len = 40;
    % Maximum step size. So the agent can move up to 25 "pixels" at once
    r_max_speed = 25;
    % Initial angle rotation (0 = agent will face streight down)
    r_init_angle = 0;
    
    % Prepare the settings object based on the above values, that will be
    % passed allong internal functions
    settings = initSettings(net_layout, step_count, maps, r_radius, ...
        r_sensor_angles, r_sensor_len, r_max_speed, r_init_angle);
    
    % Save settings struct into the log folder
    save(sprintf('%s/settings', log_folder), '-struct', 'settings')

    % Initialize callback functions
    % read respected callback description for more details
    logger.debug('Initializing callbacks');
    my_state = MutableObject(settings, 150);
    
    initNetsCb = @(pop) initNets(net_layout, pop);
    newPopCb = @(pop, fits, settings) myGenPopCb(pop, fits, settings, my_state);
    controllerCb = @(nets, step_state) myControllCb(nets, step_state);
    stepEndCb = @(step_state) myStepEndCb(step_state, my_state);
    pathEndCb = @(path_state) myPathEndCb(path_state, my_state);
    mapEndCb = @(map_state) myMapEndCb(map_state, my_state);
    simEndCb = @(sim_state) mySimEndCb(sim_state, my_state, log_folder);  
%   I find it usefull to enable/disable visualization during evolution
%   So I would recomend to always provide a draw callback and controll the 
%   actuall invocation trought this global variable
    global draw; draw = false;
    drawCb = @(state, map_id, path_id) drawMap(state, map_id, path_id, [], 0.01, []);
    
    logger.debug('Initializing first population');
    init_data = {};
    init_pop = zeros(settings.genom_len, 150);
    init_fits = zeros(1, 150)+100000;
    init_data.pop = newPopCb(init_pop, init_fits, settings);
    init_data.gen = 1;
    
    gen_count = 1500;
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
% initLogging - function for initializing the folder structure used for
% logging

    % just a timestamp used as a run id
    rng_id = round(now*1000);
    run_id = sprintf('%9.0f', rng_id);
    
    % Extract folder name, that serves as experiment root id
    experiment_root = extract_experiment_name();
    experiment_id = sprintf('%s/%s', experiment_root, run_id);
    log_folder = sprintf('../../logs/%s', experiment_id);
    
    logger = Logger(log_folder, 'experiment.log'); % This operation creates the log folder
    
    % copy files experiment config files to log folder, so that we can
    % always re-trace how the experiment was executed.
    logger.debug('Coppining src / config files to log folder');
    copy_src(log_folder);
end

function name = extract_experiment_name()
    file_path = mfilename('fullpath');
    idx = strfind(file_path,'\');
    name = file_path(idx(end-1)+1:idx(end)-1);
end

function copy_src(log_folder)
    to_copy = [{'runEvolution.m'}, {'addPaths.m'}, {'MutableObject.m'}, {'continueEvolution.m'}];
    for i = 1:length(to_copy)
        copyfile(to_copy{i}, log_folder);
    end
    copyfile('callbacks', sprintf('%s/callbacks', log_folder));
end

