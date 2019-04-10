function [ signal_matrix ] = spf_car(signal_matrix)
%%  Apply commmom average to the input matrix
%   Find the smallest
matrix_size = size(signal_matrix);
k           = min(matrix_size);
index_k     = find(min(matrix_size));
%   Mean value, force row vector
mean_vector(1,:) = mean(signal_matrix,index_k);
%   Substract matrix with mean value
if index_k >= 2
    signal_matrix   = signal_matrix';
end
%   progressbar
for i = 1:k
    signal_matrix(i,:)   =  signal_matrix(i,:) - mean_vector;
end
end

