function [y] = Linear_Model_Parallel( x,w,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%   [y] = Linear_Model( x,w,b,varargin)
%
% INPUT ARGUMENT
%   x:  M cell wich each cell is KxN-matrix of input. K is number of
% variable, N is number of observation
%   w:  K+1 dimension vector if linear model with bias
%   b:  M dimension vector bias values
%   Fnc:Function tranformation of linear model. String command
%
% OUTPUT ARGUMENT
%   y: N-dimension vector of output.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Rearrage input matrix
for i = 1:length(x)
    %   Input matrix X
    [Linear_Model.K{i},Linear_Model.N{i}] = size(x{i});
    Linear_Model.X{i} = zeros(Linear_Model.K{i}+1, Linear_Model.N{i});
    Linear_Model.X{i}(1,:) = 1;
    Linear_Model.X{i}(2:Linear_Model.K{i}+1,:) = x{i};
    
    %   Including bias into W
    Linear_Model.W{i} = w{i}(:);
    
    %   Linear transformation
    Linear_Model.U{i} = Linear_Model.W{i}'*Linear_Model.X{i};
    Linear_Model.Y{i} = sign(Linear_Model.U{i});
%     %   Caculating transfer value
%     if sum(strcmp(varargin,'hlim'))
%         
%     elseif sum(strcmp(varargin,'linear'))
%         Linear_Model.Y{i} = Linear_Model.U{i};
%     elseif sum(strcmp(varargin,'logistic'))
%         Linear_Model.Y{i} = 1./(1 + exp(- Linear_Model.U{i}));
%     elseif sum(strcmp(varargin,'hyperbolic'))
%         Linear_Model.Y{i} = tanh(Linear_Model.U{i});
%     end
end
% Get all class output of all PLAs
for i = 1:length(x)
    temp(:,i) = Linear_Model.Y{i};    
end
% Voting the result from all PLAs
y = sign(sum(temp,2));
%%  FUNCTION OUTPUT

if sum(strcmp(varargin, 'integer'))
    y = y./2 + repmat(3/2,size(y));
else
    y = y;
end

end

