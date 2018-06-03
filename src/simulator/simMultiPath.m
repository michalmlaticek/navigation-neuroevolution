function states = simMultiPath(...
    nets, ...
    sim_settings, ...
    controllCb, ...
    stepEndCb, ...
    pathEndCb, ...
    mapEndCb, ...
    drawCb)

    global logger
    
    maps = sim_settings.maps;
    map_count = length(maps);
    step_count = sim_settings.step_count;
    robot = sim_settings.r;
    
    map_states = cell(map_count, 1);
    for m = 1:map_count
        map = maps{m};
        if ~isempty(logger)
            logger.debug(sprintf("Map: %d - '%s'", m, map.img_path));
        end
        path_count = size(map.starts, 2);
        path_states = cell(path_count, 1);
        for p = 1:path_count
            start = map.starts(1, p, :);
            target = map.targets(1, p, :);
            if ~isempty(logger)
                logger.debug(sprintf("Map: %d - Path: %d - Start = [%d %d], Target = [%d %d]", ...
                m, p, start, target));
            end
            drawCbCb = [];
            if ~isempty(drawCb)
                drawCbCb = @(state)drawCb(state, m, p);
            end
            state = simPath(...
                nets, ...
                map, ...
                start, ...
                target, ...
                robot, ...                
                step_count, ...
                controllCb, ...
                stepEndCb, ...
                drawCbCb);
            path_states{p} = state;
            
            if ~isempty(pathEndCb)
                pathEndCb(state);
            end
        end
        map_states{m}.paths = path_states;
        
        if ~isempty(mapEndCb)
            mapEndCb(map_states{m})
        end
    end
    states = {};
    states.maps = map_states;
end

