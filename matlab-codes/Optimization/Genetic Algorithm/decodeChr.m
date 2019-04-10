function [y] = decodeChr(l,h,nbit,x)

%%  -----------------------------------------------------------------------
%   decodepop(l,h,nbit,binpop) : decode the binary matrix of population
%   into continuos value
decodepop.ChrLength = length(x);
decodepop.NVarible      = decodepop.ChrLength(2)/nbit;

for id = 1:decodepop.NVarible
    y(id) = bindecoder(l,h,x(((id-1)*nbit+1):(id*nbit)));
end
end

