function [y] = feature_diagonal(x1,x2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  FUNCTION
%   [y] = feature_diagonal(x1,x1): 
%   Extract the diagonal element of the covariance matric of x1 and x2

%   INPUT ARGUMENT
%   x1  : M by N matrix of first signal
%   x2  : M by N matrix of second signal

%   OUTPUT ARGUMENT
%   y   : M vector of the diagonal element of the covariance matrix between
%   x1 and x2. 
%   y = log(diag(x1*x2'))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y = x1*x2';
y = diag(y);
y = log(y);

end

