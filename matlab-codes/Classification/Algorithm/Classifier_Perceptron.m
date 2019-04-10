function [W,IStop,ER] = Classifier_Perceptron(X,Y,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%     [W,IStop,ER] = Perceptron(X,Y,W_i,rho,MaxI)
% INPUT ARGUMENT
%   X:      KxN matrix, N is number of trial, K is number of feature
%   variable
%   Y:      N-dimnsion of output class label
%   Wi:     K-dimension initial weight of perceptron. By default the wieght
%   of linear will be used if Wi did not specified. Specify by 'Weight'
%   folow by vector of Wi.
%   rho:    learning rate of perceptron, 0.1 by default. String command
%   'LR' follow by value of rho.
%   IMax:   Maximum stop iteration of perceptron, set to 10000 iterations
%   by default, String command 'IMax' follow by an integer value.
%   IRP:Stop iteration when repeat the iteration, set to 1000 by
%   default. String command 'IRP'.
%   Model:  is string for model of learning. It could be 'hlim',
%   'linear','logistic'or 'hyperbolic'. It could be specified by 'Model'
%   command.
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
        Perceptron.T(i) = -1;
    else
        Perceptron.T(i) = 1;
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
Perceptron.IMax = 10000;
Perceptron.Irp  = 1000;

if sum(strcmp(varargin,'Weight'))
    Perceptron.W    = varargin{find(strcmp(varargin,'Weight'))+1};
end

if sum(strcmp(varargin,'LR'))
    Perceptron.rho  = varargin{find(strcmp(varargin,'LR'))+1};
end
if sum(strcmp(varargin,'IMax'))
    Perceptron.IMax = varargin{find(strcmp(varargin,'IMax'))+1};
end
if sum(strcmp(varargin,'IRP'))
    Perceptron.Irp = varargin{find(strcmp(varargin,'IRP'))+1};
    
end
% if sum(strcmp(varargin,'Model'))
%     Perceptron.Model = varargin{find(strcmp(varargin,'Model'))+1};
%     
%     if strcmp(Perceptron.Model,'linear')
%         Perceptron.fnc = @(x) x;        
%     elseif strcmp(Perceptron.Model,'hlim')
%         Perceptron.fnc = @(x) sign(x);
%     elseif strcmp(Perceptron.Model,'logistic')
%         Perceptron.fnc = @(x) exp(x)./(1+exp(x));
%     elseif strcmp(Perceptron.Model,'hyperbolic')
%         Perceptron.fnc = @(x) tanh(x);
%     end
%     
% end
%   -----------------------------------------------------------------------
%%  FUNCTION BODY

%   Initialise iteration and Error rate
iter    = 0;
ER      = 1;
Repeat  = 0;
W = Perceptron.W;
while(iter <= Perceptron.IMax)
    iter = iter + 1;
    %   Classify with current W
%     Perceptron.Output   = Perceptron.fnc(Perceptron.X*Perceptron.W);% Transfer function of classifier
    Perceptron.Output   = sign(Perceptron.X*Perceptron.W);% Transfer function of classifier
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
            Repeat = Repeat + 1;
        end
        
    end
    %   -----------------------------------------------------------------------
    
    %%  FUNCTION OUTPUT
    IStop   = iter-1;
    
    if Repeat > Perceptron.Irp
        break;
    end
    %   -----------------------------------------------------------------------
end
end

