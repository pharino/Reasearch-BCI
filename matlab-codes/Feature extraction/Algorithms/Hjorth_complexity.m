function [ y ] = Hjorth_complexity( x )
%   y = activity(x) : Calculate third degree Hjorth paramter of the input vector x. If x
%   is a matrix, column is time sample, row is variable
%   x : Input 
%   y : scalair value

% If x is a vector, caculating its variance
if isvector(x)
    y = sqrt(var(diff(x,2))*var(x))/var(diff(x));
else % x is a matrix
    y = sqrt(var(diff(x,2,2),0,2).*var(x,0,2))./var(diff(x,1,2),0,2);
end
end

