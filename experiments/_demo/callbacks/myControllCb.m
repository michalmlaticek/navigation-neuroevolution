function [d_angles, speeds] = myControllCb(nets, step_state)
    % This function is here to process the inputs. Essentially the
    % neurocontroller.
    % This function is invoked with nets and step_state parameters, so
    % every other argument needs to be instantiated duing the experiment
    % initialization phase.
    % !!! IPORTANT: The output needs to be the rotation and speed.
    
    % Normalize azimuth(s) to value between 0 and 1
    norm_angle_errors = (step_state.angles + pi) / (2*pi);
    % Normalize target distance to value between 0 and 1 (max_distance is
    % calculated within initSettings function and is derived from map size 
    norm_target_distances = step_state.target_distances ./ step_state.map.max_distance;
    % Normalize sensor readings to values between 0 and 1 by dividing the
    % read distance by the sensor lenght.
    norm_readings = step_state.readings/step_state.r.sensor_len;
    
    net_inputs = [norm_readings; norm_angle_errors; norm_target_distances];
    
    % Function for evaluating the nerual network
    net_outputs = evalNetsTanh(nets, net_inputs);
    
    d_angles = net_outputs(1, :) * pi; % fist output node is represented as angle
    
    % extract speed value from the second output node
    speeds = net_outputs(2, :);
    zero_idx = speeds < -0.1; % everything beneeth this point represents speed 0
    speeds = (speeds+0.1) * (step_state.r.max_speed/1.1); % convert normalized value to actuall speed
    speeds(zero_idx) = 0; % set everything that is suposed to be 0 to 0.
end