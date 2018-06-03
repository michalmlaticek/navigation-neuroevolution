function readings = readSensors(sensor_lines, sensor_count, sensor_len, map)
    robot_count = size(sensor_lines, 2);
    
    readings = zeros(sensor_count, robot_count) + sensor_len;
    for robot = 1:robot_count
        for sensor = 1:sensor_count
            ep = sensor*sensor_len; % sensor end point
            sp = ep - sensor_len + 1; % sensor start point
            for lp = sp:ep % sensor line point
                if sensor_lines(lp, robot, 1) < 1 || ...
                        sensor_lines(lp, robot, 2) < 1 || ...
                        sensor_lines(lp, robot, 1) > size(map, 1) || ...
                        sensor_lines(lp, robot, 2) > size(map, 2) || ...
                        map(sensor_lines(lp, robot, 1), sensor_lines(lp, robot, 2)) ~= 1 % 1 == free
                    % distance from sensor start (circle rim) to obstacle point
                    readings(sensor, robot) = eucDist(sensor_lines(sp, robot, :), sensor_lines(lp, robot, :), 3); 
                    break; % we only retur closest reading
                end % if
            end % for line_point
        end % for sensor
    end % for robots
end
