function myStepEndCb(step_state, my_state)
    % myStepEndCb is executed after every simulation step. 
    % the callback is only called with the step_state parameter, so 
    % my_state needs to be initialized by you within the run script
    % or removed
    my_state.addAngleErrors(step_state.angle_errors);
end