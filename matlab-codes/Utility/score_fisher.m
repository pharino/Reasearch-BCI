function [f, index, normalize] = score_fisher(data, class,normalize)
%%  Function: 
% [score, index] = score_fisher(data, class)
%   Caculating Fisher score of variable in data based on label of class
%   pattern
%   Input:
%   -   data: m by n matrix of varaible of training sample. Row m is 
%   number of variable and column n is number of number of training sample   
%   -   class: class label pattern of sample. it is a vector of dimension n.  
%   -   normalize: logical state variable. If normalise is true, then the
%   score output will normalized in range [0, 1] the sum of score values.
%   Output: 
%   -   score: a vector of Fisher score of m dimesion arrage in descending 
%   order. 
%   -   index: a vector of m dimension of index of pre-ordering variable.   
%%  Formular for Fisher score
%   f(x_i) = (sum(nk *(uk)_i - u_i)^2)/(sigma_i)^2
%
%%  Code
[m,n] = size(data);

% If length of sample is different, display error message
if length(class) ~= n
    error('Data sample and class sample miss match');
end

% Find number of class pattern in class label
score_fisher.class = unique(class);

% Get number of each class and its index in sample
for i = 1:length(score_fisher.class)
    
    score_fisher.class_index(:,i)    = class == score_fisher.class(i);
    score_fisher.class_number(i)     = sum(score_fisher.class_index(:,i));
end


for i = 1:length(score_fisher.class)
    % Class mean of variable vector
    score_fisher.mean_class(:,i) = mean(data(:,score_fisher.class_index(:,i)),2);
    
    % Class standard deviation of variable vector
    score_fisher.std_class(:,i) = std(data(:,score_fisher.class_index(:,i)),0,2);
end

% mean of all class patterns
score_fisher.mean_all   = mean(score_fisher.mean_class,2);

score_fisher.meansquare_bt = zeros(m,1);% Between class mean square value
score_fisher.std_all = zeros(m,1);
score_fisher.class_pair = combntns(1:length(score_fisher.class),2);
for i = 1:(length(score_fisher.class)*(length(score_fisher.class)-1)/2)
    
    % Standard deviation of all class pattern
    score_fisher.std_all =  score_fisher.std_all ...
        + score_fisher.class_number(i).*(score_fisher.std_class(:,i).^2);
    % Between classes square mean
    score_fisher.meansquare_bt = score_fisher.meansquare_bt + ...
        score_fisher.class_number(i).*((score_fisher.mean_class(:,score_fisher.class_pair(i,1)) - score_fisher.mean_class(:,score_fisher.class_pair(i,2))).^2);
end

% Score value 
f = score_fisher.meansquare_bt./score_fisher.std_all; 

% if normalize is true, normalize score to interval [0,1]
if normalize == true
    f = (f./sum(f));
end

% Arrange score value in the descending order
[f, index] = sort(f,'descend');

end

