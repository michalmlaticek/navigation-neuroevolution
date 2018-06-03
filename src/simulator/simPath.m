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
    s.angles = zeros(1, pop_size);
    [s.angles, s.sensor_lines] = rotate(s.angles, r.sensor_lines, r.init_angle);

    s.positions = zeros(1, pop_size, 2) + start;
    s.bodies = r.body + s.positions;
    s.sensor_lines = s.sensor_lines + s.positions;

    s.angle_errors = angleErrors(s.positions, s.angles, target);
    s.target_distances = eucDist(s.positions, target, 3);
    s.collisions = zeros(1, pop_size);
    s.collision_idx = zeros(1, pop_size);

    if ~isempty(draw) && draw == true &&  ~isempty(drawCb)
       drawCb(s);
    end
    if ~isempty(logger)
        logger.debug('Starting steps');
    end
    for step = 1:step_count
        s.readings = readSensors(s.sensor_lines, sensor_count, sensor_len, grid);
        
        [d_angles, speeds] = controllCb(nets, s);

        [s.angles, s.sensor_lines] = rotate(s.angles, r.sensor_lines, d_angles);
       
        [s.positions, s.bodies, s.sensor_lines, s.d_xys] = translate( ...
            s.positions, r.body, s.sensor_lines, s.angles, speeds);
       
        s.collision_idx = collisionIdx(grid, s.bodies, s.positions, s.d_xys, speeds, r.radius);
        
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


