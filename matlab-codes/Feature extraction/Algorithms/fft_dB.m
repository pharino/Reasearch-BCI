function [ spec_X frequency] = fft_dB( x,fs )

%% Singal properties
m = length(x);         % Length of signal 
%% Convert to frequency domain
nfft        = 2^nextpow2(m);
X           = fft(x,nfft)/m; %   convert to frequency domain and normalize
mag_X       = abs(X(1:nfft/2+1));
spec_X      = mag_X;
spec_X      = 20*log10(mag_X);
spec_X      = spec_X - max(spec_X);
frequency   = fs/2*linspace(0,1,(nfft/2)+1); % single side frequency
end

