function [r] = randi_unique(max,m )
%%  FUNCTION:  [r] = randi_unique(max,m)
%   DESCRIPTION: 
%   -   Create a random integer vector of length m with maximum value of max 

r = randi(max,m,1);

while length(unique(r)) < m
    r = unique(r);
    nadd = m - length(r);
    l = randi(max,nadd, 1);
    
    for i = 1:nadd
        if sum(r == l(i)) == 0
            r(end+1) = l(i);
        end
    end
    
end
end

