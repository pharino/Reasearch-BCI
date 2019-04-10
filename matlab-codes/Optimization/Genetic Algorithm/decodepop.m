function [y] = decodepop(l,h,nbit,x)

%%  -----------------------------------------------------------------------
%   decodepop(l,h,nbit,binpop) : decode the binary matrix of population
%   into continuos value
decodepop.PopMatrixSize = size(x);
decodepop.NVarible      = decodepop.PopMatrixSize(2)/nbit;

for i = 1:decodepop.PopMatrixSize(1)
    for id = 1:decodepop.NVarible
        y(i,id) = bindecoder(l,h,x(i,((id-1)*nbit+1):(id*nbit)));
    end    
end
end

