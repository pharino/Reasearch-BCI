clear
Data(1) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_aa_128Hz.mat');
Data(2) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_al_128Hz.mat');
Data(3) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_av_128Hz.mat');
Data(4) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_aw_128Hz.mat');
Data(5) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_ay_128Hz.mat');
Data(6) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_a_128Hz.mat');
Data(7) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_b_128Hz.mat');
Data(8) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_f_128Hz.mat');
Data(9) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_g_128Hz.mat');

Data2(1) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_aa_128Hz1.mat');
Data2(2) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_al_128Hz1.mat');
Data2(3) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_av_128Hz1.mat');
Data2(4) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_aw_128Hz1.mat');
Data2(5) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIII_Dataset_IVa_Subject_ay_128Hz1.mat');
Data2(6) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_a_128Hz1.mat');
Data2(7) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_b_128Hz1.mat');
Data2(8) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_f_128Hz1.mat');
Data2(9) = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Optimization\BCICIV_Dataset_I_Subject_g_128Hz1.mat');

%%  Variable
ResultPlot.FeatureLength = 1:length(Data(1,1).FisherScore.ScoreSort);

%%  Plot fisher score
figureW;
subplot(2,1,1)
plot(ResultPlot.FeatureLength, Data(1,1).FisherScore.Score,'k');
axis([0 length(ResultPlot.FeatureLength) 0 0.5]);
xlabel('Feature (X)');
ylabel('Fisher score(F)');

subplot(2,1,2)
plot(ResultPlot.FeatureLength, Data(1,1).FisherScore.ScoreSort,'k',...
    'LineWidth',1.5);
axis([0 length(ResultPlot.FeatureLength) 0 0.5]);
xlabel('Sorted feature (X)');
ylabel('Sorted Fisher score(F)');


%%  Plot Fittnes history
ResultPlot.Position = Data2(1,1).PSO.Particle.History.Position(:,:,1:length(Data2(1,1).PSO.Particle.GlobalBest.Position));
ResultPlot.Position = ResultPlot.Position(:);
[ResultPlot.PositionSort ResultPlot.Index] = sort(ResultPlot.Position,'ascend');

ResultPlot.Fitness  = Data2(1,1).PSO.Particle.History.Fitness(:,:,1:length(Data2(1,1).PSO.Particle.GlobalBest.Position));
ResultPlot.Fitness  = ResultPlot.Fitness(:);
ResultPlot.Fitness  = ResultPlot.Fitness(ResultPlot.Index);
for i = 1:Data2(1,1).PSO.Parameters.ParticelSize
    ResultPlot.Error(i,:,:) = Data2(1,1).PSO.Particle.History.ClassFitness(1,i,1:length(Data2(1,1).PSO.Particle.GlobalBest.Position),:);
end

ResultPlot.ErrorClass1 = ResultPlot.Error(:,:,1);
ResultPlot.ErrorClass1 = ResultPlot.ErrorClass1(:);
ResultPlot.ErrorClass1 = ResultPlot.ErrorClass1(ResultPlot.Index);% in percentage

ResultPlot.ErrorClass2 = ResultPlot.Error(:,:,2);
ResultPlot.ErrorClass2 = ResultPlot.ErrorClass2(:);
ResultPlot.ErrorClass2 = ResultPlot.ErrorClass2(ResultPlot.Index);% in percentage

%       PLot Fitness and error rate
figureW;
[AX, H1, H2] = plotyy(ResultPlot.PositionSort,ResultPlot.Fitness,ResultPlot.PositionSort, ResultPlot.ErrorClass1,'plot');

hold(AX(1),'on');
axes(AX(1));
cla(AX(1));
plot(ResultPlot.PositionSort,ResultPlot.Fitness,'k');
set(AX(1),'XColor',[0 0 0]);
set(AX(1),'yColor',[0 0 0]);
ylim([0 1]);
set(AX(1),'YTick',0:0.1:1);
ylabel('Swarm fitness value (FT)')
xlim([1 length(ResultPlot.FeatureLength)]);

hold(AX(2),'on');
axes(AX(2));
cla(AX(2));
plot(ResultPlot.PositionSort, ResultPlot.ErrorClass1,'-.k');
plot(ResultPlot.PositionSort, ResultPlot.ErrorClass2,'-*k');
set(AX(2),'yColor',[0 0 0]);
ylim([0 1]);
set(AX(2),'YTick',0:0.1:1);
set(AX(2),'YTickLabel',{'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Classificatoin mean square error rate,%')
hold(AX(2),'off');
xlabel('Particle position X(id)')
xlim([1 length(ResultPlot.FeatureLength)]);

legend('E1','E2','FT');

%%  Plot Fittnes history
ResultPlot.Position = Data(1,1).PSO.Particle.History.Position(:,:,1:length(Data(1,1).PSO.Particle.GlobalBest.Position));
ResultPlot.Position = ResultPlot.Position(:);
[ResultPlot.PositionSort ResultPlot.Index] = sort(ResultPlot.Position,'ascend');

ResultPlot.Fitness  = Data(1,1).PSO.Particle.History.Fitness(:,:,1:length(Data(1,1).PSO.Particle.GlobalBest.Position));
ResultPlot.Fitness  = ResultPlot.Fitness(:);
ResultPlot.Fitness  = ResultPlot.Fitness(ResultPlot.Index);
for i = 1:Data(1,1).PSO.Parameters.ParticelSize
    ResultPlot.Error(i,:,:) = Data(1,1).PSO.Particle.History.ClassFitness(1,i,1:length(Data(1,1).PSO.Particle.GlobalBest.Position),:);
end

ResultPlot.ErrorClass1 = ResultPlot.Error(:,:,1);
ResultPlot.ErrorClass1 = ResultPlot.ErrorClass1(:);
ResultPlot.ErrorClass1 = ResultPlot.ErrorClass1(ResultPlot.Index);% in percentage

ResultPlot.ErrorClass2 = ResultPlot.Error(:,:,2);
ResultPlot.ErrorClass2 = ResultPlot.ErrorClass2(:);
ResultPlot.ErrorClass2 = ResultPlot.ErrorClass2(ResultPlot.Index);% in percentage

%       PLot Fitness and error rate
figureW;
[AX, H1, H2] = plotyy(ResultPlot.PositionSort,ResultPlot.Fitness,ResultPlot.PositionSort, ResultPlot.ErrorClass1,'plot');

hold(AX(1),'on');
axes(AX(1));
cla(AX(1));
plot(ResultPlot.PositionSort,ResultPlot.Fitness,'k');
set(AX(1),'XColor',[0 0 0]);
set(AX(1),'yColor',[0 0 0]);
ylim([0 1]);
set(AX(1),'YTick',0:0.1:1);
ylabel('Swarm fitness value (FT)')
xlim([1 length(ResultPlot.FeatureLength)]);

hold(AX(2),'on');
axes(AX(2));
cla(AX(2));
plot(ResultPlot.PositionSort, ResultPlot.ErrorClass1,'-.k');
plot(ResultPlot.PositionSort, ResultPlot.ErrorClass2,'-*k');
set(AX(2),'yColor',[0 0 0]);
ylim([0 1]);
set(AX(2),'YTick',0:0.1:1);
set(AX(2),'YTickLabel',{'0','10','20','30','40','50','60','70','80','90','100'});
ylabel('Classificatoin mean square error rate,%')
hold(AX(2),'off');
xlabel('Particle position X(id)')
xlim([1 length(ResultPlot.FeatureLength)]);

legend('E1','E2','FT');

%%  Data2: Classification with number of traning data

ResultPlot.TrailError =  100.*Data2(1,1).ErrorRate;
figureW;
plot(Data2(1,1).Trial,ResultPlot.TrailError(:,1),'k','LineWidth',1.5);
hold on;
plot(Data2(1,1).Trial,ResultPlot.TrailError(:,2),'--k','LineWidth',1.5);
axis([min(Data2(1,1).Trial) max(Data2(1,1).Trial) 0 30]);
xlabel('Number of traning data');
ylabel('Classificatoin mean square error rate,%');
grid on;
legend('E1','E2');



for i = 1:length(Data)
    ResultPlot.ErrorMean(i,:)           = mean(Data2(1,i).ErrorRate,1);
    for k = 1:min(size(Data2(1,i).ErrorRate))
         ResultPlot.ErrorLow(i,k)       = min(Data2(1,i).ErrorRate(:,k));
         ResultPlot.ErrorUp(i,k)        = max(Data2(1,i).ErrorRate(:,k));
    end   
end

ResultPlot.ErrorMean    = 100.*ResultPlot.ErrorMean;
ResultPlot.ErrorLow     = 100.*ResultPlot.ErrorLow;
ResultPlot.ErrorUp      = 100.*ResultPlot.ErrorUp;
x1 = 1:1:length(Data);
x2 = 1.2:1:length(Data)+0.2;
ResultPlot.ErrorLow = ResultPlot.ErrorMean  - ResultPlot.ErrorLow;
ResultPlot.ErrorUp  = ResultPlot.ErrorUp    - ResultPlot.ErrorMean;

figureW
errorbar(x1,ResultPlot.ErrorMean(:,1),ResultPlot.ErrorLow(:,1),ResultPlot.ErrorUp(:,1),'ok','LineWidth',2);
hold on;
errorbar(x2,ResultPlot.ErrorMean(:,2),ResultPlot.ErrorLow(:,2),ResultPlot.ErrorUp(:,2),'*k','LineWidth',2);
set(gca,'XTick',1.1:1:length(Data)+0.1,...
    'XTickLabel',{'aa','al','av','aw','ay','a','b','f','g'});
axis([0 10 0 100]);
xlabel('Subject');
ylabel('Classificatoin mean square error rate,%');
grid on;
legend('E1','E2');



%%  Classification error rate

for i = 1:length(Data)
    ResultPlot.StopIteration(i) = length(Data(1,i).PSO.Particle.GlobalBest.Fitness);
    ResultPlot.BestPosition(i)  = Data(1,i).PSO.Particle.GlobalBest.Position(length(Data(1,i).PSO.Particle.GlobalBest.Position));
    ResultPlot.BestFitness(i)   = Data(1,i).PSO.Particle.GlobalBest.Fitness(length(Data(1,i).PSO.Particle.GlobalBest.Fitness));
    ResultPlot.BestClassError(i,:)    = 100*Data(1,i).PSO.Particle.History.ClassFitness(1, Data(1,i).PSO.Particle.GlobalBest.Index,length(Data(1,i).PSO.Particle.GlobalBest.Position),:);
end

ErrorRate = ResultPlot.BestClassError;

%   Make bar plot of error rate
figureW;
bar(ErrorRate,1,'LineWidth',2);
set(gca,'XTick',1:9,...
    'XTickLabel',{'aa','al','av','aw','ay','a','b','f','g'});
axis([0 10 0 15]);
grid on;
xlabel('Subject');
ylabel('Classification mean square error rate,%');
legend('E1','E2');







