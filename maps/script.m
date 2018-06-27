im = imread('factory.png');

starts = [25 20; 75 230; 225 235; 25 20; 175 20; 80 20];
targets = [200 145; 70 20; 50 120; 230 230; 150 180; 115 20];

c = xyCircle(4);

for i = 1:size(starts, 1)
   sc = c + starts(i, :);   
   tc = c + targets(i, :);
   
   for j = 1:size(sc, 1)
    im(sc(j, 1), sc(j, 2), 1) = 0;
    im(sc(j, 1), sc(j, 2), 2) = 0;
    im(sc(j, 1), sc(j, 2), 3) = 255;
    im(tc(j, 1), tc(j, 2), 1) = 0;
    im(tc(j, 1), tc(j, 2), 2) = 255;
    im(tc(j, 1), tc(j, 2), 3) = 0;
   end
end

image(im);
axis image;
