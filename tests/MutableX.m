classdef MutableX < handle
    %MUTABLEX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x
    end
    
    methods
        function obj = MutableX(x)
            obj.x = x;
        end
    end
end

