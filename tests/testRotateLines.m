function testRotateLines()
    im = ones(250, 250);
    sensor_angles = deg2rad(-60:20:60)';
    sensor_len = 40;
    robot_radius = 10;
    lines = sensorLines(robot_radius, sensor_len, sensor_angles);
    rot_lines = rotateXYs(lines, 0);

    im_lines = drawXYs(im, rot_lines + reshape([100 100], 1, 1, 2), 0);
    
    img = [];
    img(:, :, 1) = im_lines;
    img(:, :, 2) = im_lines;
    img(:, :, 3) = im_lines;
    
    image(img);
    axis image
    
    for a = 1:0.25:2*pi
       rot_lines = rotateXYs(lines, a);
       im_lines = drawXYs(im, rot_lines + reshape([100 100], 1, 1, 2), 0);
       img(:, :, 1) = im_lines;
       img(:, :, 2) = im_lines;
       img(:, :, 3) = im_lines;
       image(img);
       axis image
       pause(1);
    end
    
end

function grid = drawXYs(grid, xys, c_idx)
    for i = 1:size(xys, 1)
        if xys(i, 1, 1) > 0 && ...
                xys(i, 1, 2) > 0 && ...
                xys(i, 1, 1) <= size(grid, 1) && ...
                xys(i, 1, 2) <= size(grid, 2)
            grid(xys(i, 1, 1), xys(i, 1, 2)) = c_idx;            
        end            
    end
end

