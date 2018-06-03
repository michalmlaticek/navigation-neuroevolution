function is_c = isCollision(body, map)
    is_c = false;
    for i = 1:size(body, 1)
       if body(i, 1, 1) > size(map, 1) || ...
           body(i, 1, 2) > size(map, 2) || ...
           body(i, 1, 1) < 1 || ...
           body(i, 1, 2) < 1 || ...
           map(body(i, 1, 1), body(i, 1, 2)) ~= 1 % 1 == free
            is_c = true;
            break;
       end
    end
end