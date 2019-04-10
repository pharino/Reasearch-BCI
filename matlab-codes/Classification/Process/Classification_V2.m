function [ output_args ] = Classification_V2( input_args )
%UNTITLED5 Summary of this function goes here
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

for f = 1:length(file_name_input)
    %%  -------------------------------------------------------------------
    %                               Load dataset
    %%  -------------------------------------------------------------------
    file_fullname_input     = fullfile(path_input,file_name_input{f});
    data_input      = load(file_fullname_input);
    data_input      = data_input.EEG;
    data_info       = data_input{find(strcmp(data_input,'Dataset information'))+ 1};
    x               = data_input{find(strcmp(data_input,'EEG matrix'))+ 1};
    data_input{find(strcmp(data_input,'EEG matrix'))+ 1} = [];
    %%  -------------------------------------------------------------------
    %%                         Create cross validation data
    %%  -------------------------------------------------------------------
    %   Concatenation into single feature vector
    label = data_input{find(strcmp(data_input,'Class outputs'))+ 1};
    x_size  = size(x);
    x1      = x(:,:,27,:);
    x2      = x(:,:,29,:);
    x3      = x(:,:,30,:);
    clear x;
    x(:,:,1,:)  = x1; 
    x(:,:,2,:)  = x2; 
    x(:,:,3,:)  = x3;     
    for trial   = 1:x_size(4)
        temp                = x(:,:,:,trial);        
        feature(:,trial)    = temp(:); 
    end
    clear x;
    %   5 fold cross validation
    fold = 5;
    display('----------------------------Result----------------------------');
    for i = 1:fold
        [index_test index_train] = cross_partition(i,fold,x_size(4) );        
         %   Create training data
        for k = 1:length(index_train)
            feature_train(:,k)  = feature(:,index_train(k));
            label_train (k,1)   = label(index_train(k));
        end 
        feature_train           = feature_train';
        %   Create testing data
        for k = 1:length(index_test)
            feature_test(:,k)   = feature(:,index_train(k));
            label_test (k,1)    = label(index_test(k));
        end 
        feature_test            = feature_test';
        %   Train SVM
        SVMstruct               = svmtrain(feature_train,label_train,...
            'Kernel_Function','quadratic','method','QP');
        %   Classification
        label_predict           = svmclassify(SVMstruct,feature_test);
        %   Acciracy
        accuracy_fold(i)        =  length(find(label_predict == label_test))/length(label_test);
        %   Display
        display(strcat('Fold',num2str(i) ,' accuracy =',num2str(accuracy_fold(i))));
        %   ---------------------------------------------------------------
        %   clear
        clear feature_train;
        clear label_train;
        clear feature_test;
        clear label_test;        
    end
    accuracy = mean(accuracy_fold);
    display(strcat('Mean accuracy =  ', num2str(accuracy)));
    display('--------------------------------------------------------------');
%     %%  -------------------------------------------------------------------
%     %%                         Update information    
%     %%  -------------------------------------------------------------------
%     %   Update process information
%         output_args = [{'Window'},{'chebwin,fs,100'},...
%             {'Number overlap'},{118},...
%             {'Epoch'},{[0 4]},...
%             {'Frequency band'},{[0 40]}];
%         data_input{find(strcmp(data_input,'EEG matrix'))+ 1}            = stft_power;        
%         data_input{find(strcmp(data_input,'EEG matrix format'))+ 1}     = [{'frequency'},{'time'},...
%             {'channel'}, {'trial'}];     
%         data_info{find(strcmp(data_info,'EEG size'))+ 1}                = num2str(size(stft_power));
%         data_info{find(strcmp(data_info,'Process'))+ 1}{1 + length(data_info{find(strcmp(data_info,'Process'))+ 1})} = output_args;
%         data_input{find(strcmp(data_input,'Dataset information'))+ 1}   = data_info;   
%         clear output_args;
%         clear x;
%         clear stft_power;
%     
%     %%  -------------------------------------------------------------------
%     %%                         Save data
%     %%  -------------------------------------------------------------------
%     file_fullname_output        = fullfile(path_output,file_name_output{f});
%     EEG                         = data_input;
%     save(file_fullname_output,'EEG');
end
end

