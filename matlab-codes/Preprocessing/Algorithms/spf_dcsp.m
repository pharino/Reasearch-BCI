function [w, v, id] = spf_dcsp(x,c)

%% FUNCTION: [w, v, d] = dcsp(x,c)
%   DESCRPITION:
%   -   Function calculate linear time invariance transformatio matrix w
%   using data x and class lable c. 
%
%   INPUT: 
%   -   x: m by n by k matrix of EEG data. Where m is spatial number. n is
%   temporal sample and k is number of training samples.
%   -   c: a vector of class label. C should be a vector of integers
%   OUTPUT: 
%   -   w: m by m transforamtion matrix 
%   -   v: a vector of eigenvalues
%   -   d: 

%%  Code of discriminant spatial pattern

% Find numbers of class patterns in EEG data
spf_dcsp.class = FindUnique(c);
% Data size
spf_dcsp.dsize = size(x);

% Initial values of between class and within class scatter matrix
spf_dcsp.sb = zeros(spf_dcsp.dsize(1),spf_dcsp.dsize(1),length(spf_dcsp.class));
spf_dcsp.sw = zeros(spf_dcsp.dsize(1),spf_dcsp.dsize(1),length(spf_dcsp.class));

% Find covariance of each class pattern
for i = 1:length(spf_dcsp.class)
    % logical array of class label, 1 if it is in the right class
    temp{i} = find(c == spf_dcsp.class(i));
    
    % Covaraince of each class 
    for j = 1:length(temp{i})
        xc = x(:,:,temp{i}(j))*x(:,:,temp{i}(j))';
        spf_dcsp.sb(:,:,i) = spf_dcsp.sb(:,:,i) + xc;
    end
end

spf_dcsp.sd = spf_dcsp.sb(:,:,1) - spf_dcsp.sb(:,:,2);

% Find covariance of each class pattern
for i = 1:length(spf_dcsp.class)       
    % Covaraince of each class 
    for j = 1:length(temp{i})
        xc = x(:,:,temp{i}(j))*x(:,:,temp{i}(j))';
        spf_dcsp.sw(:,:,i) = (spf_dcsp.sb(:,:,i) - xc)*(spf_dcsp.sb(:,:,i) - xc)';
    end
end

% sum of total within class scatter
spf_dcsp.sw = sum(spf_dcsp.sw,3);
% Find the generalizes eigenvectors and eigenvalues 
[w,v,] = eig(spf_dcsp.sd,spf_dcsp.sw);
v = diag(real(v));

[v,id] = sort(v,'descend');
w = w(:,id);
end

