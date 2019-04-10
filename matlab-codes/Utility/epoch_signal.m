function [ output_args ] = epoch_signal( range,fs,marker,data_input)
%%  Epoching signal matrix function
%   Input: 
%   - range         : [ m n], m < n, both in second
%   - fs            : Sampling frequency
%   - marker        : vector of index = 0s
%   - data_input    : matrix of eeg signal, column is sample, row is
%   channels

%   Convert range from second to sample  
if range(1) > range(2)
    error('myApp:argChk', 'The first element of range must smaller that second');
end
range = range.*fs;
%   Reassure marker size
if min(size(marker)) == 1
    %   Check input data dimension, tranpose if necessary
    if(find(size(data_input) == min(size(data_input)))) == 2
        data_input  = data_input'; 
    end
    %   Resize marker if input data is smaller that marker value
    marker = marker(find(marker < length(data_input)));
    signalsize = size(data_input);
    data_output = zeros(signalsize(1),range(2)-range(1)+1,length(marker));
    %   Cutting data trail by trial
    for i = 1:length(marker)
        data_output(:,:,i) = data_input(:,marker(i)+range(1):marker(i)+range(2));
    end
    %   Output data
    output_args{1}  = 'Range';
    output_args{2}  = range./fs;
    output_args{3}  = 'Sampling frequency';
    output_args{4}  = fs;
    output_args{5}  = 'Marker';
    output_args{6}  = abs(range(1)) + 1;
    output_args{7}  = 'EEG';
    output_args{8}  = data_output;
else
   error('myApp:argChk', 'Input marker vector size error');
end
end

