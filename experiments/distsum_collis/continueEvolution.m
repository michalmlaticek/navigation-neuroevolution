function continueEvolution(gen_num, log_folder)
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
    controllerCb = @(nets, state) myControllCb(nets, state);
    stepEndCb = @(state) myStepEndCb(state, my_state);
    pathEndCb = @(state) myPathEndCb(state, my_state);
    mapEndCb = @(state) myMapEndCb(state, my_state);
    simEndCb = @(state) mySimEndCb(state, my_state, log_folder);  
    global draw; draw = true;
    drawCb = @(state, map_id, path_id) drawMap(state, map_id, path_id, [], 0.01, []);
    
    init_data = {};
    init_data.pop = data.pop;
    init_data.gen =  my_state.active_generation_num + 1;
    
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

