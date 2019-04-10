function [w, v, id] = spf_dsp(x,c)

%% FUNCTION: [w, v, d] = dsp(x,c)
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
spf_dsp.class = FindUnique(c);
% Data size
spf_dsp.dsize = size(x);

% Caculating mean of all classes
spf_dsp.xbar = mean(x,3);

% Initial values of between class and within class scatter matrix
spf_dsp.sb = zeros(spf_dsp.dsize(1),spf_dsp.dsize(1));
spf_dsp.sw = zeros(spf_dsp.dsize(1),spf_dsp.dsize(1),length(spf_dsp.class));

% Find covariance of each class pattern
for i = 1:length(spf_dsp.class)
    % logical array of class label, 1 if it is in the right class
    spf_dsp.clogic(i,:) = (c == spf_dsp.class(i));
    
    % Class average EEG patterns
    spf_dsp.xbar_class(:,:,i) = mean(x(:,:,spf_dsp.clogic(i,:)),3);
    
    % Between class scatter covaraince matrix
    spf_dsp.sb = spf_dsp.sb + (spf_dsp.xbar - spf_dsp.xbar_class(:,:,i))*(spf_dsp.xbar - spf_dsp.xbar_class(:,:,i))';
    
    % Within class scatter 
    index = find(spf_dsp.clogic(i,:)== true);
    
    for j = 1:length(index)
        spf_dsp.sw(:,:,i) = spf_dsp.sw(:,:,i) + (x(:,:,index(j))-spf_dsp.xbar_class(:,:,i))*(x(:,:,index(j))-spf_dsp.xbar_class(:,:,i))'; 
    end
    
end
% sum of total within class scatter
spf_dsp.sw = sum(spf_dsp.sw,3);
% Find the generalizes eigenvectors and eigenvalues 
[w,v,] = eig(spf_dsp.sb,spf_dsp.sw);
v = diag(real(v));

[v,id] = sort(v,'descend');
w = w(:,id);
end

