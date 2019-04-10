function value = bindecoder(l,h,binvalue)
%%  Code the value into binary code
bindecoder.size                    = size(binvalue);
bindecoder.nbit                    = bindecoder.size(2);
bindecoder.Quantizer.mode          = 'ufixed';
bindecoder.Quantizer.roundmode     = 'round';
bindecoder.Quantizer.overflowmode  = 'saturate';
bindecoder.Quantizer.format        = [bindecoder.nbit  bindecoder.nbit ];
%   if lower value is less than 0, change mode to unsigned fixed point
bindecoder.q = quantizer(bindecoder.Quantizer);
%   Normalize value to [0 1]
if isstr(binvalue)
    binvalue = binvalue; 
else
    binvalue = dec2bin(binvalue)';
end
bindecoder.nvalue   = bin2num(bindecoder.q, binvalue);
value               = bindecoder.nvalue*(h - l) + l;

end