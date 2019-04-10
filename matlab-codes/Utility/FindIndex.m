function [ Z] = FindIndex(X,Y)
%%  FUNCTION
%   [Z] = FindIndex(X,Y): find required electrode name in cell 
% array X from the cell array Y;
%   INPUT
%   -   X : cell array of electode names  
%   -   Y : Cell array of electrode and the Eulidian coordinate
%   OUTPUT
%   -   Z : index of selected electrode
%%  -----------------------------------------------------------------------
FindChannel.XLength     = length(X);
FindChannel.YLength     = length(Y);

for i = 1:FindChannel.XLength
    for k = 1:FindChannel.YLength
        if strcmp(X{i},Y{k,1})
            Z(i) = k;
            break;
        end
    end
end

end

