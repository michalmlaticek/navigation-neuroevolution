function matIdxPerf()
    map = MapFactory.basic_map(250, 250, 10, 10, 2);
    radius = 5;
    body = get_body(radius);
    body = body + [40; 40];
    body = reshape(body, [length(body), 1, 2]);
    
    s = cputime;
    for i = 1:2000000
        for j = 1:size(body, 1)
           if map(body(j, 1, 1), body(j, 1, 2)) == 0
               
           end
        end
    end
    e = cputime;
    fprintf('xy reference duration: %f\n', e - s);
    
    idx = 100:180;
    idx = [idx; idx];
    s = cputime;
    for i = 1:1000000
          sum(map(idx), 2);
    end
    e = cputime;
    fprintf('logical reference: %f\n', e - s);
    
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



