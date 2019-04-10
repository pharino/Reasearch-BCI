function [y, f] = FindUnique(x)
%   Find unique value in x without arrage order

y   = [];
f   = [];

for i = 1:length(x)
    if isempty(find(y == x(i)))
        y(length(y) + 1 )   = x(i);
        f(length(y)) = 1;
    else
        f(find(y == x(i))) = f(find(y == x(i))) + 1;
    end
end
end

