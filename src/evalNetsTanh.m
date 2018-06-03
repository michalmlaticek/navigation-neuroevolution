function net_outs = evalNetsTanh(nets,pop_ins)
% eval_nets - evaluates custom network representations provided input.
% 
% Description:
% It simply loops through each layer and each population member and performs
%   tanh(W(ij)*I(j) + b(j))
% where:
%   W(ij) is the connection / weights matrix (n, m, pop_size) between layer i and j
%   I(j) is the input matrix (m, pop_size) for layer j (is also the output of layer i if not input layer)
%   b(j) is the bias matrix (m, pop_size) for layer j
% 
% Syntax: net_outs = eval_nets(nets, pop_ins)
% 
% nets - is the list of custom network definitions constructed by init_net function
% pop_ins - is a matrix (m, pop_size) with the values for the input layer
% (number of columns represents the population size)

    pop_size = size(pop_ins, 2);
    outs = pop_ins;
    for l = 1:(size(nets, 2)-1)
        ins = outs;
        outs = zeros(size(nets{l}.W, 1), pop_size);
        for p = 1:pop_size
            outs(:, p) = tanh((nets{l}.W(:, :, p) * ins(:, p)) + nets{l}.b(:, p));
        end        
    end
    
    net_outs = zeros(2, pop_size);
    for p = 1:pop_size
        net_outs(:, p) = tanh((nets{end}.W(:, :, p) * outs(:, p)) + nets{end}.b(:, p));
    end        
end



