function [im, grid] = drawMap(state, map_id, path_id, prior_states, refresh, gif_name)
% drawMap - provides the visual representation of the simulation
%
% state - the simulation state (provided internaly by simPath function)
% map_id - numeric representation of the map currently simulated (provided internaly by simMultiPath func)
% path_id - numeric representation of the path currently simulated (provided internaly by simMultiPath func)
% prio_states - list of prior states (the same structure as state). 
%               It's used for drawin the line represeting the path taken. 
%               (BaseObject contains a placeholder property for this, but it needs to be saved using one of the callback functions)
%               Optional: User [] if you want to skip this param
% refresh - represents the frame rate at which the map is redrawn
% gif_name - the name prefix to save the simulation as gif. 
%           (map_id and path_id will be added for distinguishing)
%           Optional: Use [] is you want to skip this param.
    grid = state.map.grid;
    bodies = state.bodies;
    sensor_lines = state.sensor_lines;
    start = state.start;
    target = state.target;
    collis_idx = state.collision_idx;
    
    for r = 1:size(bodies, 2) % for each robot
        if exist('collis_idx', 'var') && ~isempty(collis_idx) && collis_idx(r) > 0
            grid = drawXYs(grid, bodies(:, r, :), 4);
        else
            grid = drawXYs(grid, bodies(:, r, :), 6);
        end
        grid = drawXYs(grid, sensor_lines(:, r, :), 6);
        if exist('prior_states', 'var') && ~isempty(prior_states)
            grid = drawPath(grid, state.positions(1, r, :), prior_states, r, 5);
        end
    end
    
    grid = drawPoint(grid, start, 3, 2);
    grid = drawPoint(grid, target, 3, 3);
    im = image(grid, 'CDataMapping', 'direct');
    cmap = create_cmap(size(bodies, 2));
    colormap(cmap);
    axis image;
    pause(refresh);
    
    if exist('gif_name','var') && ~isempty(gif_name)
        if exist('map_id', 'var') && ~isempty(map_id)
            gif_name = sprintf('%s_map_%d', gif_name, map_id);
        end
        if exist('path_id', 'var') && ~isempty(path_id)
            gif_name = sprintf('%s_path_%d', gif_name, path_id);
        end
        if exist(sprintf('%s.gif', gif_name), 'file') == 2
            imwrite(grid,cmap,sprintf('%s.gif', gif_name),'gif','DelayTime',0.005, 'WriteMode','append'); 
        else
            imwrite(grid,cmap,sprintf('%s.gif', gif_name),'gif', 'DelayTime',0.005,  'Loopcount',inf);
        end
    end
end

function grid = drawXYs(grid, xys, c_idx)
    for i = 1:size(xys, 1)
        if xys(i, 1, 1) > 0 && ...
                xys(i, 1, 2) > 0 && ...
                xys(i, 1, 1) <= size(grid, 1) && ...
                xys(i, 1, 2) <= size(grid, 2)
            grid(xys(i, 1, 1), xys(i, 1, 2)) = c_idx;            
        end            
    end
end

function grid = drawPoint(grid, point, radius, c_idx)
    c = xyCircle(radius);
    c = reshape(c, size(c, 1), 1, size(c, 2));
    c = c + point;
    grid = drawXYs(grid, c, c_idx);
end

function grid = drawPath(grid, curr_pos, prior_pos, r, c_idx)
    last = round(reshape(curr_pos, 1, 2));
    pos1 = round(reshape(prior_pos{1}.positions(1, r, :), 1, 2));
    conn = [];
    for s = 2:length(prior_pos)
        pos2 = round(reshape(prior_pos{s}.positions(1, r, :), 1, 2));
        conn =[conn; bresenham(pos1, pos2)'];
        pos1 = pos2;
    end
    conn = [conn; bresenham(pos1, last)'];
    conn3d = reshape(conn,size(conn, 1), 1, 2);
    grid = drawXYs(grid, conn3d, c_idx);
end

function cmap = create_cmap(robot_count)
    cmap = [0 0 0; ... % obstacle color
            1 1 1; ... % free color
            0 0 1; ... % start color
            0 1 0; ... % target
            1 0 0;  ... % collision
            1 69/255 0; ... % path
            152/255 175/255 199/255
           ];
       
     for i = 1: robot_count
        r_color = [i i i] / 255;
        cmap = [cmap; r_color];
     end
end