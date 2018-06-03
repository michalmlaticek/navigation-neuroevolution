function layers = initNets(layout, weights)
% init_nets - initializes a network(s) interpretation based on provided layout and weights
% 
% Description:
% Custom representation of a neural network, or rather
% networks, since multiple configuration of weights can be provided.
% It is essentially a list of cells containing two properties. 
% W (weights) and b (bias). W is a connection matrix between layers.
% So let's say that we'll have a layout [3 4 2], which would represent
% an input layer with 3 input nodes, a hidden layer with 4 input nodes
% and an output layer with 2 nodes.
% That means that the output will be a list of two cells.
% layer{1}:
%   W = matrix(4, 3, pop_size)
%   b = matrix(4, pop_size)
% layer{2}:
%   W = matrix(2, 4)
%   b = matrix(2, pop_size)
% 
% The idea is, that when evaluating, we'll be able to do a very simple
% matrix multiplication with the input (or output of prior layer) and addition of bias.
% 
% 
% Syntax:   net = init_nets(layout, weights)
% 
% layout - is a simple row vector (1xN) that contains desired node count on each layer
% weights - is a (MxN) matrix, where a column represents a vector of
% weights and biases to be decomposed into individual layer matrixes and
% number of columns (N) represent the population size. The number of
% connections and biases for the entire networ need to add up to (M)
% 
% Note: there is a function calculateWBCount, that provides this number
% based on the layout


    % It decomposes the weights vector in the same fassion as Neural
    % Network toolbox does. This is for validation puposes
    pop_size = size(weights, 2);
    layers = cell(1, size(layout, 2)- 1);
    s = 1;
    for l = 1: (size(layout, 2) -1)
        layers{l}.W = zeros(layout(l+1), layout(l), pop_size);
        e = s + layout(l+1) - 1;
        layers{l}.b = weights(s:e, :);
        for n = 1:layout(l)
            s = e + 1;
            e = s + layout(l+1)-1;
            layers{l}.W(:, n, :) = weights(s:e, :);
            s = e + 1;
        end
    end
end

