function [ Y ] = ga_FindCrazy(R,Z)
%%  Description
%   [ Y ] = ga_FindCrazy(R,Z) : return the index of crazy individual of the
%   population
%   Input:  
%       -   R: [0 1]rate of craziness of the population
%       -   Z: integer size of population
%   Output:
%       -   Y: index of crazy individual

%%  -----------------------------------------------------------------------
%   Code
ga_FindCrazy.Number = round(R*Z);
ga_FindCrazy.Index  = round(randi([1,Z],[ga_FindCrazy.Number,1]));

while length(ga_FindCrazy.Index) < ga_FindCrazy.Number
    ga_FindCrazy.Index  = round(randi([1,Z],[ga_FindCrazy.Number,1]));
end

Y = ga_FindCrazy.Index;

end

