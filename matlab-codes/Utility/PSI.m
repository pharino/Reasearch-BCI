function Y = PSI(X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION: y= PSI(x)
% Function calculating Pseudo inverse of matrix 
% INPUT
%   - X : m x n matrix
% OUTPUT
%   - Y : n x m matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Calculating Pseudo inverse 
Y = ((X'*X)^-1)*X';

end

