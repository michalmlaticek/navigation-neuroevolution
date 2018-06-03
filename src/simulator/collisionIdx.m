function colision_idx = collisionIdx(map, bodies, positions, d_xys, speeds, radius)
    colision_idx = zeros(1, size(positions, 2));
    for i = 1:size(positions, 2)
        % check target position
        if isCollision(bodies(:, i, :), map)
                colision_idx(1, i) = 1;
                continue;
        end
        % if step was bigger than half of radius, check also the midpoint
        % should help to avoid not chathing collisions on corners
        checkpoints = floor(speeds(i) / radius);
        cp_dxy =  round(d_xys(1, i, :) / (checkpoints+1));
        for cp = 1:checkpoints
            cp_bodies = bodies(:, i, :) - (cp_dxy * cp);
            if isCollision(cp_bodies, map)
                colision_idx(1, i) = 1;
            end
        end
    end
end