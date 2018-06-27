classdef MutableObject < BaseObject & handle    
    properties

    end
    
    methods
        function obj = MutableObject(settings, pop_size)
            obj = obj@BaseObject(settings, pop_size);
        end
        
        function [fits, best_fit, best_fit_distances] = fitness(obj)
            
            path_fits = obj.distances;
            
            obj.fits = max(path_fits, [], 1);
            
            [obj.best_fitness, best_fit_idx] = min(obj.fits, [], 2);
            obj.best_fit_distances = obj.distances(:, best_fit_idx);
            
            fits = obj.fits;
            best_fit = obj.best_fitness;
            best_fit_distances = obj.best_fit_distances;
        end
    end
end

