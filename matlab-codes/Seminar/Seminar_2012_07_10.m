%%   Plot mean and std of the feature

%       Class 1
Seminar.Temp.ClassMean  = Process.Data.Temp.FisherScore.Data.ClassMean(1,:);
subplot(2,2,1)
plot(Seminar.Temp.ClassMean');
axis([1 72570 0 7e-3]);
xlabel('Vector of features');
ylabel('Mean amplitude of the features');
title('Mean feature vector for class 1(right hand) ');

Seminar.Temp.ClassSTD   = Process.Data.Temp.FisherScore.Data.ClassSTD(1,:);
subplot(2,2,3)
plot(Seminar.Temp.ClassSTD');
axis([1 72570 0 0.015]);
xlabel('Vector of features');
ylabel('std of the features');
title('Standard deviation of feature vector for class 1(right hand) ');

%       Class 2
Seminar.Temp.ClassMean = Process.Data.Temp.FisherScore.Data.ClassMean(2,:);
subplot(2,2,2)
plot(Seminar.Temp.ClassMean');
axis([1 72570 0 7e-3]);
xlabel('Vector of features');
ylabel('Mean amplitude of the features');
title('Mean feature vector for class 2(right foot) ');

Seminar.Temp.ClassSTD   = Process.Data.Temp.FisherScore.Data.ClassSTD(2,:);
subplot(2,2,4)
plot(Seminar.Temp.ClassSTD');
axis([1 72570 0 0.015]);
xlabel('Vector of features');
ylabel('std of the features');
title('Standard deviation of feature vector for class 2(right foot) ');

%%  Plot 

load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V2\BCICIII_Dataset_IVa_aa_128Hz_FeatureExtraction.mat')
aa = Information.FisherScore.Score;

load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V2\BCICIII_Dataset_IVa_al_128Hz_FeatureExtraction.mat')
al = Information.FisherScore.Score;

load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V2\BCICIII_Dataset_IVa_av_128Hz_FeatureExtraction.mat')
av = Information.FisherScore.Score;

load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V2\BCICIII_Dataset_IVa_aw_128Hz_FeatureExtraction.mat')
aw = Information.FisherScore.Score;

load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V2\BCICIII_Dataset_IVa_ay_128Hz_FeatureExtraction.mat')
ay = Information.FisherScore.Score;




subplot(5,1,1);
plot(aa);
axis([1 72570 0 4e7]);
xlabel('Features[#]');
ylabel('Fisher score[#]');
title('Fisher score of feature for subject aa');

subplot(5,1,2);
plot(al);
axis([1 72570 0 4e7]);
xlabel('Features[#]');
ylabel('Fisher score[#]');
title('Fisher score of feature for subject al');


subplot(5,1,3);
plot(av);
axis([1 72570 0 4e7]);
xlabel('Features[#]');
ylabel('Fisher score[#]');
title('Fisher score of feature for subject av');


subplot(5,1,4);
plot(aw);
axis([1 72570 0 4e7]);
xlabel('Features[#]');
ylabel('Fisher score[#]');
title('Fisher score of feature for subject aw');


subplot(5,1,5);
plot(ay);
axis([1 72570 0 4e7]);
xlabel('Features[#]');
ylabel('Fisher score[#]');
title('Fisher score of feature for subject ay');











