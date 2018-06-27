function continueEvolution(gen_num, log_folder)
% continueEvolution - continue previously stopped evolution process
%
% It is very simillar than the runEvolution, but it reuses the stored
% settings object that needs to be present inside 'log_folder'
%
% gen_num: (generation number) the generation number from which you wish to
%   continue. It needs to reflect an existing file, that stores the
%   respective population.
% log_folder: folder where the initial, or prior experiment stored results
% to.

    addPaths();
    
    global logger; logger = Logger(log_folder, 'experiment.log');
    logger.debug(sprintf('Continue evolution for: %s', log_folder));
    
    logger.debug('Loading settings');
    settings = load(sprintf('%s/settings', log_folder));
    logger.debug(sprintf('Loading %d generation data', gen_num));
    data = load(sprintf('%s/out-data-gen-%d', log_folder, gen_num));
    
    logger.debug('Initializing callbacks');
    my_state = MutableObject(settings, 150);
    my_state.active_generation_num = gen_num;
    
    initNetsCb = @(pop) initNets(settings.net_layout, pop);
    newPopCb = @(pop, fits, settings) myGenPopCb(pop, fits, settings, my_state);
    controllerCb = @(nets, step_state) myControllCb(nets, step_state);
    stepEndCb = @(step_state) myStepEndCb(step_state, my_state);
    pathEndCb = @(path_state) myPathEndCb(path_state, my_state);
    mapEndCb = @(map_state) myMapEndCb(map_state, my_state);
    simEndCb = @(sim_state) mySimEndCb(sim_state, my_state, log_folder);  
    global draw; draw = false;
    drawCb = @(state, map_id, path_id) drawMap(state, map_id, path_id,0.01, []);
    
    init_data = {};
    init_data.pop = myGenPopCb(data.pop, data.fits, settings, my_state);
    init_data.gen = my_state.active_generation_num + 1;
    
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
    logger.debug(sprintf('End of simulation: %s', log_folder));    
end

