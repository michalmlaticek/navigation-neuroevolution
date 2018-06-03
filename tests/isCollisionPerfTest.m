function isCollisionPerfTest()
    map = MapFactory.basic_map(250, 250, 10, 10, 2);
    radius = 5;
    body = get_body(radius);
    bodies = reshape(body, [length(body), 1, 2]);
    dxys = [];
    dxys(1, 1, 1) = 15; dxys(1, 1, 2) = 15;
    speeds = sqrt(15^2 + 15^2);
    target_positions = [];
    target_positions(1, 1, 1) = 40;
    target_positions(1, 1, 2) = 40;
    
    s = cputime;
    get_collis_1000000x(map, bodies, target_positions, dxys, speeds, radius);
    e = cputime;
    fprintf('Old duration = %f\n', e - s);
    
    s = cputime;
    get_new_collis_1000000x(map, bodies, target_positions, dxys, speeds, radius);
    e = cputime;
    fprintf('New duration = %f\n', e - s);
end

function get_collis_1000000x(map, bodies, target_positions, dxys, speeds, radius)
    for i = 1:1000000
       get_collisions(map, bodies, target_positions, dxys, speeds, radius); 
    end
end

function get_new_collis_1000000x(map, bodies, target_positions, dxys, speeds, radius)
    for i = 1:1000000
       get_collisions(map, bodies, target_positions, dxys, speeds, radius); 
    end
end

function colision_indicators = get_collisions(map, ...
        bodies, target_positions, dxys, speeds, radius)
    colision_indicators = zeros(1, size(target_positions, 2));
    for i = 1:size(target_positions, 2)
        % check target position
        if is_collision(bodies(:, i, :), map)
                colision_indicators(1, i) = 1;
                continue;
        end
        % if step was bigger than half of radius, check also the midpoint
        % should help to avoid not chathing collisions on corners
        checkpoints = floor(speeds(i) / (radius/2));
        cp_dxy =  round(dxys(1, i, :) / (checkpoints+1));
        for cp = 1:checkpoints
            cp_bodies = bodies(:, i, :) - (cp_dxy * cp);
            if is_collision(cp_bodies, map)
                colision_indicators(1, i) = 1;
            end
        end
    end
end

function bool_result = is_collision(body, map)
    bool_result = false;
    for i = 1:size(body, 1)
       if body(i, 1, 1) > size(map, 1) || ...
           body(i, 1, 2) > size(map, 2) || ...
           body(i, 1, 1) < 1 || ...
           body(i, 1, 2) < 1 || ...
           map(body(i, 1, 1), body(i, 1, 2)) == 0
            bool_result = true;
            break;
       end
    end
end

 function body = get_body(radius) 
    body = [];
    for i = -radius:radius
        for j = -radius:radius
            if i^2+j^2 <= radius^2 % is inside robot circle?
                body = [body, [i; j]];
            end
        end % for - j
    end % for - i
 end 



 
 function colision_indicators = get_new_collisions(map, ...
        bodies, target_positions, dxys, speeds, radius)
    colision_indicators = zeros(1, size(target_positions, 2));
    for i = 1:size(target_positions, 2)
        path_body = bodies(:, i, :);
        % if step was bigger than half of radius, check also the midpoint
        % should help to avoid not chathing collisions on corners
        checkpoints = floor(speeds(i) / (radius/2));
        cp_dxy =  round(dxys(1, i, :) / (checkpoints+1));
        for cp = 1:checkpoints
            cp_bodies = bodies(:, i, :) - (cp_dxy * cp);
            if is_collision(cp_bodies, map)
                colision_indicators(1, i) = 1;
            end
        end
    end
end
