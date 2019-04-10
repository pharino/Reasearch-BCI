function [ ResultClassMean, ResultClassFold ] = SVMClassification(KernelFunction,Method,Mode,CrossValidation,ClassLabel, FeatureMatrix)

SVMClassification.Feature.All =  FeatureMatrix(:,:);
% progressbar;
for Fold = 1:min(size(CrossValidation.Train))
    
    %   Classification training data
    
    SVMClassification.Feature.Train       = SVMClassification.Feature.All(CrossValidation.Train(Fold,:),:);
    SVMClassification.ClassLabel.Train    = ClassLabel(CrossValidation.Train(Fold,:),:);
    
    %   Classification validation data
    if strcmp(Mode,'Train-Validation')
        SVMClassification.Feature.Validation       = SVMClassification.Feature.All(CrossValidation.Validation(Fold,:),:);
        SVMClassification.ClassLabel.Validation    = ClassLabel(CrossValidation.Validation(Fold,:),:);
        
    elseif strcmp(Mode,'Train-Test')
        SVMClassification.Feature.Validation       = SVMClassification.Feature.All(CrossValidation.Test(Fold,:),:);
        SVMClassification.ClassLabel.Validation    = ClassLabel(CrossValidation.Test(Fold,:),:);
        
    end
    
    %   Train SVM
    SVMClassification.SVMStruct = svmtrain(...
        SVMClassification.Feature.Train,...
        SVMClassification.ClassLabel.Train,...
        'Kernel_Function',KernelFunction,...
        'method',Method);
    
    %   Validation with SVM
    SVMClassification.ClassLabel.Prediction = svmclassify(...
        SVMClassification.SVMStruct,...
        SVMClassification.Feature.Validation);
    
    %   Calcualte mean square error rate
    
    SVMClassification.ClassLabel.Class = unique(ClassLabel);
    
    for Class = 1:length(SVMClassification.ClassLabel.Class)
        SVMClassification.ClassLabel.Temp.ClassIndex     = find(SVMClassification.ClassLabel.Validation == ...
            SVMClassification.ClassLabel.Class(Class));
        SVMClassification.ClassLabel.Temp.ClassPredict   = SVMClassification.ClassLabel.Prediction(...
            SVMClassification.ClassLabel.Temp.ClassIndex);
        SVMClassification.ClassLabel.Temp.ClassTarget    = SVMClassification.ClassLabel.Validation(SVMClassification.ClassLabel.Temp.ClassIndex);
        
        SVMClassification.Result.ClassFold(Fold,Class)   =  MSE(...
            'Binary',...
            SVMClassification.ClassLabel.Temp.ClassPredict,...
            SVMClassification.ClassLabel.Temp.ClassTarget);
        
    end
    %      progressbar(Fold/CrossValidation.FoldNumber);
end

SVMClassification.Result.ClassMean    = mean(SVMClassification.Result.ClassFold,1);

%%  Output variable
ResultClassFold     = SVMClassification.Result.ClassFold;
ResultClassMean     = SVMClassification.Result.ClassMean;

end

