function [y] = Polynomial_Legendre(n,x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%   [y] = Polynomial_Legendre(n,x) : Evaluate the value of Legendre polynomial at
%   point x.
%
% INPUT ARGUMENT     
%   n   : degre of polynomial
%   x   : input scalair or vector range [-1 1]
%   
% OUTPUT ARGUMENT
%   y   : value of the polynomial at point x.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  CODE
N       = length(x);
y(1,:)  = ones(1,N);
y(2,:)  = x;

for i = 1:n-1
    y(i+2,:) = (2*i+1)/(i+1).*x.*y(i+1,:) - i/(i+1)*y(i,:); 
end
end

