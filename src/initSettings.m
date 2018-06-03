function s = initSettings(...
    net_layout, ...
    step_count, ...
    maps, ...
    robot_radius, ...
    robot_sensor_angles, ...
    robot_sensor_len, ...
    robot_max_speed, ...
    robot_init_angle)
    % settings -    

    s = {};
    s.net_layout = net_layout;
    s.genom_len = wbCount(net_layout);
    
    sim = {};
    sim.step_count = step_count; % number of steps the agent is executing
    sim.maps = maps;

    sim.r = {};
    sim.r.radius = robot_radius;
    sim.r.sensor_angles = deg2rad(robot_sensor_angles);
    sim.r.sensor_len = robot_sensor_len;
    sim.r.max_speed = robot_max_speed;
    sim.r.init_angle = robot_init_angle;
    body = xyCircle(sim.r.radius);
    sim.r.body = reshape(body, [size(body, 1), 1, 2]);
    sim.r.sensor_lines = sensorLines(robot_radius,robot_sensor_len, sim.r.sensor_angles);
    
    s.sim = sim;
end

