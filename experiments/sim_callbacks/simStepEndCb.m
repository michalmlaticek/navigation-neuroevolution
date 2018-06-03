function simStepEndCb(step_state, my_state)
    my_state.prior_states{end+1} = step_state;
    
end

