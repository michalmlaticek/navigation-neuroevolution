function fits = mySimEndCb(state, my_state, log_folder)
    global logger
    i = 1;
    for m = 1:size(state.maps, 1)
       for p = 1:size(state.maps{m}.paths, 1)
          my_state.distances(i, :) = state.maps{m}.paths{p}.target_distances;
          my_state.collisions(i, :) = state.maps{m}.paths{p}.collisions;
          i = i + 1;
       end
    end
    
    prior_best_fitness = my_state.best_fitness;
    
    [fits, best_fit, best_fit_distances, best_fit_collisions, best_fit_angle_errors]  = my_state.fitness();
    
    if mod(my_state.active_generation_num, 10) == 1 || prior_best_fitness ~= best_fit
       m_s = my_state.toStruct();
       save(sprintf('%s/out-data-gen-%d', log_folder, my_state.active_generation_num), ...
           '-struct', 'm_s');
    end
    logger.debug(sprintf('Gen: %d - Fit: %f', my_state.active_generation_num, best_fit));
    logger.debug('Distances | Collisions | Avg. angle error');
    logger.debug(sprintf('\n%f\t%f\t%f', ...
        [best_fit_distances, best_fit_collisions, best_fit_angle_errors]'));
    
    my_state.incGenerationNum();
    my_state.reset();
end
