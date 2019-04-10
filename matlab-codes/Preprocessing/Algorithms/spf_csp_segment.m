function [ w, lamda, index] = spf_csp_segment(x,c,l)
%%  -----------------------------------------------------------------------
%   FUNCTION
%   [ w, lamda, index] = spf_csp_segment(x,c,l): Common spatial filter for weight w and lamba

%   INPUT ARGUMENT
%   x   : C by T by N matrix of training singal
%   c   : N column of the class of the training singal. c must have 2 types
%   l   : length of EEG signal in sample
%   of element

%   OUTPUT ARGUMENT
%   w   : C by C matrix transformation. The output of filter is y = w'*x
%   lamba: N vector of eigenvalue of w.
%   index: index of aranging eigenvalues.

%   CSP algorithm
%%  -----------------------------------------------------------------------

%%  CODE
%   EEG signal dimension
[C,T,N] = size(x);

%   find number of class label of
spf_csp.Class   = unique(c);
k   = length(spf_csp.Class);
if k ~= 2
    error('myApp:argChk', 'number of class of CSP must be 2');
end

%   find the estimated covariance matrice if spatial pattern x
for i = 1:k
    
    %   Number of observation of each class
    spf_csp.NClass{i} = find(c == spf_csp.Class(i));
    spf_csp.xclass  = x(:,:,spf_csp.NClass{i});
    
    spf_csp.xmean = mean(spf_csp.xclass,3);
    
    %   Split EEG signal to small segment
    
    spf_csp.NSplit = floor(T/l);
    
    for m = 1:length(spf_csp.NClass{i})
        %   EEG signal of each trial
        xc = x(:,:,spf_csp.NClass{i}(m));
        
        
        for j = 1:spf_csp.NSplit
            
            %   Split EEG signal to segment of length 'l'
            xsp     = xc(:,(j-1)*l+1:j*l) - spf_csp.xmean(:,(j-1)*l+1:j*l);
            
            %   find the covariance matrix of each segment
            xsp_cov(:,:,j)  =  xsp*xsp';
            
        end
        %   Average the covariance of EEG segment
        xcov(:,:,m) = mean(xsp_cov,3);
        
    end
    spf_csp.ECov(:,:,i)   =  mean(xcov,3);
end

%   Common spatial covariance
spf_csp.Sc  = mean(spf_csp.ECov,3);

%   Disciminant covariance
spf_csp.Sd  = spf_csp.ECov(:,:,1) - spf_csp.ECov(:,:,2);

%   Generalized eigenvalues and eigevectors
[spf_csp.EVec, spf_csp.EVal ] = eig(spf_csp.Sd,spf_csp.Sc);

%   Get diagonal form of eigenvalue for eigen matrix
spf_csp.EVal = diag(spf_csp.EVal);

%   Sort eigenvalue in descending order
[lamda, index] = sort(spf_csp.EVal, 'descend');

w = spf_csp.EVec(:,index);

end
