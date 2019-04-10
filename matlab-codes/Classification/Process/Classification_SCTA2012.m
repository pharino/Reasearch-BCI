function [ output_args ] = Classification_SCTA2012( input_args )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%%  -----------------------------------------------------------------------
%                          Loading and saving dataset
%%  -----------------------------------------------------------------------
%  Input dataset
path_input          = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\FeatureExtraction V1';
file_name_input{1}  = 'BCICIV_calib_ds1b_100Hz_FeatureExtraction_V1.mat';
file_name_input{2}  = 'BCICIV_calib_ds1g_100Hz_FeatureExtraction_V1.mat';

%  Output dataset name
path_output         = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Classification data\Classification V1';
file_name_output{1} = 'BCICIV_calib_ds1b_100Hz_Classification_V1.mat';
file_name_output{2} = 'BCICIV_calib_ds1g_100Hz_Classification_V1.mat';


end

