function s = simPath( ...
    nets, ...
    map, ...
    start, ...
    target, ...
    r, ... % robot
    step_count, ...
    controllCb, ...
    stepEndCb, ...
    drawCb)
% simPath - the is the function, that runs the simulation

    global logger
    global draw

    if ~isempty(logger)
        logger.debug('Initializing internal parameters');
    end
    pop_size = size(nets{1}.b, 2);    
    sensor_count = size(r.sensor_angles, 1);
    sensor_len = size(r.sensor_lines, 2) / sensor_count;
    grid = map.grid;

    s = {}; % state for callbacks
    % for convenience provide key input params
    s.nets = nets;
    s.map = map;
    s.start = start;
    s.target = target;
    s.r = r;
    
    % add internal state params
    s.angles = zeros(1, pop_size); % aloc angles array
    [s.angles, s.sensor_lines] = rotate(s.angles, r.sensor_lines, r.init_angle); % rotate all agents, based on initial rotation

    s.positions = zeros(1, pop_size, 2) + start; % aloc array and move to start
    s.bodies = r.body + s.positions; % move all body coordinates to start
    s.sensor_lines = s.sensor_lines + s.positions; % move all sensor coordinates to start

    s.angle_errors = angleErrors(s.positions, s.angles, target); % calculate azimuths
    s.target_distances = eucDist(s.positions, target, 3); % calculate target distances
    s.collisions = zeros(1, pop_size); % aloc collision counters array and initialize to 0
    s.collision_idx = zeros(1, pop_size); % indicator of collision occurents in current step

    if ~isempty(draw) && draw == true &&  ~isempty(drawCb)
       drawCb(s); % draw is drawCb is provided as well as global wariable is set to true
    end
    if ~isempty(logger)
        logger.debug('Starting steps');
    end
    for step = 1:step_count % for each step
        % read sensors
        s.readings = readSensors(s.sensor_lines, sensor_count, sensor_len, grid);
        
        % calculate cpontroll outputs
        [s.d_angles, s.speeds] = controllCb(nets, s);

        % update rotation
        [s.angles, s.sensor_lines] = rotate(s.angles, r.sensor_lines, s.d_angles);
       
        % update position
        [s.positions, s.bodies, s.sensor_lines, s.d_xys] = translate( ...
            s.positions, r.body, s.sensor_lines, s.angles, s.speeds);
       
        % check for collision
        s.collision_idx = collisionIdx(grid, s.bodies, s.positions, s.d_xys, s.speeds, r.radius);
        
        % update internal state
        s.angle_errors = angleErrors(s.positions, s.angles, target);
        s.target_distances = eucDist(s.positions, target, 3);
        s.collisions = s.collisions + s.collision_idx;
        
        if ~isempty(draw) && draw == true &&  ~isempty(drawCb)
            drawCb(s);
        end
        
        if ~isempty(stepEndCb)
            stepEndCb(s);
        end
    end % for step
end

function [angles, sensor_lines] = rotate(...
        angles, r_sensor_lines,  d_angles)

    angles = minusPlusPi(angles + d_angles);
    sensor_lines = rotateXYs(r_sensor_lines, angles);
end

function [positions, bodies, sensor_lines, d_xys] = translate(...
        positions, base_body, rot_base_sensor_lines, angles, speeds)
    [positions, d_xys] = newXYs(positions, angles, speeds);
    bodies = round(base_body + positions);
    sensor_lines = round(rot_base_sensor_lines + positions);
end


