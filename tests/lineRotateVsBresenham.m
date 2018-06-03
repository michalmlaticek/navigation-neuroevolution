function lineRotateVsBresenham()
    sensor_angles = zeros(7, 150) +  deg2rad(-60:20:60)';
    positions = zeros(1, 150, 2) + [1:150];
    robot = {};
    robot.radius = 5;
    robot.sensorLen = 40;
    
    tic
    for i = 1:10000
        get_sensor_lines(sensor_angles, positions, robot);
    end
    toc

    base_line = [5:44; zeros(1, 40)];
    sensor_lines = [];
    for a = 1:size(sensor_angles, 1)
        sensor_lines = [sensor_lines reshape(rotateXYs(base_line, sensor_angles(a)), 2, 40)];
    end
    robot_angles = linspace(-pi, pi, 150);
    
    tic
    for i = 1:10000
        rot_xys = rotateXYs(sensor_lines, robot_angles);
        rot_xys + positions;
    end
    toc    
end

function sensor_lines = get_sensor_lines(sensor_angles, robot_positions, robot)
    % sensor_start_points
    sensor_start_xys = get_coordinates(robot_positions,  ...
                                       sensor_angles, robot.radius);
    
    % sensor_end_points
    sensor_end_xys = get_coordinates(robot_positions, ...
                                    sensor_angles, ...
                                    (robot.radius + robot.sensorLen));
    
    % sensor_line_coordinates
    sensor_lines = calc_line_coordinates(sensor_start_xys, sensor_end_xys);
end

function lines_lists = calc_line_coordinates(start_xys, end_xys)
    start_xys = round(start_xys);
    end_xys = round(end_xys);
    lines_lists = cell(1, size(start_xys, 2));
    for col = 1:size(start_xys, 2)
        lines = cell(1, size(start_xys, 1));
        for row = 1:size(start_xys, 1)
            lines{row} = bresenham(start_xys(row, col, :), end_xys(row, col, :));
        end % for row
        lines_lists{col} = lines;
    end % for col
end

function [xys, dxys] = get_coordinates(start_xys, angles, hypotenuses)
    sin_mat = sin(angles);
    cos_mat = cos(angles);
    dxys = cat(3, cos_mat, sin_mat) .* hypotenuses;
    xys = dxys + start_xys;
end
