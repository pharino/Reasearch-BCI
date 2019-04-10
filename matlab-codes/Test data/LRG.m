%%
clear;
load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Database\Preprocessing data\Preprocessing V2\BCICIII_Dataset_IVa.mat');
A   = Signal.Train(1,2,1,:);
A   = A(:);
T   = A(1:100); 
x   = linspace(0,1,100); 
X   = legendre(5,x,'norm');
Xi  = PSI(X);
%%
W   = T'*Xi;
Y   = W*X; 

%%
figure;
plot(x,T,'b');
hold on;
plot(x,Y,'r');
