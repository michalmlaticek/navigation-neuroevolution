function myStepEndCb(state, my_state)
    my_state.prior_states{end+1} = state.s;
end