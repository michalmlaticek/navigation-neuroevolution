function rot_XYs = rotateXYs(xys, angles)
    rot_XYs = zeros(size(xys, 2), size(angles, 2), size(xys, 1));
    for i = 1:size(angles,2)
        rot_mat = [cos(angles(i)) -sin(angles(i)); sin(angles(i)) cos(angles(i))];
        rot_XYs(:, i, :) = round(rot_mat*xys)';
    end
end

