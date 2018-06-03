function angle_errors = angleErrors(positions, angles, targets)
    rebased_targets = targets - positions;
    target_angles = atan2(rebased_targets(1, :, 2), rebased_targets(1, :, 1));
    angle_errors = minusPlusPi(target_angles - angles);
end