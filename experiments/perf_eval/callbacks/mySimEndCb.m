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
    
    prior_best_fit = my_state.best_fit;
    
    fits = mean(my_state.distances + 10*my_state.collisions, 1);
    my_state.fits = fits;
    [best_fit, dists, collis] = my_state.bestFit();
    
    my_state.incGenCounter();
    if mod(my_state.gen_counter, 10) == 1 || prior_best_fit ~= best_fit
       m_s = my_state.toStruct();
       save(sprintf('%s/out-data-gen-%d', log_folder, my_state.gen_counter), ...
           '-struct', 'm_s');
    end
    logger.debug(sprintf('Gen: %d - Fit: %f', my_state.gen_counter, best_fit));
    logger.debug('Distance | Collisions');
    logger.debug(sprintf('[%f\t|\t%f]', [dists, collis]'));
end