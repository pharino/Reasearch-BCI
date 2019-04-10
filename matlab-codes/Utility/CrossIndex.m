function [IndexTest IndexTrain] = CrossIndex(FoldNumber,TrialSize)

for Fold = 1:FoldNumber
    [IndexTest(Fold,:) IndexTrain(Fold,:)] = cross_partition(...
        Fold,...
        FoldNumber,...
        TrialSize);
end

%%  Nested function
    function [index_test  index_train ] = cross_partition(ith,fold,n )
        %UNTITLED7 Summary of this function goes here
        %   Detailed explanation goes here
        
        chunk = floor(n/fold);
        for k = 1:fold
            if k == ith
                index_test          = (1+(k-1)*chunk):1:(k*chunk);
            else
                index_train(:,k)    = (1+(k-1)*chunk):1:(k*chunk);
            end
            
        end
        index_train = find(index_train ~= 0);
    end


end

