function [d_angles, speeds] = myControllCb(nets, step_state)
    % This function is here to process the inputs. Essentially the
    % neurocontroller.
    % This function is invoked with nets and step_state parameters, so
    % every other argument needs to be instantiated duing the experiment
    % initialization phase.
    % !!! IPORTANT: The output needs to be the rotation and speed.
    norm_angle_errors = (step_state.angles + pi) / (2*pi);
    norm_target_distances = step_state.target_distances ./ step_state.map.max_distance;
    norm_readings = step_state.readings/step_state.r.sensor_len;
    
    net_inputs = [norm_readings; norm_angle_errors; norm_target_distances];
    net_outputs = evalNetsTanh(nets, net_inputs);
    
    d_angles = net_outputs(1, :) * pi;
    speeds = net_outputs(2, :);
    zero_idx = speeds < -0.1;
    speeds = (speeds+0.1) * (step_state.r.max_speed/1.1);
    speeds(zero_idx) = 0;
end