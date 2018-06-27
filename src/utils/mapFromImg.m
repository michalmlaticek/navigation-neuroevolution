function m = mapFromImg(img_path, starts, targets)
% mapFromImg - instantiate a map structure based on image
%
% img_path - is the path to the image representing the map
% starts - array of start points (shape: (2, M), where M is the number of start points) 
% targets - array of target points (shape: (2, M), where M is the number of target points)
%
% Returns a struct with following properties ...
    m = {};
    m.img_path = img_path;
    m.grid = gridFromImg(img_path); 
    m.max_distance = eucDist([1; 1], size(m.grid)', 1);
    m.starts = reshape(starts, [1, size(starts, 1), 2]); % reshape to 3d as this is what the simulation expects
    m.targets = reshape(targets, [1, size(targets, 1), 2]); % reshape to 3d ...
end
