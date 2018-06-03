classdef MutableObject < handle    
    properties
        settings
        
        % counters
        map_count
        path_count
        pop_size
        active_generation_num
        active_map_num
        active_path_num
        
        % for fitness tracking
        distances
        collisions
        cummulative_angle_errors
        
        % for reporting
        pop
        fits
        
        
        best_fitness
        best_fit_distances
        best_fit_collisions
        best_fit_avg_angle_errors
    end
    
    methods
        function obj = MutableObject(settings, pop_size)
            obj.settings = settings;
            obj.map_count = length(settings.sim.maps);
            obj.path_count = obj.totalPathCount(settings.sim.maps);
            obj.pop_size = pop_size;
            obj.active_generation_num = 1;
            obj.active_path_num = 1;
            obj.active_map_num = 1;
            
            obj.distances = zeros(obj.path_count, pop_size); 
            obj.collisions = zeros(obj.path_count, pop_size);
            obj.cummulative_angle_errors = zeros(obj.path_count, pop_size);
                    
            obj.pop = [];
            obj.fits = [];
            
            obj.best_fitness = 1000000;
            obj.best_fit_distances = 1000000;
            obj.best_fit_collisions = 1000000;
            obj.best_fit_avg_angle_errors = 1000000;         
        end
        
        function [fits, best_fit, best_fit_distances, best_fit_collisions, ...
                best_fit_avg_angle_errors] = fitness(obj)
            avg_angle_errors = obj.cummulative_angle_errors / obj.settings.sim.step_count;
            sum_distances = sum(obj.distances, 1);
            sum_collisions = sum(obj.collisions, 1);
            sum_avg_angle_errors = sum(avg_angle_errors, 1);
            
            obj.fits = sum_distances + 10*sum_collisions + 0.1*sum_avg_angle_errors;
            
            [obj.best_fitness, best_fit_idx] = min(obj.fits, [], 2);
            obj.best_fit_distances = obj.distances(:, best_fit_idx);
            obj.best_fit_collisions = obj.collisions(:, best_fit_idx);
            obj.best_fit_avg_angle_errors = avg_angle_errors(:, best_fit_idx);
            
            fits = obj.fits;
            best_fit = obj.best_fitness;
            best_fit_distances = obj.best_fit_distances;
            best_fit_collisions = obj.best_fit_collisions;
            best_fit_avg_angle_errors = obj.best_fit_avg_angle_errors;
        end
        
        function num = incMapNum(obj)
           if obj.active_map_num < obj.map_count
              obj.active_map_num = obj.active_map_num + 1;
           else
               obj.active_map_num = 1;
           end
           num = obj.active_map_num;
        end
        
        function num = incPathNum(obj)
           if obj.active_path_num < obj.path_count
               obj.active_path_num = obj.active_path_num + 1;
           else
               obj.active_path_num = 1;
           end
           num = obj.active_path_num;
        end
        
        function num = incGenerationNum(obj)
            obj.active_generation_num = obj.active_generation_num + 1;
            num = obj.active_generation_num;
        end
        
        function cummulative_angle_errors = addAngleErrors(obj, angle_errors)
            obj.cummulative_angle_errors(obj.active_path_num, :) = ...
                obj.cummulative_angle_errors(obj.active_path_num, :) + abs(angle_errors);
            cummulative_angle_errors = obj.cummulative_angle_errors;
        end
        
        function obj = reset(obj)
           obj.distances = zeros(obj.path_count, obj.pop_size);
           obj.collisions = zeros(obj.path_count, obj.pop_size);
           obj.cummulative_angle_errors = zeros(obj.path_count, obj.pop_size);           
        end
        
        function s = toStruct(obj)
            s = {};
            s.pop = obj.pop;
            s.fits = obj.fits;
            s.distances = obj.distances;
            s.collisions = obj.collisions;
            s.cummulative_angle_errors = obj.cummulative_angle_errors;
        end
    end
    
    methods (Access = private)
        function path_count = totalPathCount(obj, maps)
           path_count = 0;
           for i = 1:length(maps)
               path_count = path_count + size(maps{i}.starts, 2);
           end
        end
    end
end

