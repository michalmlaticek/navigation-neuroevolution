classdef MutableObject < handle    
    properties
        pop
        fits
        distances
        collisions
        gen_counter
        best_fit
        path_lens
        
        curr_path_idx
    end
    
    methods
        function obj = MutableObject()
            obj.pop = [];
            obj.fits = [];
            % because I know that the generation is going to be evaliation
            % 12 times (map1 = 4 paths, map2 = 6 paths, map3 = 2 paths)
            obj.distances = zeros(12, 150); % each map x path
            obj.collisions = zeros(12, 150); % each map x path
            obj.gen_counter = 1;
            obj.best_fit = 1000000;
            obj.path_lens = zeros(12, 150); % each map x path
            
            obj.curr_path_idx = 1;
        end
        
        function fits = fitness(obj)
           fits = mean(obj.distances + 10*obj.collisions + 0.001*obj.path_lens, 1);
           obj.fits = fits;
           
        end
        
        function obj = incGenCounter(obj)
            obj.gen_counter = obj.gen_counter + 1;
        end
        
        function nextPath(obj)
           if obj.curr_path_idx < 12
               obj.curr_path_idx = obj.curr_path_idx + 1;
           else
               obj.curr_path_idx = 1;
           end
        end
        
        function addPath(obj, step_sizes)
           obj.path_lens(obj.curr_path_idx, :) = ...
               obj.path_lens(obj.curr_path_idx, :) + step_sizes;
        end
        
        function [best_fit, dist, collis, path_lens] = bestFit(obj)
            [best_fit, best_idx] = min(obj.fits, [], 2);
            
            obj.best_fit = best_fit;
            
            dist = obj.distances(:, best_idx);
            collis = obj.collisions(:, best_idx);
            path_lens = obj.path_lens(:, best_idx);
        end
        
        function s = toStruct(obj)
            s = {};
            s.pop = obj.pop;
            s.fits = obj.fits;
            s.distances = obj.distances;
            s.collisions = obj.collisions;
            s.dist_sums = obj.path_lens;
        end
        
        function reset(obj)
            obj.pop = [];
            obj.fits = [];
            obj.distances = zeros(12, 150); % each map x path
            obj.collisions = zeros(12, 150); % each map x path
            obj.path_lens = zeros(12, 150); % each map x path
        end
    end
end

