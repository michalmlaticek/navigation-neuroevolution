function grid = gridFromImg(img_path)
    grid = imread(img_path);
    grid = grid(:,:, 1);
    grid = grid / 255;
end