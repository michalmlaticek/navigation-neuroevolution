function continueEvolution(gen_num, folder)
    addPaths();
    cd(folder);
    
    global logger; logger = Logger(folder, 'experiment.log');
    logger.debug(sprintf('Continue evolution for: %s', folder));
    
    logger.debug('Loading settings');
    settings = load('settings');
    logger.debug(sprintf('Loading %d generation data', gen_num));
    data = load(sprintf('out-data-gen-%d', gen_num));
    
    logger.debug('Initializing callbacks');
    my_state = MutableObject();    
    
    initNetsCb = @(pop) initNets(settings.net_layout, pop);
    newPopCb = @(pop, fits, settings) myGenPopCb(pop, fits, settings, my_state);
    controllerCb = @(nets, state) myControllCb(nets, state);
    stepEndCb = [];
    pathEndCb = [];
    mapEndCb = [];
    simEndCb = @(state) mySimEndCb(state, my_state, log_folder);  
    global draw; draw = false;
    drawCb = @(state, map_id, path_id) drawMap(state, map_id, path_id,0.01, []);
    
    init_data = {};
    init_data.pop = myGenPopCb(data.pop, data.fits, settings, my_state);
    init_data.gen = gen_num + 1;
    
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
    logger.debug(sprintf('End of simulation: %s', folder));    
end

