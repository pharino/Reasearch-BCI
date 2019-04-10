function [ eeg_out_matrix ] = getEEG_signal( eeg_raw_matrix,eeg_source )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if strcmp(eeg_source,'BCI3')||strcmp(eeg_source,'BCI4')    
    eeg_out_matrix              = (0.1*double(eeg_raw_matrix))';
elseif strcmp(eeg_source,'URIS')                   % URIS dataset    
    eeg_out_matrix              = eeg_raw_matrix';
end
end

