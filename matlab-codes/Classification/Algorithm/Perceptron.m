function [W,IStop,ER] = Perceptron(X,Y,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%     [W,IStop,ER] = Perceptron(X,Y,W_i,rho,MaxI)
% INPUT ARGUMENT
%   X:      KxN matrix, N is number of trial, K is number of feature
%   variable
%   Y:      N-dimnsion of output class label
%   Wi:     K-dimension initial weight of perceptron
%   rho:    learning rate of perceptron
%   IMax:   Maximum stop iteration of perceptron
%
% OUTPUT ARGUMENT
%   W:      Output weight of perceptron
%   IStop:  Early stop iteration of perceptron
%   ER:     Error rate of perceptron
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  CATCH INPUTS

Perceptron.T = zeros(length(Y),1);
Perceptron.TC   = unique(Y);
for i = 1:length(Y)
    if Y(i) == Perceptron.TC(1)
        Perceptron.T(i) = 1;
    else
        Perceptron.T(i) = -1;
    end
end

[Perceptron.K,Perceptron.N] = size(X);
Perceptron.X = zeros(Perceptron.N,Perceptron.K+1);
Perceptron.X(:,1) = 1;
Perceptron.X(:,2:Perceptron.K+1) = X';

%   Initialization weight by linear regression
Perceptron.PSInverse = ((Perceptron.X'*Perceptron.X)^-1)*Perceptron.X';
Perceptron.W    = Perceptron.PSInverse*Perceptron.T;

%   Initial learning rate and maximum iteration
Perceptron.rho  = 0.1;
Perceptron.IMax = 5000;

if strcmp(varargin,'Weight')
    Perceptron.W    = varargin{find(strcmp(varargin,'Weight'))+1};
    
elseif strcmp(varargin,'LR')
    Perceptron.rho  = varargin{find(strcmp(varargin,'LR'))+1};
    
elseif strcmp(varargin,'IMax')
    Perceptron.IMax = varargin{find(strcmp(varargin,'IMax'))+1};
    
end
%   -----------------------------------------------------------------------
%%  FUNCTION BODY

%   Initialise iteration and Error rate
iter    = 0;
ER      = 1;
while(iter <= Perceptron.IMax)
    iter = iter + 1;
    %   Classify with current W
    Perceptron.Output   = sign(Perceptron.X*Perceptron.W); 
    Perceptron.Output   = Perceptron.Output(:); 
    %   Find the misclassify trial
    Perceptron.MC       = find(Perceptron.T ~= Perceptron.Output);
    %   Update new W
    
    Perceptron.W = Perceptron.W + (Perceptron.rho).*...
        Perceptron.X(Perceptron.MC,:)'*(Perceptron.T(Perceptron.MC));
    %   Caculate error rate    
    Perceptron.ER = erreval('Binary',Perceptron.Output,Perceptron.T);
    
    %%  Pocket algorithm
    %   Keep W if there is no  improvement over error rate
    if iter > 1
        if ER(iter-1) > Perceptron.ER
            ER(iter) = Perceptron.ER;
            W = Perceptron.W;
        else
            ER(iter) = ER(iter - 1);
        end
    end
    
end
%   -----------------------------------------------------------------------

%%  FUNCTION OUTPUT
IStop   = iter-1;
%   -----------------------------------------------------------------------
end

