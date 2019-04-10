function [y] = CPartition(N,K)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DESCRIPTION
%   FUNCTION y = CPartition(N,K)
%   y = CPartition(N,K): find K cross validation index of from  N
%   elements
%
%   INPUT
%   N : number of total element
%   K : number of cross index
%
%   OUTPUT
%   y : 2 by 1 cell array vector. Each cell is matrix index of size K by
%   floor(N/K).
%
%   COPY RIGHT
%   2013 Pharino Chum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Code
%   Index of all element
CPartition.IndexAll = 1:N;
%   Integer element for partition
CPartition.IndexAvailable = 1:K*floor(N/K);
%   Left over element
CPartition.IndexLeft = length(CPartition.IndexAvailable)+1:length(CPartition.IndexAll);
%   1st cell of output
CPartition.KSub1 = vec2mat(CPartition.IndexAvailable,K)';

%   2nd cell of output
for i = 1:K
    %   Copy the first cell element
    temp = CPartition.KSub1;
    %   Empty current row elememts
    temp(i,:) = [];
    %   Combine with left over elements
    temp = [temp(:);CPartition.IndexLeft(:)];
    CPartition.KSub2(i,:) = sort(temp,'ascend');
    clear temp;
end
y{1} = CPartition.KSub1;
y{2} = CPartition.KSub2;
end

