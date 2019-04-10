function z = cl2feval(x,y)
%%  Evalutation of the fitness for both seperation and the error rate of each class
%   Input:
%       - x : mean square erro of classification of class 1
%       - y : mean square erro of classification of class 2
%   Output:
%       - z : the evaluation fitness

%%  Fitness
%       With x and y is range of [0 1]

z = 1 - ((x-y)^2 + (x+y))/2;

end