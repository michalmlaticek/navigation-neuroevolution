function func_handle_performance()
    md = @()mapDistance([10, 10], [20, 20]); 
    run(md);
end

function run(md)
    s = cputime;
    for j = 1:2000000
        if ~isempty(md)
            
        end
    end
    e = cputime;
    fprintf('if statement = %f\n', e - s);

    s = cputime;
    direct_call();
    e = cputime;
    fprintf('dc_time = %f\n', e - s);
    
    s = cputime;
    inner_call();
    e = cputime;
    fprintf('md_in_time = %f\n', e - s);
    
    s = cputime;
    outer_call();
    e = cputime;
    fprintf('md_out_time = %f\n', e - s);
    
    s = cputime;
    handle_call();
    e = cputime;
    fprintf('hc_time = %f\n', e - s);
    
    function sum = direct_call()
        for i = 1:2000000
            sum = mapDistance([10, 10], [20, 20]);
        end
    end

    function sum = handle_call()
        for i = 1:2000000
            sum = md();
        end
    end
    
    function sum = inner_call()
       for i = 1:2000000
          sum = mapDistanceInner([10, 10], [20, 20]);
       end
    end
    
    function sum = outer_call()
       for i = 1:2000000
          sum = mapDistanceOuter([10, 10], [20, 20]);
       end
    end

    function dist = mapDistanceInner(source,target)
        %DISTANCE Summary of this function goes here
        %   Detailed explanation goes here
        dist = sqrt(sum((target - source).^2));
    end
end

function dist = mapDistanceOuter(source,target)
    %DISTANCE Summary of this function goes here
    %   Detailed explanation goes here
    dist = sqrt(sum((target - source).^2));
end
