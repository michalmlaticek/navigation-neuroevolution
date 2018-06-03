classdef MutableObject < handle    
    properties
        pop
        fits
        distances
        collisions
        gen_counter
        best_fit
        prior_states
    end
    
    methods
        function obj = MutableObject()
            obj.pop = [];
            obj.fits = [];
            % because I know that the generation is going to be evaliation
            % 10 times (map1 = 4 paths, map2 = 6 paths)
            obj.distances = zeros(1, 150); 
            obj.collisions = zeros(1, 150);
            obj.gen_counter = 1;
            obj.best_fit = 1000000;
            
            obj.prior_states = {};
        end
        
        function obj = incGenCounter(obj)
            obj.gen_counter = obj.gen_counter + 1;
        end
        
        function [best_fit, dist, collis] = bestFit(obj)
            [best_fit, best_idx] = min(obj.fits, [], 2);
            
            obj.best_fit = best_fit;
            
            dist = obj.distances(:, best_idx);
            collis = obj.collisions(:, best_idx);
        end
        
        function s = toStruct(obj)
            s = {};
            s.pop = obj.pop;
            s.fits = obj.fits;
            s.distances = obj.distances;
            s.collisions = obj.collisions;
        end
    end
end

