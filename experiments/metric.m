function metric(log_folder, start_gen, end_gen, to_csv)
    % metric - function for generating common charts. It aggregates the
    % output data saved during evolution. It can happen that the data is 
    % not saved for every generation, so it actually checks, if the file 
    % actually exist. If it doesn't, it moves and checks for the next file
    % untilt the end_gen is reached.
    %
    % !!! IMPORTANT: It uses mean to group together data for multiple paths
    % 
    % usage:
    %   log_folder - folder where the data of the evolution is storred
    %   start_gen - from what generation you want to start
    %   end_gen - end generation
    %   to_csv  - (optional) true/false - saves aggregated data to csv
    %   files
    
    if start_gen == 1
        start_gen = 2;
    end

    fits = [];
    metric_labels = [];
    metric_data = [];
    pop_diversity = [];
    gen_numbers = [];


    % load data
    for i = start_gen:end_gen
        data_file = sprintf('%s/out-data-gen-%d.mat', log_folder, i);
        if exist(data_file, 'file') == 2
            gen_numbers = [gen_numbers; i];
            data = load(data_file);
            metric_labels = fieldnames(data);
            metric_labels(find(strcmpi(metric_labels, 'POP')), :) = []; % del 'Pop' label

            pop_diversity = [pop_diversity; size(unique(data.pop', 'rows'), 1)];

            fit_label_idx = find(strcmpi(metric_labels, 'FIT'));
            if isempty(fit_label_idx)
                fit_label_idx = find(strcmpi(metric_labels, 'FITS'));
            end        
            fits = [fits; data.(metric_labels{fit_label_idx})];
            metric_labels(fit_label_idx, :) = [];

            for ml = 1:length(metric_labels)
                metric_data(length(gen_numbers), :, ml) = mean(data.(metric_labels{ml}), 1);
            end
        end
    end
    
    if exist('to_csv', 'var') && to_csv
        writetable(array2table(fits), 'fits.csv');
        for label = 1:length(metric_labels)
           writetable(array2table(metric_data(:, :, label)), sprintf('%s.csv', metric_labels{label})); 
        end   
    end

    [best_fit, best_fit_idx] = min(fits, [], 2);

    % prepare interesting values
    gen_count = size(fits, 1);
    metric_count = length(metric_labels);
    best_fit_metric = zeros(gen_count, metric_count);
    for i = 1:gen_count
        best_fit_metric(i, :) = metric_data(i, best_fit_idx(i), :);
    end
    
    orange = [0.8500, 0.3250, 0.0980];
    
    f1 = figure('Name', sprintf('%s - Best fitness', extract_fit_title()), 'NumberTitle', 'off');
    subplot(metric_count+1, 1, 1);
    hold on;
    lines = plot(gen_numbers, best_fit, 'o','MarkerEdge', orange, 'MarkerFaceColor', orange, 'MarkerSize',4); labels = "Fitness";
    xlim([0 inf]);
    ylim([0 inf]);
    title("Best fitness");
    xlabel("Generation");
    legend(lines, labels);
    hold off
    
    for i = 1:metric_count
        subplot(metric_count + 1, 1, i + 1);
        hold on;
        lines = plot(gen_numbers, best_fit_metric(:,i), 'o', 'MarkerEdge', orange, 'MarkerFaceColor', orange, 'MarkerSize',4); labels = replace(metric_labels{i}, '_', ' ');
        xlim([0 inf]);
        ylim([0 inf]);
        title(sprintf("Best fit - %s", labels));
        xlabel("Generation");
        legend(lines, labels);
        hold off
    end
    
    f2 = figure('Name', sprintf('%s - metric values (min, max, mean)', extract_fit_title()), 'NumberTitle', 'off');
    for mc = 1:metric_count
        subplot(metric_count, 1, mc);
        hold on;
        line1 = plot(gen_numbers, mean(metric_data(:,:,mc), 2), 'og', 'MarkerSize',2); label1 = "mean";
        line2 = plot(gen_numbers, max(metric_data(:,:,mc), [], 2), 'ob', 'MarkerSize', 2); label2 = "max";
        line3 = plot(gen_numbers, min(metric_data(:,:,mc) , [], 2), 'or', 'MarkerSize',2); label3 = "min";
        xlim([0 inf]);
        ylim([0 inf]);
        title(metric_labels{mc});
        xlabel("Generation");
        legend([line1 line2 line3], [label1 label2 label3]);
        hold off
    end
    
    
    % plot population diversity in each generation
    f3 = figure('Name', sprintf('%s - Population diversity', extract_fit_title()), 'NumberTitle', 'off');
    hold on
    line = plot(gen_numbers, pop_diversity, 'o', 'MarkerSize', 2); label = "Unique Genom Count";
    xlim([0 inf]);
    ylim([0 inf]);
    legend(line, label);
    hold off
    
end

function cd_here()
    file_path = mfilename('fullpath');
    idx = strfind(file_path, '\');
    folder_path = file_path(1:idx(end));
    cd(folder_path);
end

function title = extract_fit_title()
    str = pwd;
    idx = strfind(str,'\');
    title = str(idx(end-1)+1:end);
end
