function binvalue = bincoder(l,h,nbit,value)
%%  Code the value into binary code

bincoder.Quantizer.mode         = 'ufixed';
bincoder.Quantizer.roundmode    = 'round';
bincoder.Quantizer.overflowmode = 'saturate';
bincoder.Quantizer.format       = [nbit nbit];

bincoder.q = quantizer(bincoder.Quantizer);
    
%   Normalize value to [0 1]
bincoder.size       = size(value);
bincoder.nvalue     = (value - l)/(h - l); 
binvalue            = num2bin(bincoder.q, bincoder.nvalue);
%   Convert binary string to binary array
binvalue            = binvalue - '0';

end

