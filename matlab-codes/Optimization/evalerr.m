function [ Result,ResultClass] = evalerr( Position,FeatureMatrix, Score,IndexFeature, CrossValidation, ClassLabel)

%%  evalerr : evaluate classification error rate
%   Input : 
%       - postion           : p scalair value of number of feature to be selected
%       - feature_matrix    : m by n matrix, m is trail, n is vaiable
%       - index_feature     : n by 1 vector of the prior selected variable
%       - CrossValidation   : structure with fields:
%           1)  Fold
%           2)  IndexTest
%           3)  IndexTrain
%       - Classification    : structure with field

%   Output: 
%       - FeatureSelect   : m by p matrix of selected variable
  
%   Select varaiable according to the position

evalerr.Index           = IndexFeature(1:Position);
evalerr.Feature.All     = FeatureMatrix(:,evalerr.Index);
evalerr.Feature.Weigth  = Score(evalerr.Index);
evalerr.Feature.Weigth  = repmat(evalerr.Feature.Weigth', 280,1);
evalerr.Feature.All     = evalerr.Feature.All.* evalerr.Feature.Weigth;

for f = 1:CrossValidation.FoldNumber 
    
    %   Classifiaction train data
    evalerr.Feature.Train       = evalerr.Feature.All(CrossValidation.IndexTrain(f,:),:);
    evalerr.ClassLabel.Train    = ClassLabel(CrossValidation.IndexTrain(f,:));
    
    %   Classification test data
    evalerr.Feature.Test        = evalerr.Feature.All(CrossValidation.IndexTest(f,:),:);
    evalerr.ClassLabel.Test     = ClassLabel(CrossValidation.IndexTest(f,:));
    
    %   Train SVM
    evalerr.Classification.SMVstruct = svmtrain(...
        evalerr.Feature.Train,...
        evalerr.ClassLabel.Train,...
        'Kernel_Function', 'linear',...
        'method', 'LS');    
    
    %   Test classifier
    evalerr.ClassLabel.Predict  = svmclassify(...
        evalerr.Classification.SMVstruct,...
        evalerr.Feature.Test);
    
    %   Calculate classification error rate    
    evalerr.ClassLabel.Class = unique(ClassLabel);
    
    for c = 1:length(evalerr.ClassLabel.Class)
        
        evalerr.ClassLabel.Temp.ClassIndex      = find(evalerr.ClassLabel.Test == evalerr.ClassLabel.Class(c));
        evalerr.ClassLabel.Temp.ClassPredict    = evalerr.ClassLabel.Predict(evalerr.ClassLabel.Temp.ClassIndex);
        evalerr.Error       = evalerr.ClassLabel.Temp.ClassPredict - evalerr.ClassLabel.Test(evalerr.ClassLabel.Temp.ClassIndex );
        evalerr.Result(f,c) = mean(evalerr.Error.^2);
    end
    
    %   Evaluate the fitness
    evalerr.ResultOutput(f)    = cl2feval(evalerr.Result(f,1),evalerr.Result(f,2));
    
end
evalerr.ResultOutputMean    = mean(evalerr.ResultOutput);
evalerr.ResultClassMean     = mean(evalerr.Result,1); 

%   Output fitness
ResultClass = evalerr.ResultClassMean;
Result      = evalerr.ResultOutputMean;


end

