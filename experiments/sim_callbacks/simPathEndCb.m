function simPathEndCb(path_state, my_state, log_folder)
    saveas(gcf, sprintf('%s/map_%d_path_%d_viz.jpeg', ...
        log_folder, my_state.active_map_num, my_state.active_path_num));
    
    distances = [];
    for i = 1:length(my_state.prior_states)
        distances = [distances; my_state.prior_states{i}.target_distances];
    end

    plot(distances, 'b', 'LineWidth',2);
    xlabel('Step');
    ylabel('Distance');
    
    saveas(gcf, sprintf('%s/map_%d_path_%d_dist.jpeg', ...
        log_folder, my_state.active_map_num, my_state.active_path_num));
    
    my_state.prior_states = {};
    my_state.incPathNum();
end