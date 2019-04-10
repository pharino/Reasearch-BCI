function [y] = MSE(type,x,t)
%   MSE: mean square error rate
%   x : vector of prediction output
%   t : vector of target output
%   y : is mean square error rate [0 1
%   x and t must have the same size

if length(x) ~= length(t)
    error('myApp:argChk', 'length of prediction and target vector must be the same');
elseif ~isvector(x) || ~isvector(t)
    error('myApp:argChk', 'Target and prediction must be vector');
end
%   Binary error
if strcmp(type,'Binary')
    y = length(find(x ~= t))/length(t);

%   Real value error   
elseif strcmp(type,'Real')
    %   Square error
    MSE.ErrorSquare = (t-x).^2;    
    %   Mean square error output
    y   =  mean(MSE.ErrorSquare);    
end
end

