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
    
    prior_best_fit = my_state.best_fitness;
    logger.debug(sprintf('Prior best fitness: %f', prior_best_fit));
    
    [fits, best, best_dists, best_collis] = my_state.fitness();
    
    if mod(my_state.active_generation_num, 20) == 1 || prior_best_fit ~= best
       m_s = my_state.toStruct();
       save(sprintf('%s/out-data-gen-%d', log_folder, my_state.active_generation_num), ...
           '-struct', 'm_s');
    end
    
    
    % log some interesting values
    logger.debug(sprintf('Best fit: %f', best));
    logger.debug('Distance | Collision');
    logger.debug(sprintf('\n%f\t|\t%d', [best_dists, best_collis]'));
    my_state.incGenerationNum();
    my_state.mo_reset();
end