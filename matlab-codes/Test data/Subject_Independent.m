clear all;
load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Feature Extraction data\Feature Extraction V1\BCICIII_Dataset_IVa.mat');

x = Signal.Train(:,:,1);
X = x(:,[27,29,31]);


c1 = find(Information.ClassLabel.Train == 1);
c2 = find(Information.ClassLabel.Train == -1);

subplot(3,1,1);
plot(X(c1,1),'.r');
hold on;
plot(X(c2,1),'.b');
hold off;
% axis([-5 5, -5 5]);
xlabel('C_3');
ylabel('Power band feature');
title('\alpha')


subplot(3,1,2);
plot(X(c1,2),'.r');
hold on;
plot(X(c2,2),'.b');
hold off;
% axis([-5 5, -5 5]);
xlabel('C_z');
ylabel('Power band feature');
title('\beta')


subplot(3,1,3);
plot(X(c1,3),'.r');
hold on;
plot(X(c2,3),'.b');
hold off;
% axis([-5 5, -5 5]);
xlabel('C_4');
ylabel('Power band feature');
title('7-30Hz')


