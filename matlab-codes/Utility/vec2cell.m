function [y] = vec2cell(x,l)
%%  FUNCTION: [y] = vec2cell(x,l)
%   Spilt a vector x into cells y. Each cell y{i} have the same number of
%   element as l(i). 
%
%%  INOUTS:
%   -   x: a vector
%   -   l: a vector contains number of element of each cell to be
%   decomposed. Note: sum(l) = length(x).
%
%%  OUTPUT:
%   -   y : cells array
%   
%% COPY RIGHT:
%   Pharino Chum, 2013
y = cell(length(l),1);

lower = 1;
upper = l(1);

for i = 1:length(l)-1
    y{i} = x(lower:upper);
    % Update lower and upper 
    lower = lower + l(i); 
    upper = upper + l(i+1);
end
% Add the last segment
y{end} = x(lower:upper);


end

