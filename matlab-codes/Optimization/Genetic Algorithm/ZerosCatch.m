function [Y] = ZerosCatch(X,varargin)
%%  Description
%   Random generation a chromosome if the chomosom is totally zero.

if sum(abs(X)) == 0
    
    if strcmp(varargin{find(strcmp(varargin,'Type'))+1},'Binary')
        while sum(abs(X)) ~= 0
            X = round(rand(1,length(X)));
        end
    elseif strcmp(varargin{find(strcmp(varargin,'Type'))+1},'Custom')
        
    end
    Y = X;
else
    Y = X;
end
end

