function test_nnt_performance()
    % Add utils to path

    net = initNet([9 5 2]);
    wb_count = wbCount([9 5 2]);
    wbs = zeros(wb_count, 1);
    
    init_durations = zeros(100, 1);
    for i = 1:100
        nets = cell(150, 1);
        tic
        for n = 1:150
            nets{n} = setwb(net, wbs(:, 1));
        end
        init_durations(i) = toc;
    end
    
    eval_durations = zeros(100, 1);
    input = zeros(9, 1);
    for i = 1:100
        tic
        for n = 1:150
            y = nets{i}(input);
        end
        eval_durations(i) = toc;   
    end
    
    subplot(2, 1, 1);
    hold on
    plot(init_durations , 'b');
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


function myNet = initNet(netLayout)
    inputCount = netLayout(1);
    hiddenLayersConfig = netLayout(2:end);
    
    layerCount = length(hiddenLayersConfig);
    
    inputConnectMatrix = ones(1, inputCount);
    for i = 2:layerCount
        inputConnectMatrix = [inputConnectMatrix; zeros(1, inputCount)];
    end % end for i
    
    layerConnectMatrix = zeros(layerCount);  
    for j = 2:layerCount
        layerConnectMatrix(j, (j-1)) = 1;
    end %for j
    
    outputConnectMatrix = zeros(1, layerCount);
    outputConnectMatrix(layerCount) = 1;
    
    myNet = network(inputCount, layerCount, ones(layerCount, 1), inputConnectMatrix,layerConnectMatrix, outputConnectMatrix);
    myNet.inputs{:}.size = 1; % set len of input node matrix
    
    for k = 1:layerCount
        myNet.layers{k}.size = hiddenLayersConfig(k); % set num of nodes of a layer
        %myNet.layers{k}.transferFcn = 'logsig';
        myNet.layers{k}.transferFcn = 'tansig';
    end % for k
    myNet.layers{layerCount}.transferFcn = 'logsig';
end
