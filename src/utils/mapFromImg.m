function m = mapFromImg(img_path, starts, targets)
    m = {};
    m.img_path = img_path;
    m.grid = gridFromImg(img_path); 
    m.max_distance = eucDist([1; 1], size(m.grid)', 1);
    m.starts = reshape(starts, [1, size(starts, 1), 2]);
    m.targets = reshape(targets, [1, size(targets, 1), 2]);
end
