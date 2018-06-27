classdef MutableObject < BaseObject & handle    
    properties
        cummulative_angle_errors
        best_fit_angle_errors
    end
    
    methods
        function obj = MutableObject(settings, pop_size)
            obj = obj@BaseObject(settings, pop_size);
            obj.moReset();
        end
        
        function [fits, best_fit, best_fit_distances, best_fit_collisions, ...
                best_fit_angle_errors] = fitness(obj)
            
            path_fits = obj.distances + 40*obj.collisions + 0.01*abs(obj.cummulative_angle_errors);
            
            obj.fits = max(path_fits, [], 1);
            
            [obj.best_fitness, best_fit_idx] = min(obj.fits, [], 2);
            obj.best_fit_distances = obj.distances(:, best_fit_idx);
            obj.best_fit_collisions = obj.collisions(:, best_fit_idx);
            obj.best_fit_angle_errors = obj.cummulative_angle_errors(:, best_fit_idx);
            
            fits = obj.fits;
            best_fit = obj.best_fitness;
            obj.best_fitness = best_fit;
            best_fit_distances = obj.best_fit_distances;
            best_fit_collisions = obj.best_fit_collisions;
            best_fit_angle_errors = obj.best_fit_angle_errors;
        end
        
        function addAngleErrors(obj, angle_errors)
           obj.cummulative_angle_errors(obj.active_path_num, :) = ...
               obj.cummulative_angle_errors(obj.active_path_num, :) + abs(angle_errors);
        end
        
        function moReset(obj)
           obj.reset();
           obj.cummulative_angle_errors = zeros(obj.path_count, obj.pop_size);
        end
        
        function s = moToStruct(obj)
           s = obj.toStruct();
           s.cummulative_angle_errors = obj.cummulative_angle_errors;
        end
    end
end

