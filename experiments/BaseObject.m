classdef BaseObject < handle    
    properties
        settings
        
        map_count
        path_count
        pop_size
        active_generation_num
        active_map_num
        active_path_num
        
        % base properties
        pop
        fits
        distances
        collisions
        % add more if needed
         
        best_fitness
        best_fit_distances
        best_fit_collisions
        
        %for visualization
        prior_states
    end
    
    methods
        function obj = BaseObject(settings, pop_size)
            obj.settings = settings;
            obj.map_count = length(settings.sim.maps);
            obj.path_count = obj.totalPathCount(settings.sim.maps);
            obj.pop_size = pop_size;
            obj.active_generation_num = 1;
            obj.active_path_num = 1;
            obj.active_map_num = 1;
            
            obj.distances = zeros(obj.path_count, pop_size); 
            obj.collisions = zeros(obj.path_count, pop_size);
                    
            obj.pop = [];
            obj.fits = [];
            
            obj.best_fitness = 1000000;
            obj.best_fit_distances = 1000000;
            obj.best_fit_collisions = 1000000;
            
            obj.prior_states = {};
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
        
        function s = toStruct(obj)
            s = {};
            s.pop = obj.pop;
            s.fits = obj.fits;
            s.distances = obj.distances;
            s.collisions = obj.collisions;
        end
        
        function obj = reset(obj)
           obj.distances = zeros(obj.path_count, obj.pop_size);
           obj.collisions = zeros(obj.path_count, obj.pop_size);
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

