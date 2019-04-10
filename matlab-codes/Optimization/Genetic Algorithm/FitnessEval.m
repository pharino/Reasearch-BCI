function Z = FitnessEval(Type,E,C)
%%  Evalutation of the fitness for both seperation and the error rate of each class
%   Input:
%       - Type  : Integer for specific type of method of fitness evaluation
%       - E     : mean square erro of classification of class 1
%       - C     : mean square erro of classification of class 2
%   Output:
%       - Z     : the evaluation fitness

%%  Fitness
if find(E > 1)
     error('myApp:argChk', 'Error rate must be less than 1')
end
if length(E) ~= length(C)
     error('myApp:argChk', 'Error rate and scale must be the same length')
end
switch Type
    case 0
        Z = 1 - sum(E.*C)/sum(C);
    case 1
        Z = 1 - sum([abs(E(1)-E(2)), (E(1)+E(2))/2].*C)/sum(C);
    case 2
        Z = 1 - sum([abs(E(1)-E(2)), (E(1)+E(2))/2, E(3)].*C)/sum(C);
end
end