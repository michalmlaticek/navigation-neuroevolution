function myPathEndCb(path_state, my_state)
    % This method is invoked after a simulation for a path was finished
    % It's only called with the path_state argument, so every other argumet
    % needs to be initialized during experiment initialization phase
    my_state.incPathNum();
end