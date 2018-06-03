function [d_angles, speeds] = myControllCb(nets, state, my_state)
    norm_angle_errors = (state.angles + pi) / (2*pi);
    norm_target_distances = state.target_distances ./ state.map.max_distance;
    norm_readings = state.readings/state.r.sensor_len;
    
    net_inputs = [norm_readings; norm_angle_errors; norm_target_distances];
    net_outputs = evalNetsTanh(nets, net_inputs);
    
    d_angles = net_outputs(1, :) * pi;
    speeds = net_outputs(2, :);
    zero_idx = speeds < -0.1;
    speeds(zero_idx) = 0;
    speeds = (speeds+0.1) * (state.r.max_speed/1.1);
    
    % track in my state
    my_state.addPath(speeds);
end