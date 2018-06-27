function ga(...
    init_data, ... % struct with pop (as population) and gen (as start generation) number
    gen_count, ... % just a number represeting the number of generations to run
    settings, ... % settings object (struct)
    initNetsCb, ...
    newPopCb, ...
    controllerCb, ...
    stepEndCb, ...
    pathEndCb, ...
    mapEndCb, ...
    simEndCb, ... % needs to return fitnesses
    drawCb)
% ga - is the function to be triggered to start the evolution.
%



    global logger;
    
    pop = init_data.pop;
    start_gen = init_data.gen;
    end_gen = start_gen + gen_count - 1;

    for gen = start_gen:end_gen
        logger.debug(sprintf('Generation: %d: ',gen));
        logger.debug('Initializing neural nets');
        nets = initNetsCb(pop); % initialize networks based on the chromosome
        logger.debug('Running simulation');
        states = simMultiPath(nets, settings.sim, controllerCb, stepEndCb, ...
            pathEndCb, mapEndCb, drawCb); 
        
        fits = simEndCb(states);
        if start_gen<end_gen % if we havent reached the max generation count, continue and generate new population
            pop=newPopCb(pop, fits, settings);
        end
    end    
end
