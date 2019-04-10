function y = erreval(type,x,t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%   [y] = erreval(type,x,t) : Error meansurement function
%
% INPUT ARGUMENT     
%   type    : type of error measurement
%   x       : testing variable vector
%   t       : target variable vector
%   
% OUTPUT ARGUMENT
%   y       : output error measuring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(x) ~= length(t)
    error('myApp:argChk',...
        'length of prediction and target vector must be the same');
elseif ~isvector(x) || ~isvector(t)
    error('myApp:argChk',...
        'Target and prediction must be vector');
end
%   Binary error
if strcmp(type,'Binary')
    y = length(find(x ~= t))/length(t);

%   Mean square error  
elseif strcmp(type,'MSE')
    %   Square error
    erreval.ErrorSquare = (t-x).^2;    
    %   Mean square error output
    y   =  mean(erreval.ErrorSquare);    
end
end

