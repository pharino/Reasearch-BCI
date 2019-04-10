function [P] = vec2matMap(X,D)

%%  
%   vec2matPosition: get the vector index and return the matrix index of
%   that index 
%       Input:
%           -   X: VectorPosition
%           -   D: MatrixDimension
%       Output
%           -   P: Index matrix of 

vec2matMap.DLength     = length(D);

for i = 1:vec2matMap.DLength
   vec2matMap.XMultiplier(i) = prod(D(1:i));
end


if X > prod(D)
    error('myApp:argChk', 'Value of input X must be less than product of D elements');
end

for i = 1:vec2matMap.DLength-1
    
    if i == 1
        vec2matMap.LevelPosition   = X;  
    else
        vec2matMap.LevelPosition   = vec2matMap.NextLevelPosition;
    end
    
    P(vec2matMap.DLength + 1 - i)  = ceil(vec2matMap.LevelPosition/vec2matMap.XMultiplier(vec2matMap.DLength- i));
    
    vec2matMap.NextLevelPosition   = vec2matMap.LevelPosition - (P(vec2matMap.DLength + 1 - i) - 1)*vec2matMap.XMultiplier(vec2matMap.DLength- i);
    
    if i == (vec2matMap.DLength-1)
        P(1) = vec2matMap.NextLevelPosition;
    end   
end
end

