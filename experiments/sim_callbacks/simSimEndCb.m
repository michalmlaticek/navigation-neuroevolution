function fits = mySimEndCb(sim_state, my_state, log_folder)
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
    
    logger.debug('Distances | Collisions');
    logger.debug(sprintf('\n%f\t|\t%f', [best_fit_distances, best_fit_collisions]'));  
end
