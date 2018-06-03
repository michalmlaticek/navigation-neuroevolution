function fits = mySimEndCb(state, my_state, log_folder)
    global logger
    i = 1;
    distances = []; collisions = [];
    for m = 1:size(state.maps, 1)
       for p = 1:size(state.maps{m}.paths, 1)
          distances(i, :) = state.maps{m}.paths{p}.target_distances;
          collisions(i, :) = state.maps{m}.paths{p}.collisions;
          i = i + 1;
       end
    end
    
    % log some interesting values
    logger.debug('Distance | Collision');
    logger.debug(sprintf('\n%f\t|\t%d', [distances, collisions]'));
end