function [ ResultFiness,ResultClass, ResultClassFold ] = SelectAndEvaluation(Method,SelectSize,PriorityIndex,Weight,CrossValidation,ClassLabel, FeatureMatrix)

SelectAndEvaluation.Parameters.SelectIndex = PriorityIndex(1:SelectSize);
SelectAndEvaluation.Feature.All =  SelectFeature(Method,...
    SelectAndEvaluation.Parameters.SelectIndex,...
    Weight,...
    FeatureMatrix);

for Fold = 1:min(size(CrossValidation.Train))
    
    %   Classification training data
    
    SelectAndEvaluation.Feature.Train       = SelectAndEvaluation.Feature.All(CrossValidation.Train(Fold,:),:);
    SelectAndEvaluation.ClassLabel.Train    = ClassLabel(CrossValidation.Train(Fold,:),:);
    
    %   Classification validation data
    
    SelectAndEvaluation.Feature.Validation       = SelectAndEvaluation.Feature.All(CrossValidation.Validation(Fold,:),:);
    SelectAndEvaluation.ClassLabel.Validation    = ClassLabel(CrossValidation.Validation(Fold,:),:);
    
    %   Train SVM
     SelectAndEvaluation.SVMStruct = svmtrain(...
         SelectAndEvaluation.Feature.Train,...
         SelectAndEvaluation.ClassLabel.Train,...
         'Kernel_Function','linear',...
         'method','LS');
     
    %   Validation with SVM
    SelectAndEvaluation.ClassLabel.Prediction = svmclassify(...
        SelectAndEvaluation.SVMStruct,...
        SelectAndEvaluation.Feature.Validation);
    
    %   Calcualte mean square error rate
    
     SelectAndEvaluation.ClassLabel.Class = unique(ClassLabel);
     
     for Class = 1:length(SelectAndEvaluation.ClassLabel.Class)
         SelectAndEvaluation.ClassLabel.Temp.ClassIndex     = find(SelectAndEvaluation.ClassLabel.Validation == ...
             SelectAndEvaluation.ClassLabel.Class(Class));
         SelectAndEvaluation.ClassLabel.Temp.ClassPredict   = SelectAndEvaluation.ClassLabel.Prediction(...
             SelectAndEvaluation.ClassLabel.Temp.ClassIndex);
         SelectAndEvaluation.ClassLabel.Temp.ClassTarget    = SelectAndEvaluation.ClassLabel.Validation(SelectAndEvaluation.ClassLabel.Temp.ClassIndex);
         
         SelectAndEvaluation.Result.ClassFold(Fold,Class)   =  MSE(...
             SelectAndEvaluation.ClassLabel.Temp.ClassPredict,...
             SelectAndEvaluation.ClassLabel.Temp.ClassTarget);        

     end
     
     SelectAndEvaluation.Result.FitnessFold(Fold)   = cl2feval( SelectAndEvaluation.Result.ClassFold(Fold,1),...
         SelectAndEvaluation.Result.ClassFold(Fold,2));
end
SelectAndEvaluation.Result.FitnessMean  = mean(SelectAndEvaluation.Result.FitnessFold);
SelectAndEvaluation.Result.ClassMean    = mean(SelectAndEvaluation.Result.ClassFold,1);

%%  Output variable

ResultClassFold = SelectAndEvaluation.Result.ClassFold;
ResultFiness    = SelectAndEvaluation.Result.FitnessMean;
ResultClass     = SelectAndEvaluation.Result.ClassMean;

end

