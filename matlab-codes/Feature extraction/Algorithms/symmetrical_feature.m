function [y] = symmetrical_feature(x,l)
%% FUNCTION: [y] = symmetrical_feature(x,l)
%   Description: Using index l calculate symmetrical feature y from vector
%   input x. 

%   INPUT: 
%   -   x: a vector input of input signal. If x is matrix, then its column
%   is time sample.
%   -   l: index of symmetrical axis. l must be less than length of x
%   OUTPUT: 
%   -   y: symmetrical feature

%% CODE:
% Get dimension of x
[n,m]   = size(x);

% Calculating sample power of x
x = x.^2; 
% Sample mean
x_bar = mean(x,2);

% Symmetrical feature
y = (x_bar.*m)./(sum(x(:,1:l),2));

end

