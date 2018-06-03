function test_myNet_performance()
    % Add utils to path

    wb_count = wbCount([9 5 2]);
    wbs = zeros(wb_count, 150);
    
    init_durations = zeros(100, 150);
    for i = 1:100
        tic
        nets = initNets([9 5 2], wbs);
        init_durations(i) = toc;
    end
    
    eval_durations = zeros(100, 1);
    input = zeros(9, 150);
    for i = 1:100
        tic
        y = evalNetsTanh(nets, input);
        eval_durations(i) = toc;   
    end
    
    subplot(2, 1, 1);
    hold on
    plot(init_durations, 'b');
    xlabel('Test run number');
    ylabel('Duration to init 150 nets [s]');
    hold off
    subplot(2, 1, 2);
    hold on
    plot(eval_durations, 'b');
    xlabel('Test run number');
    ylabel('Duration to evaluate 150 nets [s]')
    hold off
end