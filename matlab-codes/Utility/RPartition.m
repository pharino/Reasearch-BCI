function [Y] = RPartition(N,P,K)
%%  -----------------------------------------------------------------------
%   RPartition(N,P,K) : select randomly value from 1:N and devide to subset
%   with approximation size of N*P(i)by repeating K time for each subset
%   Input:
%       - N : integer value of number observation data
%       - P : vector of normalize size of sub set, element of P must be in range of [0,1]. Sum of P's elements is 1;   
%       - K : Number of repeated arrangement
%   Output:
%       - Y : 1 by length(P) cell array of random arrange subset.

%%  -----------------------------------------------------------------------

CPartition.Set.All          = 1:N;
CPartition.Set.Select       = [];
CPartition.Set.Available    = [];
CPartition.SubsetSize       = floor(N.*P); 

if sum(P) < 1
    CPartition.SubsetSize(length(CPartition.SubsetSize) +1) = N - sum(CPartition.SubsetSize);
elseif sum(P) > 1
    error('myApp:argChk', 'sum of element of partition data must be 1');
end
CPartition.SubsetSize = CPartition.SubsetSize(find(CPartition.SubsetSize ~= 0));

%   Repeating selecting for K time
for k = 1:K
    CPartition.Set.Available = CPartition.Set.All;
    
    %   Number of subset
    for p = 1:length(CPartition.SubsetSize)
        CPartition.Set.Select   = []; 
        %   Number of element of each set
        for i = 1:CPartition.SubsetSize(p)
            CPartition.Set.Available                = CPartition.Set.Available(find(CPartition.Set.Available ~= 0)); 
            CPartition.p                            = floor(rand*(length(CPartition.Set.Available)- 1))+ 1;
            CPartition.Set.Select(i)                = CPartition.Set.Available(CPartition.p);
            CPartition.Set.Available(CPartition.p)  = 0;            
        end
        Y{p}(k,:)               = CPartition.Set.Select;        
    end
end

end

