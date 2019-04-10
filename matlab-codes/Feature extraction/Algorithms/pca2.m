function [ signal,pc,var ] = pca2( data )
%   pca2:   Perform PCA using singular value decomposition
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

% Construct the matrix Y
Y   = data'/sqrt(N-1);

% SVD does it all
[ u, sigma, pc]     = svd(Y);

% Caculate the variances
sigma   = diag(sigma);
var     = sigma.*sigma;
% Project the original data
signal   = pc'*data;

end

