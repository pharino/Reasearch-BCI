function z = Fitness1(x,y,k,N)
%%  Evalutation of the fitness for both seperation and the error rate of each class
%   Input:
%       - x : mean square erro of classification of class 1
%       - y : mean square erro of classification of class 2
%   Output:
%       - z : the evaluation fitness

%%  Fitness
%       With x and y is range of [0 1]
c1 = 0.6;
c2 = 0.3;
c3 = 0.1;

z = 1 - (c1*abs(x-y) + c2*(x+y) + c3*k/N )/(c1+c2+c3);

end