classdef MutableObject < handle    
    properties
        pop
        fits
        distances
        collisions
        gen_counter
        best_fit
        dist_sums
        
        curr_path_idx
    end
    
    methods
        function obj = MutableObject()
            obj.pop = [];
            obj.fits = [];
            % because I know that the generation is going to be evaliation
            % 10 times (map1 = 4 paths, map2 = 6 paths)
            obj.distances = zeros(1, 150); % each map x path
            obj.collisions = zeros(1, 150); % each map x path
            obj.gen_counter = 1;
            obj.best_fit = 1000000;
            obj.dist_sums = zeros(1, 150); % each map x path
            
            obj.curr_path_idx = 1;
        end
        
        function obj = incGenCounter(obj)
            obj.gen_counter = obj.gen_counter + 1;
        end
        
        function nextPath(obj)
           
        end
        
        function addStepDists(obj, dists)
           obj.dist_sums(obj.curr_path_idx, :) = ...
               obj.dist_sums(obj.curr_path_idx, :) + dists;
        end
        
        function [best_fit, dist, collis, sums] = bestFit(obj)
            [best_fit, best_idx] = min(obj.fits, [], 2);
            
            obj.best_fit = best_fit;
            
            dist = obj.distances(:, best_idx);
            collis = obj.collisions(:, best_idx);
            sums = obj.dist_sums(:, best_idx);
        end
        
        function s = toStruct(obj)
            s = {};
            s.pop = obj.pop;
            s.fits = obj.fits;
            s.distances = obj.distances;
            s.collisions = obj.collisions;
            s.dist_sums = obj.dist_sums;
        end
        
        function reset(obj)
            obj.pop = [];
            obj.fits = [];
            obj.distances = zeros(1, 150); % each map x path
            obj.collisions = zeros(1, 150); % each map x path
            obj.dist_sums = zeros(1, 150); % each map x path
        end
    end
end

