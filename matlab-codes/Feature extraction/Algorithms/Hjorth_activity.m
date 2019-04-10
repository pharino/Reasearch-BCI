function [ y ] = Hjorth_activity( x )
%   y = activity(x) : Calculate first Hjorth paramter of the input vector x. If x
%   is a matrix, column is time sample, row is variable
%   x : Input 
%   y : scalair value 

% If x is a vector, caculating its variance
if isvector(x)
    y = var(x);
else % x is a matrix
   y = var(x,0,2);
    
end
end

