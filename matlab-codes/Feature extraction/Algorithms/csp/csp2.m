%X=s(1:2000,1:2);
%Y=s(2001:4000,1:2);
%csp test
%number of samples
N=1000;
%number of channels
K=3;
t=linspace(0,1,N);
fs=200;



x1=sin(2*100*pi*t);
x2=sin(2*100*pi*t)+.1*(max(x1)-min(x1))*rand;
x3=sin(2*100*pi*t)+.2*(max(x1)-min(x1))*rand;
x4=sin(2*100*pi*t)+.3*(max(x1)-min(x1))*rand;
x5=sin(2*100*pi*t)+.4*(max(x1)-min(x1))*rand;
x6=sin(2*100*pi*t)+.5*(max(x1)-min(x1))*rand;
x7=sin(2*100*pi*t)+.6*(max(x1)-min(x1))*rand;
x8=sin(2*100*pi*t)+.7*(max(x1)-min(x1))*rand;
x9=sin(2*100*pi*t)+.8*(max(x1)-min(x1))*rand;
x10=sin(2*100*pi*t)+.9*(max(x1)-min(x1))*rand;

y1=sin(2*500*pi*t);
y2=sin(2*500*pi*t)+.1*(max(y1)-min(y1))*rand;
y3=sin(2*500*pi*t)+.2*(max(y1)-min(y1))*rand;
y4=sin(2*500*pi*t)+.3*(max(y1)-min(y1))*rand;
y5=sin(2*500*pi*t)+.4*(max(y1)-min(y1))*rand;
y6=sin(2*500*pi*t)+.5*(max(y1)-min(y1))*rand;
y7=sin(2*500*pi*t)+.6*(max(y1)-min(y1))*rand;
y8=sin(2*500*pi*t)+.7*(max(y1)-min(y1))*rand;
y9=sin(2*500*pi*t)+.8*(max(y1)-min(y1))*rand;
y10=sin(2*500*pi*t)+.9*(max(y1)-min(y1))*rand;

X=[x1; x2; x6; x10];
%X=[x1; x2; x6; x10];
%X=[x1; x2; x3; x4; x5; x6; x7; x8; x9; x10];
Rx=(X*X')/trace(X*X');
Y=[y1; y2; y6; y10];
%Y=[y1; y2; y6; y10];
%Y=[y1; y4; y3; y4; y5; y6; y7; y8; y9; y10];
Ry=(Y*Y')/trace(Y*Y');


classtest= horzcat(X,Y);


n=1:length(Rx);
%for o=1:length(Rx), Rx(o,:)=Rx(o,:)./norm(Rx(o,:)); end
%for p=1:length(Ry), Ry(p,:)=Ry(p,:)./norm(Ry(p,:)); end
Rx=mean(Rx,3);
Ry=mean(Ry,3);
R=(Rx+Ry);
[U,Lambda] = eig(R);
[Lambda,ind] = sort(diag(Lambda),'descend');
U=U(:,ind);
P=sqrt(inv(diag(Lambda)))*U';
S{1}=P*Rx*P';
S{2}=P*Ry*P';
[B,G] = eig(S{1},S{2}); 
[G,ind] = sort(diag(G)); 
B = B(:,ind);
W=(B'*P);
for i=1:length(ind), W(i,:)=W(i,:)./norm(W(i,:)); end
%A could be used for reconstructing original EEG, as shown in reference
%[7] in citations
A=pinv(W);

%filtered and projected EEGs
Z1=W*X;
Z2=W*Y;

%Checking feature: checking variance of filtered signal. If CSP worked,
%variance should be lowest in the first column of each matrix
b11=std(X(1,:))
b12=std(X(2,:))
b13=std(X(3,:))
b14=std(X(4,:))

b21=std(Y(1,:))
b22=std(Y(2,:))
b23=std(Y(3,:))
b24=std(Y(4,:))

%after spatial filtering
c11=std(Z1(1,:))
c12=std(Z1(2,:))
c13=std(Z1(3,:))
c14=std(Z1(4,:))

c21=std(Z2(1,:))
c22=std(Z2(2,:))
c23=std(Z2(3,:))
c24=std(Z2(4,:))

%a=[b11 b12 b21 b22; c11 c12 c21 c22]
a=[b11 b12 b13 b14 b21 b22 b23 b24; c11 c12 c13 c14 c21 c22 c23 c24]

