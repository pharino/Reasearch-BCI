function [Y] = SelectFeature(Method,Index,W,X)
%%  SelectFeature(index,x):
%       - Input:
%           -   index   : selection index of x , it is a vector
%           -   x       : vector or matrix of m X n, m is observation, n is
%           variable
%       - Output:
%           -   y       :selected feature

FeatureSize = size(X);

if length(FeatureSize) > 2
    error('myApp:argChk', 'Feature must be a vector or matrix of feature and observation');
end
%   If x is vector
if iscolumn(W)
    W   = W';
end
W = W(Index);

if isvector(X)
    X   = X(Index);
    X   = X(:); 
elseif ismatrix(X)
    X   = X(:,Index);
    W   = repmat(W,[FeatureSize(1),1]); 
end

%       Apply method
if strcmp(Method,'Selection')
    Y   = X;
elseif strcmp(Method,'Weight')
    Y   = X.*W;
elseif strcmp(Method,'InnerProduct')
    Y   = X*W';
    Y   = Y(:,1);
else
    error('myApp:argChk', 'Operation is not support. Add more operation to code!');
end

end

