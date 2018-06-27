classdef MutableObject < BaseObject & handle    
    properties
        dist_sums
    end
    
    methods
        function obj = MutableObject(settings, pop_size)
            obj = obj@BaseObject(settings, pop_size);
            obj.mo_reset();
        end
        
        function [mean_fits, best_fit, best_fit_dists, best_fit_collis] = fitness(obj)
           path_fits = obj.dist_sums + 1000*obj.collisions;
           
           mean_fits = mean(path_fits, 1);
           obj.fits = mean_fits;
           
           
           [best_fit, best_fit_idx] = min(mean_fits, [], 2);
           obj.best_fitness = best_fit;
           best_fit_dists = obj.distances(:, best_fit_idx);
           best_fit_collis = obj.collisions(:, best_fit_idx);
        end
        
        
        function addStepDists(obj, dists)
           obj.dist_sums(obj.active_path_num, :) = ...
               obj.dist_sums(obj.active_path_num, :) + dists;
        end
        
        function mo_reset(obj)
            obj.reset();
            obj.dist_sums = zeros(obj.path_count, obj.pop_size); % each map x path
        end
    end
end

