function [ output_eeg ] = elliptical_filter( input_eeg, dataset_source )
%   [ output_eeg ] = ellipfilter( input_eeg, data_source )
%   input:
%       - input_eeg [m X 1] matrice
%       - data_source = 'bci3'/'uris'            
%% 
if strcmp(dataset_source,'bci3') || strcmp(dataset_source,'bci4')
    Fs = 1000; % Sample frequency 1000Hz
elseif strcmp(dataset_source,'uris')    
    Fs = 500; % Sample frequency 1000Hz
end
%% Filter properties
Fn = Fs/2;          % Nyquist frequency
Wp = [0.5 40]/Fn;   % Pass band [8Hz 40Hz]
Ws = [0.1 80]/Fn;   % Band attenuation
Rp = 1;             % Ripple 1dB in passband
Rs = 40;            % Ripple 40dB in stopband 
[n Wp] = ellipord(Wp,Ws,Rp,Rs);
%% Filter coeficient
[b,a] = ellip(n,Rp,Rs,Wp);
% freqz(b,a,200,Fs);
%% Filter
output_eeg = filter(b,a,input_eeg);
end