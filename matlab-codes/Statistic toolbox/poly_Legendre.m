function [y] = poly_Legendre(n,x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%   [y] = poly_Legendre(n,x) : Evaluate the value of Legendre polynomial at
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
N = length(x);
switch n
    case 0
        y = ones(1,N);
    case 1
        y = x;
    case 2
        y = 1/2*(3*x.^2 -1);
    case 3
        y = 1/2*(5*x.^3 - 3*x);
    case 4
        y = 1/8*(35*x.^4 - 30*x.^2 + 3);
    case 5
        y = 1/8*(63*x.^5 - 70*x.^3 + 15*x);
    case 6
        y = 1/16*(231*x.^6 - 315*x.^4 + 105*x.^2 - 5);
end
end

