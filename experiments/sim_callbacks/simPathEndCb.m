function simPathEndCb(path_state, my_state, log_folder, gif_name)
    saveas(gcf, sprintf('%s/%s_map_%d_path_%d_viz.jpeg', ...
        log_folder, gif_name, my_state.active_map_num, my_state.active_path_num));
    
    distances = my_state.prior_states{1}.target_distances;
    plot(distances, 'b', 'LineWidth',2);
    xlabel('Step');
    ylabel('Distance');
    xlim([0, length(my_state.prior_states)]);
    ylim([0, 400]);
    set(gcf, 'color', 'w');
    frame = getframe(gcf); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    imwrite(imind,cm,sprintf('%s/%s_map_%d_path_%d_dist_chart.gif', ... 
        log_folder, gif_name, my_state.active_map_num, my_state.active_path_num), ...
        'gif', 'DelayTime',0.0003, 'Loopcount',inf);
    for i = 1:length(my_state.prior_states)
        distances = [distances; my_state.prior_states{i}.target_distances];
        plot(distances, 'b', 'LineWidth',2);
        xlabel('Step');
        ylabel('Distance');
        xlim([0, length(my_state.prior_states)]);
        ylim([0, 400]);
        frame = getframe(gcf); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        imwrite(imind,cm,sprintf('%s/%s_map_%d_path_%d_dist_chart.gif', ...
            log_folder, gif_name, my_state.active_map_num, my_state.active_path_num),...
            'gif','DelayTime',0.0003, 'WriteMode','append'); 
    end
    
    saveas(gcf, sprintf('%s/map_%d_path_%d_dist.jpeg', ...
        log_folder, my_state.active_map_num, my_state.active_path_num));
    
    my_state.prior_states = {};
    my_state.incPathNum();
end