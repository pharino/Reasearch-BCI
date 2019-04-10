function [t] = statistic_ttest(x,y)

%%  Definition
%   Function: [t] = statistic_ttest(x,y)
%   statistic_ttest(x,y) test whether x is the the gaussian distribution
%   with 0 mean value by using the equation:
%   
%           t = (u1-u2)/(s*sqrt(1/m1 + 1/m2)) 
%   with    s = ((m1 - 1)*(s1)^2 + (m2 - 1)*(s2)^2)/(m1 + m2 - 2)
%
%   where:  u1, u2 are mean of the each distribution
%           s1,s2 are standard deviation of the distribution
%           m1, m2 are number of example for each distribution
%   The distribution are the distribution of class 1 and class 2

%%  Data
%       Input
%               : x is Nx1 array vector or NxM matrix
%               : y is label vector of Nx1 dimension 
%       Output
%               : t is Nx1 arraye vector of t-test value
%   -----------------------------------------------------------------------

%%  Coding

if isvector(x)
    x = x(:);
    statistic_ttest.Size = length(x); 
else
    statistic_ttest.Size = size(x);    
end

%   Find the number of class distribution
statistic_ttest.Class = unique(y);

if length(statistic_ttest.Class) > 2
    error('myApp:argChk', 'T-test only apply 2 class of distribution');  
end

%   i is the class of distribution
for i = 1:length(statistic_ttest.Class)
    statistic_ttest.ClassIndex{i} = find(y == statistic_ttest.Class(i));
    statistic_ttest.N(i)    = length(statistic_ttest.ClassIndex{i});
    statistic_ttest.X{i}    = x(statistic_ttest.ClassIndex{i},:);
    statistic_ttest.Mean{i} = mean(statistic_ttest.X{i},1);
    statistic_ttest.std{i}  = std(statistic_ttest.X{i},1);
end

%   Calculating s-value
temp1 = 0;
temp2 = 0;
for i = 1:length(statistic_ttest.Class)
    temp1   = temp1 + (statistic_ttest.N(i)-1)*(statistic_ttest.std{i}.^2);
    temp2   = temp2 + statistic_ttest.N(i)-1;
end

statistic_ttest.S = temp1/temp2;


%   Calculating t-value
temp1 = 0;
temp2 = 0;
for i = 1:length(statistic_ttest.Class)
    temp1   = temp1 + (-1)^(i+1)*(statistic_ttest.Mean{i});
    temp2   = temp2 + 1/statistic_ttest.N(i);
end

statistic_ttest.T = temp1./(sqrt(temp2)*statistic_ttest.S);

t = statistic_ttest.T;
    
end

