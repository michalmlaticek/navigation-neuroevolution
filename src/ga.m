function ga(...
    init_data, ... % struct with pop (as population) and gen (as start generation) number
    gen_count, ...
    settings, ...
    initNetsCb, ...
    newPopCb, ...
    controllerCb, ...
    stepEndCb, ...
    pathEndCb, ...
    mapEndCb, ...
    simEndCb, ... % needs to return fitnesses
    drawCb)
    global logger;
    
    pop = init_data.pop;
    start_gen = init_data.gen;
    end_gen = start_gen + gen_count - 1;

    for gen = start_gen:end_gen
        logger.debug(sprintf('Generation: %d: ',gen));
        logger.debug('Initializing neural nets');
        nets = initNetsCb(pop);
        logger.debug('Running simulation');
        states = simMultiPath(nets, settings.sim, controllerCb, stepEndCb, ...
            pathEndCb, mapEndCb, drawCb);
        
        fits = simEndCb(states);
        if start_gen<end_gen
            pop=newPopCb(pop, fits, settings);
        end
    end    
end