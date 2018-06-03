function testXyCircle()
    im = ones(250, 250);
    body = xyCircle(10) + [100 100];
    for i = 1:size(body, 1)
       im(body(i, 1), body(i, 2)) = 0; 
    end
    
    img = im;
    img(:, :, 2) = im;
    img(:, :, 3) = im;
    
    image(img);
    axis image;
end

