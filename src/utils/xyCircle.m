function c = xyCircle(radius)
    c = [];
    for i = -radius:radius
        for j = -radius:radius
            if i^2+j^2 <= radius^2 % is inside circle?
                c = [c; [i j]];
            end
        end % for - j
    end % for - i
end