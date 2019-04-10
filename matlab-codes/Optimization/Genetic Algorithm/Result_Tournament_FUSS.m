clear;
%%  -----------------------------------------------------------------------
%   Predisplay plot parameters
GA.View.X(1,:) = linspace(0,2,100);
GA.View.X(2,:) = linspace(0,2,100);
for i = 1:length(GA.View.X(1,:))
    for k = 1:length(GA.View.X(2,:))
        GA.View.XTemp = [GA.View.X(1,i), GA.View.X(2,k)];
        GA.View.Y(i,k) = Rastrigin2(GA.View.XTemp);
    end
end

[C H] = contour(GA.View.X(1,:), GA.View.X(2,:), GA.View.Y);
set(H,'ShowText','on','TextStep',get(H,'LevelStep'))
view(0,90);
xlabel('x_{1}');
ylabel('x_{2}');
title('y = 10^2 + x_1^2 - 10x_2cos(3\pix_1) + x_2^2 - 10x_1cos(3\pix_2)');

%%  -----------------------------------------------------------------------
%   Result

%   load data
Data1{1} = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\Genetic Algorithm\Tournament selection-uniform.mat');
Data1{2} = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\Genetic Algorithm\Tournament selection-single point.mat');
Data1{3} = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\Genetic Algorithm\Tournament selection-two points.mat');

Data2{1} = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\Genetic Algorithm\FUSS-uniform.mat');
Data2{2} = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\Genetic Algorithm\FUSS-single point.mat');
Data2{3} = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\Genetic Algorithm\FUSS-two points.mat');


DataSize    = size(Data1{1,1}.Analysis.Result.Fitness.Best);

%   Comparision of cross over method of tournament selection method
figure
style{1} = 'k';
style{2} = 'b.';
style{3} = 'r--';

plot(1:DataSize(2),...
    Data1{1,1}.Analysis.Result.MeanFitness.Best,...
    style{1});
hold on;
plot(1:DataSize(2),...
    Data1{1,2}.Analysis.Result.MeanFitness.Best,...
    style{2});
plot(1:DataSize(2),...
    Data1{1,3}.Analysis.Result.MeanFitness.Best,...
    style{3});
hold off;
xlabel('Iteration')
ylabel('Fitness value');
legend('Uniform cross over',...
    'Single point cross over',...
    'Two points cross over',...
    'Location','SouthEast');

%   Compatision of cross over method of FUSS method
figure
style{1} = 'k';
style{2} = 'b.';
style{3} = 'r--';

plot(1:DataSize(2),...
    Data2{1,1}.Analysis.Result.MeanFitness.Best,...
    style{1});
hold on;
plot(1:DataSize(2),...
    Data2{1,2}.Analysis.Result.MeanFitness.Best,...
    style{2});
plot(1:DataSize(2),...
    Data2{1,3}.Analysis.Result.MeanFitness.Best,...
    style{3});
hold off;
xlabel('Iteration')
ylabel('Fitness value');
legend('Uniform cross over',...
    'Single point cross over',...
    'Two points cross over',...
    'Location','SouthEast');

%   Comparision of best fitness value of methods
figure
style{1} = 'k-';
style{2} = 'b.';

plot(1:DataSize(2),...
    Data1{1,2}.Analysis.Result.MeanFitness.Best,...
    style{1});
hold on;
plot(1:DataSize(2),...
    Data2{1,2}.Analysis.Result.MeanFitness.Best,...
    style{2});
xlabel('Iteration')
ylabel('Fitness value');
legend('Tournament selection method',...
    'FUSS method',...
    'Location','SouthEast');


