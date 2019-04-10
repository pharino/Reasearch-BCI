function [W,IStop,ER] = PLA_Parallel(X,Y,varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%       PLA_parallel(x,y,varargin)
% INPUT ARGUMENT
%   X: is M cell array where each cell is K by N matrix. N columns are
% sample, N rows are variables.
%   variable
%   Y: N-dimnsion row vector of class label
%   Wi: K-dimension initial weight of PLA_parallel. By default the wieght
% of linear will be used if Wi did not specified. Specify by 'Weight'
% folow by vector of Wi.
%   rho:    learning rate of PLA_parallel, 0.1 by default. String command
% 'LR' follow by value of rho.
%   IMax:   Maximum stop iteration of PLA_parallel, set to 10000 iterations
% by default, String command 'IMax' follow by an integer value.
%   IRP:Stop iteration when repeat the iteration, set to 1000 by
% default. String command 'IRP'.
%   Model:  is string for model of learning. It could be 'hlim',
% 'linear','logistic'or 'hyperbolic'. It could be specified by 'Model'
% command.
%
% OUTPUT ARGUMENT
%   w: Output weight of PLA_parallel
%   iters: Early stop iteration of PLA_parallel
%   err: Error rate of PLA_parallel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  CATCH INPUTS
% Normalize training  class to -1 and 1
PLA_parallel.T = zeros(length(Y),1);
PLA_parallel.TC   = unique(Y);
for i = 1:length(Y)
    if Y(i) == PLA_parallel.TC(1)
        PLA_parallel.T(i) = -1;
    else
        PLA_parallel.T(i) = 1;
    end
end


for i = 1:length(X)
    % Get size of training feature
    [PLA_parallel.K{i},PLA_parallel.N{i}] = size(X{i});
    PLA_parallel.X{i} = zeros(PLA_parallel.N{i},PLA_parallel.K{i}+1);
    PLA_parallel.X{i}(:,1) = 1;% x0 = 1
    PLA_parallel.X{i}(:,2:PLA_parallel.K{i}+1) = X{i}';
    
    %   Initialization weight by linear regression
    PLA_parallel.PSInverse{i} = ((PLA_parallel.X{i}'*PLA_parallel.X{i})^-1)*PLA_parallel.X{i}';
    PLA_parallel.W{i} = PLA_parallel.PSInverse{i}*PLA_parallel.T;
end

%   Initial learning rate and maximum iteration
PLA_parallel.rho  = 0.1;
PLA_parallel.IMax = 10000;
PLA_parallel.Irp  = 1000;


if sum(strcmp(varargin,'Weight'))
    for i = 1:length(X)
        PLA_parallel.W    = varargin{find(strcmp(varargin,'Weight'))+1};
    end
end

if sum(strcmp(varargin,'LR'))
    PLA_parallel.rho  = varargin{find(strcmp(varargin,'LR'))+1};
end
if sum(strcmp(varargin,'IMax'))
    PLA_parallel.IMax = varargin{find(strcmp(varargin,'IMax'))+1};
end
if sum(strcmp(varargin,'IRP'))
    PLA_parallel.Irp = varargin{find(strcmp(varargin,'IRP'))+1};
    
end
% if sum(strcmp(varargin,'Model'))
%     PLA_parallel.Model = varargin{find(strcmp(varargin,'Model'))+1};
%
%     if strcmp(PLA_parallel.Model,'linear')
%         PLA_parallel.fnc = @(x) x;
%     elseif strcmp(PLA_parallel.Model,'hlim')
%         PLA_parallel.fnc = @(x) sign(x);
%     elseif strcmp(PLA_parallel.Model,'logistic')
%         PLA_parallel.fnc = @(x) exp(x)./(1+exp(x));
%     elseif strcmp(PLA_parallel.Model,'hyperbolic')
%         PLA_parallel.fnc = @(x) tanh(x);
%     end
%
% end
%   -----------------------------------------------------------------------
%%  FUNCTION BODY

for i = 1:length(X)
    %   Initialise iteration and Error rate
    iter    = 0;
    ER      = 1;
    Repeat  = 0;
    W{i} = PLA_parallel.W{i};
    while(iter <= PLA_parallel.IMax)
        iter = iter + 1;
        %   Classify with current W
        PLA_parallel.Output   = sign(PLA_parallel.X{i}*PLA_parallel.W{i});% Transfer function of classifier
        %     PLA_parallel.Output   = sign(PLA_parallel.X*PLA_parallel.W);% Transfer function of classifier
        PLA_parallel.Output   = PLA_parallel.Output(:);
        %   Find the misclassify trial
        PLA_parallel.MC       = PLA_parallel.T ~= PLA_parallel.Output;
        
        %   Update new W
        PLA_parallel.W{i} = PLA_parallel.W{i} + (PLA_parallel.rho).*...
            PLA_parallel.X{i}(PLA_parallel.MC,:)'*(PLA_parallel.T(PLA_parallel.MC));
        %   Caculate error rate
        PLA_parallel.ER = erreval('Binary',PLA_parallel.Output,PLA_parallel.T);
        
        %%  Pocket algorithm
        %   Keep W if there is no  improvement over error rate
        if iter > 1
            % previous error is greater than current error, update weight
            % in the pocket
            if ER(iter-1) > PLA_parallel.ER
                ER(iter) = PLA_parallel.ER;
                W{i} = PLA_parallel.W{i};
                Repeat  = 0;
            else
                ER(iter) = ER(iter - 1);
                Repeat = Repeat + 1;
            end            
        end
        %   -----------------------------------------------------------------------
        
        %%  FUNCTION OUTPUT
        IStop   = iter-1;
        
        if Repeat > PLA_parallel.Irp
            break;
        end
        %   -----------------------------------------------------------------------
    end
end

end

