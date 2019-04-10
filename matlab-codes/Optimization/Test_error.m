

%%  Load dataset
progressbar;
for i = 1:29
    Process.Data.Main  = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V2\BCICIII_Dataset_IVa_Subject_aa_128Hz_FeatureExtractionV2.mat');
    Process.Data.Temp.Selection = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\2012\Conference\SCTA 2012\Simulation\BCICIII_Dataset_IVa_Subject_aa_128Hz_Result.mat');
    
    display('Creating cross validation data...');
    
    Process.Data.Temp.CrossValidation.FoldNumber        = i+1;
    Process.Data.Temp.CrossValidation.CrossSize         = Process.Data.Main.Information.SignalSize(1);
    [Process.Data.Temp.CrossValidation.IndexTest,...
        Process.Data.Temp.CrossValidation.IndexTrain]   = CrossIndex(...
        Process.Data.Temp.CrossValidation.FoldNumber,...
        Process.Data.Temp.CrossValidation.CrossSize);
    
    Process.Data.Main.Information.CrossValidation       = Process.Data.Temp.CrossValidation;
    Process.Data.Main.Information.SignalSize            = size(Process.Data.Main.Signal);
    
    
    Process.Data.Main.Signal                   = Process.Data.Main.Signal(:,:);
    [Fitness(i), ClassError(i,:)]  = SelectAndEvaluation(...
        'Selection',...
        Process.Data.Temp.Selection.PSO.Particle.GlobalBest.Position(length(Process.Data.Temp.Selection.PSO.Particle.GlobalBest.Position)),...
        Process.Data.Temp.Selection.FisherScore.IndexSort,...
        Process.Data.Temp.Selection.FisherScore.Score,...
        Process.Data.Temp.CrossValidation,...
        Process.Data.Main.Information.class_output,...
        Process.Data.Main.Signal);
    Process.Data                = rmfield(Process.Data,'Temp');
    progressbar(1/29)
end






%%  Prepare data

[Process.Data.Main.Information.FisherScore.ScoreSort, Process.Data.Main.Information.FisherScore.SortIndex] = ...
    sort(Process.Data.Main.Information.FisherScore.Score, 'descend');
%       Create feature vector
Process.Data.Main.Signal                   = Process.Data.Main.Signal(:,:);
Process.Data.Main.Information.SignalSize   = size(Process.Data.Main.Signal);
d = length(Process.Data.Main.Information.FisherScore.ScoreSort);

progressbar;
for i = 1:500:d
    Result(i,:,:) =  evalerr( i,...
        Process.Data.Main.Signal,...
        Process.Data.Main.Information.FisherScore.ScoreSort,...
        Process.Data.Main.Information.FisherScore.SortIndex,...
        Process.Data.Main.Information.CrossValidation,...
        Process.Data.Main.Information.class_output);
    progressbar(i/d);
end

Result  =  evalerr( ...
    Process.Data.Temp.Selection.PSO.Particle.GlobalBest.Position(length(Process.Data.Temp.Selection.PSO.Particle.GlobalBest.Position)),...
    Process.Data.Main.Signal,...
    Process.Data.Main.Information.FisherScore.ScoreSort,...
    Process.Data.Main.Information.FisherScore.SortIndex,...
    Process.Data.Main.Information.CrossValidation,...
    Process.Data.Main.Information.class_output);

%%  -----------------------------------------------------------------------







%   -----------------------------------------------------------------------
Class1Err   = Result(:,6,1);
Class2Err   = Result(:,6,2);
ResultMean  = Result(:,6,3);
index = find(ResultMean ~= 0);
a = min(ResultMean(index))

X1 = Class1Err(index);
X2 = Class2Err(index);

%   Plot Error rate
figureW
hold on;
plot(index,X1,'-k',...
    'LineWidth',2);
plot(index,X2,'-.k',...
    'LineWidth',2);
hold on;
axis([1 7.2e4 0 1])
xlabel('Number of the selected weight[#]');
ylabel('Classification error rate[%]');


for m = 1:length(X1)
    Y(m) = f2class(X1(m),X2(m));
end

%   Plot output fitness
plot(index,Y,'-r');
xlabel('index');
zlabel('Classification fittness function');
legend('Class 1',...
    'Class 2',...
    'Fitness function');








% %%  -----------------------------------------------------------------------
%
% subject(1) = a; number(1) = min(find(ResultMean(index) == a))
%
% subject(2) = a; number(2) = min(find(ResultMean(index) == a))
%
% subject(3) = a; number(3) = min(find(ResultMean(index) == a))
%
% subject(4) = a; number(4) = min(find(ResultMean(index) == a))
%
% subject(5) = a; number(5) = min(find(ResultMean(index) == a))
%
% number = number*100;
%
% C1 = Process.Data.Temp.FisherScore.Data.ClassMean(1,:,:,:);
% C1 = C1(:);
% C2 = Process.Data.Temp.FisherScore.Data.ClassMean(2,:,:,:);
% C2 = C2(:);
% Cmean =( C1 +C2)/2;
% C1 = C1 - Cmean;
% C2 = C2 - Cmean;
%
% plot(C1,C2,'.k');
% axis([-1e-3 1e-3 -1e-3 1e-3]);
% grid on
% xlabel('Centered mean of the class 1 feature');
% ylabel('Centered mean of the class 2 feature');
% title('Centered mean of both class for Fisher score');


