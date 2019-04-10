function [ s,pc,var] = pca1(data )
%   pca1:   Perform PCA using variance
%   Input:  
%       data    - MxN martix of input data
%           (M feature dimension, N observation)
%       s       - MxN matrix of projected data
%       pc      - each column is a principle component
%       var     - Mx1 matrix of variance

[M,N]       = size(data);

% Substract off the mean for each dimesion
mn          = mean(data,2);
data        = data - repmat(mn,1,N);

% Calculate the variance matrix
cov         = 1/(N-1)*data*data';

% Find the eigenvectors and eigenvalues
[pc var]    = eig(cov);
var         = abs(var);
% Extract diagonal of matrix as vector
v           = diag(var);

% Sort the variance in descreasing order
[junk rindices] = sort(v,'descend');
var         = v(rindices);
pc          = pc(:,rindices);

% Project the original data set
s           = pc'*data;
end

