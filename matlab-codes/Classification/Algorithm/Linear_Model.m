function [y] = Linear_Model( x,w,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%   [y] = Linear_Model( x,w,b,varargin)
%
% INPUT ARGUMENT
%   x:  KxN-matrix of input. K is number of variable, N is number of
%   observation
%   w:  K-dimension vector if linear model
%   b:  bias value
%   Fnc:Function tranformation of linear model. String command
%
% OUTPUT ARGUMENT
%   y: N-dimension vector of output.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Rearrage input matrix
%   Input matrix X
[Linear_Model.K,Linear_Model.N] = size(x);
Linear_Model.X = zeros(Linear_Model.K+1, Linear_Model.N);
Linear_Model.X(1,:) = 1;
Linear_Model.X(2:Linear_Model.K+1,:) = x;

%   Inclue bias into W
Linear_Model.W = w(:);

%   Linear transformation
Linear_Model.U = Linear_Model.W'*Linear_Model.X;

%   Caculating transfer value

if sum(strcmp(varargin,'hlim'))
    Linear_Model.Y = sign(Linear_Model.U);    
elseif sum(strcmp(varargin,'linear'))
    Linear_Model.Y = Linear_Model.U;
elseif sum(strcmp(varargin,'logistic'))
    Linear_Model.Y = 1./(1 + exp(- Linear_Model.U));
elseif sum(strcmp(varargin,'hyperbolic'))
    Linear_Model.Y = tanh(Linear_Model.U);
end

%%  FUNCTION OUTPUT

if sum(strcmp(varargin, 'integer'))
    Linear_Model.Y = Linear_Model.Y./2 + repmat(3/2,size(Linear_Model.Y));
end
y = Linear_Model.Y;
end

