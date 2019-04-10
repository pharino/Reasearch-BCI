function [ w ] = filter_array(min,max,step,fs,r,window)
%% Fuction: filter_array:
%   Description:
%       Create window component for w_i where i = 1,...,(max-min)/step +1
%       for FIR filter.
%       The output signal from filrer is: y = filter(w_i,1,x)
%   Input:
%   -   min: minimum frequency band in Hz
%   -   max: maximim frequency band in Hz
%   -   step: step of array bands
%   -   fs: sampling frequency. fs can be a vector, if so, the first
%   element is original sampling frequency, second element is up or down
%   sampling frequency.
%   -   r: ratio value of window. The default value is r = fs.
%   -   window: string name of window name of FIR filter. Default name is
%   'hamming' window.
%   Output:
%   -   w = [w1,w2,...,wN], N = (max-min)/step + 1

%% Catching input varaible
%   Default inputs variable values
% if nargin < 5
%     r  = fs;
%     window = 'hamming';
% elseif nargin < 6
%     window = 'hamming';
% end
% Sampling frequency
filter_array.Frequency = fs;
if isscalar(fs)
    filter_array.Frequency(1) = fs;
    filter_array.Frequency(2) = fs;
end

% Numbe of array filter
filter_array.N = floor((max-min)/step)+ 1;
% Create frequency band for all array filters
for i = 1:filter_array.N
    % Find frequency band boundry
    filter_array.Bands(1) = min + (i-1)*step - 0.5;
    filter_array.Bands(2) = min + i*step - 0.5;
    % Create filter window parameters
    filter_array.FIR{i} = fir_parameters(...
        'WindowFunction',window,...
        'SamplingFrequency',filter_array.Frequency,...
        'RatioOrder',r,...
        'PassBand',filter_array.Bands,...
        'Plot',0);
    w{i} = filter_array.FIR{i}{find(strcmp(filter_array.FIR{i},'FIR1'))+1};
end
end

