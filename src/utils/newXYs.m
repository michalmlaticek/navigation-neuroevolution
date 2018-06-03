function [xys, d_xys] = newXYs(start_xys, angles, step_sizes)
    sin_mat = sin(angles);
    cos_mat = cos(angles);
    d_xys = cat(3, cos_mat, sin_mat) .* step_sizes;
    xys = d_xys + start_xys;
end