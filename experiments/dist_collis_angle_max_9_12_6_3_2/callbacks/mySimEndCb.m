function fits = mySimEndCb(sim_state, my_state, log_folder)
    % mySimEndCb is executed after the simulation fully finishes
    % the function is only called with the sim_state argument, 
    % so all other required arguments need to be provided
    % during experiment initialization stage
    %
    % !!! IMPORTANT: This function must return a vector (1, pop_size) of fitness values

    global logger;
    
    logger.debug('Geting position and collision counts.');
    i = 1;
    for m = 1:size(sim_state.maps, 1)
       for p = 1:size(sim_state.maps{m}.paths, 1)
          my_state.distances(i, :) = sim_state.maps{m}.paths{p}.target_distances;
          my_state.collisions(i, :) = sim_state.maps{m}.paths{p}.collisions;
          i = i + 1;
       end
    end
    
    prior_best_fit = my_state.best_fitness;
    logger.debug(sprintf('Prior best fitness: %f', prior_best_fit));
    
    
    [fits, best_fit, best_fit_distances, best_fit_collisions, best_fit_angle_errors] = my_state.fitness();
    
    if mod(my_state.active_generation_num, 30) == 1 || prior_best_fit ~= best_fit
       m_s = my_state.moToStruct();
       save(sprintf('%s/out-data-gen-%d', log_folder, my_state.active_generation_num), ...
           '-struct', 'm_s');
    end
    logger.debug(sprintf('Gen: %d - Fit: %f', my_state.active_generation_num, best_fit));
    logger.debug('Distances | Collisions | Angle err sum');
    logger.debug(sprintf('\n%f\t|\t%f\t|\t%f', [best_fit_distances, best_fit_collisions, best_fit_angle_errors]'));    

    my_state.moReset(); % reseting internal properties for new generation
    my_state.incGenerationNum();    
end
