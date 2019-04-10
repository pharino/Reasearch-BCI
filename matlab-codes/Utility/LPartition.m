function [y] = LPartition(x,p)
%%  FUNCTION 
%   [ output_args ] = LPartition(x,p): Divide the label into partition to p
%   INPUT
%   -   x   : Vector of label
%   -   p   : Proportion of label to devide
%   OUTPUT
%   -   Cell array of output partition subsets

%%  CODE
% Catch input variables

LPartition.Size = length(x);
if sum(p) < 1
    LPartition.PN      = length(p) + 1; %  Number of set fro partition
    p(LPartition.PN)   = 1 - sum(p);   
elseif sum(p) == 1
    LPartition.PN = length(p);
else
     error('myApp:argChk',...
         'Sum of partitition must be less than or equal to 1');
end

LPartition.PS      = floor(LPartition.Size.*p); %  size of each partition subset.
LPartition.PU      = unique(x); % Number of unique value of label    
LPartition.Flag    = 0;

% Seperate label by class 
for i = 1:length(LPartition.PU)
    temp    = find(x == LPartition.PU(i));
    order   = randperm(length(temp));
    LPartition.Label(i,1:length(temp)) = temp(order); 
end

% Create single vector label
LPartition.Label = LPartition.Label(:);
temp = find(LPartition.Label == 0);
LPartition.Label(temp) = [];

% Select the non-zero value
[LPartition.Label junk] = FindUnique(LPartition.Label);

for i = 1:LPartition.PN
    if i == 1
        LPartition.Low =  1;
    else
        LPartition.Low =  1 + sum(LPartition.PS(1:(i-1)));
    end
    LPartition.Up  =  sum(LPartition.PS(1:i));
y{i} = LPartition.Label(LPartition.Low:LPartition.Up);
end   

end

