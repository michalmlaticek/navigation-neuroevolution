function myMapEndCb(map_state, my_state)
    % This function is called after simulation for a map is finished.
    % i.e.: If a map is defined to have 5 path simulations, than after
    % every path for that map is executed.
    % The function is only called with the map_state argument, so every
    % other argument needs to be instatiated during experiment
    % initialization phase
    my_state.incMapNum();
end