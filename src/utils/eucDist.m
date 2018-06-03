function distances = eucDist(starts, targets, axis)
    st_dxy = targets - starts;
    st_dxy_power2 = st_dxy.^2;
    sum_power = sum(st_dxy_power2, axis);
    distances = sqrt(sum_power);
end