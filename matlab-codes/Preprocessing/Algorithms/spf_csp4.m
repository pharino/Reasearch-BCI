function [ w, lamda, index] = spf_csp3(x,c)

%%  -----------------------------------------------------------------------
%   FUNCTION
%   [ w, v, index ] = spf_csp(x,c): Common spatial filter for weight w and lamba

%   INPUT ARGUMENT
%   x   : C by T by N matrix of training singal
%   c   : N column of the class of the training singal. c must have 2 types
%   of element

%   OUTPUT ARGUMENT
%   w   : C by C matrix transformation. The output of filter is y = w'*x
%   lamba: N vector of eigenvalue of w.
%   index: index of aranging eigenvalues.

%   CSP algorithm

%%  -----------------------------------------------------------------------
%   CODE
spf_csp.Class   = unique(c);
k   = length(spf_csp.Class);
if k ~= 2
    error('myApp:argChk', 'number of class of CSP must be 2');
end

%   find the estimated covariance matrice if spatial pattern x

for i = 1:k
    
    spf_csp.NClass{i} = find(c == spf_csp.Class(i));
    
    xmean = mean(x(:,:,spf_csp.NClass{i}),3);
    
    for m = 1:length(spf_csp.NClass{i})
        xc = x(:,:,spf_csp.NClass{i}(m));
        xcov(:,:,m) = xc*xc';
    end
    spf_csp.ECov(:,:,i)   =  mean(xcov,3);
end

%   Common spatial covariance
spf_csp.Sc  = spf_csp.ECov(:,:,1);

%   Disciminant covariance
spf_csp.Sd  = spf_csp.ECov(:,:,2);

%   Generalized eigenvalues and eigevectors
[spf_csp.EVec, spf_csp.EVal ] = eig(spf_csp.Sd,spf_csp.Sc);

spf_csp.EVal = diag(spf_csp.EVal);

[lamda, index] = sort(spf_csp.EVal, 'descend');

w = spf_csp.EVec(:,index);

end

