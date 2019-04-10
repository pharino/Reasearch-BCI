
%   -------------------------------------------------------------------
%%  Load dataset
display('Loading dataset');
Process.Data.Main                               = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V3\BCICIV_Dataset_I_Subject_a_128Hz_FeatureExtractionV3.mat');

%%  -------------------------------------------------------------------
%   Crossvalidation

display('Creating cross validation data...');

Process.Data.Temp.CrossValidation.FoldNumber        = 10;
Process.Data.Temp.CrossValidation.CrossSize         = Process.Data.Main.Information.SignalSize(1);
[Process.Data.Temp.CrossValidation.IndexTest,...
    Process.Data.Temp.CrossValidation.IndexTrain]   = CrossIndex(...
    Process.Data.Temp.CrossValidation.FoldNumber,...
    Process.Data.Temp.CrossValidation.CrossSize);

Process.Data.Main.Information.CrossValidation       = Process.Data.Temp.CrossValidation;
Process.Data.Main.Information.SignalSize            = size(Process.Data.Main.Signal);
Process.Data        = rmfield(Process.Data,'Temp');

%%  -------------------------------------------------------------------
%   Selecting the best amount of feature
display('Preparing feature matrix...');

%   Select feature
Process.Data.Temp.Classification.Feature.AllFeature     = Process.Data.Main.Signal(:,:);
        

%%  -------------------------------------------------------------------
%   Classification analysis with effect number of training
display('Performing classification data...');
progressbar;
for f = 1:length(Process.Data.Temp.Classification.Feature.AllFeature)
    Process.Data.Temp.Classification.Feature.Select     = [];
    Process.Data.Temp.Classification.Feature.Select     = Process.Data.Temp.Classification.Feature.AllFeature(:,f);    
  
    [ Process.Data.Temp.Classification.Result.ClassMean(f,:), Process.Data.Temp.Classification.Result.ClassFold(f,:,:) ]            = SVMClassification('linear',...
        'LS',...
        Process.Data.Main.Information.CrossValidation,...
        Process.Data.Main.Information.class_output,...
        Process.Data.Temp.Classification.Feature.Select);    
    progressbar(f/length(Process.Data.Temp.Classification.Feature.AllFeature));
end


