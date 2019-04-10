function [b,z] = lregression(x,y)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     FUNCTION: [b] = lregression(x,y)
%       Create linear regression model between input x and the output y
%   INPUT
%   x: matrix of N rows of observation and P columns of variable
%   y: matrix of N rows of observation output and K columns of output
%   variables.
%   OUTPUT
%   b: matrix of regression coefficient with N rows and K column 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  Main function
lregression.Size.x = size(x);
lregression.Size.y = size(y);
if lregression.Size.x(1) ~= lregression.Size.y(1);
    error('myApp:argChk', 'Number of row of X must equal to row of Y.')    
end
% Increase column of x by 1
lregression.x       = zeros(lregression.Size.x(1),lregression.Size.x(2)+1);
lregression.x(:,1)  = 1;
lregression.x(:,2:end) = x;
lregression.y = y;

% Caculating hat matrix
lregression.xinv = (lregression.x'*lregression.x)^-1;
% Regression coefficient matrix 
lregression.B = lregression.xinv*lregression.x'*lregression.y;
% Estimate output
lregression.yhat = lregression.x*lregression.B;
% Estimate variance output
lregression.var = sum((lregression.y - lregression.yhat).^2)/...
    (lregression.Size.x(1)-lregression.Size.x(2));
% Z-score estimate
lregression.z = lregression.B./...
    (lregression.var*sqrt(diag(lregression.xinv)));

% Output 
b = lregression.B;
z = lregression.z;
end

