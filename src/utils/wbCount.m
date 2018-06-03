function wb_count = wbCount(net_layout)
% wb_count - calculates the number of total weight and bias counts
% for a fully connected feedforward neural network based on the provided
% layout
    wb_count = 0;
    for i = 1 : length(net_layout) - 1
        wb_count = wb_count + ((net_layout(i) + 1)*net_layout(i+1));
    end % for i
end

