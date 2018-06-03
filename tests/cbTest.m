function cbTest()
    x = MutableX(0);
    
    cbf = @(a)cb(a, x);
    
    cbf(1)
    cbf(1)
    
    function cb(a, x)
        x.x = x.x+a
    end
end

