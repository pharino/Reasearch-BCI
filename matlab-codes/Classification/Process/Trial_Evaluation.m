function [TrialNumber,TrialError] = Trial_Evaluation(CrossValidation,ClassTarget,FeatureMatix)

ROCEval.ValidationSize  = size(CrossValidation.IndexTest);
ROCEval.TrainSize       = size(CrossValidation.IndexTrain);
ROCEval.Feature.All     = FeatureMatix;

progressbar;
for k = ROCEval.ValidationSize(2): ROCEval.TrainSize(2)   
    
    for Fold = 1:CrossValidation.FoldNumber
        
        ROCEval.CrossValidation.TrainIndex      = CrossValidation.IndexTrain(Fold,1:k);
        ROCEval.CrossValidation.ValidationIndex = [CrossValidation.IndexTest(Fold,:),CrossValidation.IndexTrain(Fold,k+1:ROCEval.TrainSize(2))];
        
        %   Classification training data
        
        ROCEval.Feature.Train           = ROCEval.Feature.All(ROCEval.CrossValidation.TrainIndex ,:);
        ROCEval.ClassLabel.Train        = ClassTarget(ROCEval.CrossValidation.TrainIndex ,:);
        
        %   Classification validation data
        
        ROCEval.Feature.Validation      = ROCEval.Feature.All(ROCEval.CrossValidation.ValidationIndex,:);
        ROCEval.ClassLabel.Validation   = ClassTarget(ROCEval.CrossValidation.ValidationIndex,:);
        
        %   Train SVM
        ROCEval.SVMStruct = svmtrain(...
            ROCEval.Feature.Train,...
            ROCEval.ClassLabel.Train,...
            'Kernel_Function','linear',...
            'method','LS');
        
        %   Validation with SVM
        ROCEval.ClassLabel.Prediction = svmclassify(...
            ROCEval.SVMStruct,...
            ROCEval.Feature.Validation);
        
        %   Calcualte mean square error rate
        
        ROCEval.ClassLabel.Class = unique(ClassTarget);
        
        for Class = 1:length(ROCEval.ClassLabel.Class)
            
            ROCEval.ClassLabel.Temp.ClassIndex     = find(ROCEval.ClassLabel.Validation == ...
                ROCEval.ClassLabel.Class(Class));
            
            ROCEval.ClassLabel.Temp.ClassPredict   = ROCEval.ClassLabel.Prediction(...
                ROCEval.ClassLabel.Temp.ClassIndex);
            
            ROCEval.ClassLabel.Temp.ClassTarget    = ROCEval.ClassLabel.Validation(ROCEval.ClassLabel.Temp.ClassIndex);
            
            ROCEval.Result.ClassFold(Class,k + 1 - ROCEval.ValidationSize(2),Fold)   =  MSE(...
                ROCEval.ClassLabel.Temp.ClassPredict,...
                ROCEval.ClassLabel.Temp.ClassTarget);
        end
    end
    progressbar((k + 1 - ROCEval.ValidationSize(2))/(ROCEval.TrainSize(2)-ROCEval.ValidationSize(2)));
end

ROCEval.Result.Mean    = mean(ROCEval.Result.ClassFold,3);

%%  Output result
TrialError      = ROCEval.Result.Mean;
TrialNumber     = (ROCEval.ValidationSize(2): ROCEval.TrainSize(2))';

end

