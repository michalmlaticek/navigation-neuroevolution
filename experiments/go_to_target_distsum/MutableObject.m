classdef MutableObject < BaseObject & handle    
    properties
        dist_sums
    end
    
    methods
        function obj = MutableObject(settings, pop_size)
            obj = obj@BaseObject(settings, pop_size);
            obj.mo_reset();
        end
        
        function [fits, best_fit, best_fit_distances] = fitness(obj)
            obj.fits = mean(obj.dist_sums, 1);
            
            [obj.best_fitness, best_fit_idx] = min(obj.fits, [], 2);
            obj.best_fit_distances = obj.distances(:, best_fit_idx);
            
            fits = obj.fits;
            best_fit = obj.best_fitness;
            best_fit_distances = obj.best_fit_distances;
        end
        
        function addDists(obj, distances)
           obj.dist_sums(obj.active_path_num, :) = obj.dist_sums(obj.active_path_num, :) + distances;
        end
        
        function mo_reset(obj)
            obj.reset();
            obj.dist_sums = zeros(obj.path_count, obj.pop_size);
        end
    end
end

