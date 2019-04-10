function create_EEG_struct(varargin)
%%   Convert EEG data and structure
for i = 1:2
    %   Switch input data
    switch i
        case 1
            file2load   = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Raw dataset\BCI IV\I\100Hz\BCICIV_1_mat\BCICIV_calib_ds1b.mat';
            file2save   = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Raw data with structure\BCI IV\I\BCICIV_calib_ds1b_100Hz.mat';
            dataset_properties = [...
                {'Dataset source'},{'BCI4'},...
                {'Dataset name'},'Dataset1',...
                {'Session'},'Calibration',...
                {'Subject name'},'B',...
                {'Process'},'Acquisition',...
                {'Sampling frequency'},{100},...
                {'EEG size'},{[]},...
                ];
        case 2
            file2load   = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Raw dataset\BCI IV\I\100Hz\BCICIV_1_mat\BCICIV_calib_ds1g.mat';
            file2save   = 'D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Raw data with structure\BCI IV\I\BCICIV_calib_ds1g_100Hz.mat';
            dataset_properties = [...
                {'Dataset source'},{'BCI4'},...
                {'Dataset name'},'Dataset1',...
                {'Session'},'Calibration',...
                {'Subject name'},'G',...
                {'Process'},'Acquisition',...
                {'Sampling frequency'},{100},...
                {'EEG size'},{[]},...
                ];
    end
    %   Load input dataset
    data_input  = load(file2load);
    %   Transform from integer to double
    EEG_data        = getEEG_signal(data_input.cnt,'BCI4');
    %   Get EEG information from dataset
    EEG_information = getEEG_info(data_input.mrk,data_input.nfo,'BCI4');
    %   Update data set properties
    dataset_properties{find(strcmp('Sampling frequency',dataset_properties))+ 1} = EEG_information.fs;
    dataset_properties{find(strcmp('EEG size',dataset_properties))+ 1} = num2str(size(EEG_data));
    %   Create EEG structure
    EEG{1} = 'Clab';
    EEG{2} = EEG_information.clab;
    EEG{3} = 'Marker';
    EEG{4} = EEG_information.marker_sample;
    EEG{5} = 'Class';
    EEG{6} = EEG_information.class;
    EEG{7} = 'Class outputs';
    EEG{8} = EEG_information.class_output;
    EEG{9} = 'Class trails';
    EEG{10} = EEG_information.class_trial;
    EEG{11} = 'Dataset information';
    EEG{12} = dataset_properties;
    EEG{13} = 'Active channels';
    EEG{14} = EEG_information.active_channels;
    EEG{15} = 'EEG matrix format';
    EEG{16} = [{'Channels'} {'Sample'}];
    EEG{17} = 'EEG matrix';
    EEG{18} = EEG_data;
    %   Save Data
    save(file2save,'EEG');
end
end

