function sensor_lines = sensorLines(radius,len, angles)
    base_line = [[0:len-1]+radius; zeros(1, len)];
    sensor_lines = [];
    for a = 1:size(angles, 1)
        sensor_lines = [sensor_lines reshape(rotateXYs(base_line, angles(a)), len, 2)'];
    end
end

