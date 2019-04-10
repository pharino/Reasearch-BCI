%  CSP Function Test
%   Written by James Ethridge and William Weaver
%   
%   This mfile tests the CSP function using a simple two dimentional
%   dataset. It is assumed that CSP.m is in the working directory.


% Generate Five Channel Data to test CSP function

%   Class 1 data has high channel 1
t=[0.01:.01:1];
class1 = [sin(2*pi*20*t);rand(1,100);sin(2*pi*40*t);sin(2*pi*20*t+2);sin(2*pi*40*t+2)];
%   Class 2 data has high channel 2
class2 = [sin(2*pi*30*t);rand(1,100);sin(2*pi*15*t);sin(2*pi*30*t+2);sin(2*pi*15*t+2)];
%   Class 3 data has no high channel
class3 = [rand(1,100)*.5;rand(1,100);rand(1,100)*.5];

[PTranspose] = CSP(class1,class2);

classtrain= horzcat(class1,class2);
%plot5ch(classtrain(1,:),classtrain(2,:),classtrain(3,:),classtrain(4,:),classtrain(5,:));
%make filtered data
train = spatFilt(classtrain,PTranspose,2);
%plot it
%scatter3(classtrain(1,:),classtrain(2,:),classtrain(3,:))

%figure;scatter(train(1,:),train(2,:))


% linear bayes classifier

%make a new set of random data
t=[0.01:.01:1];
class1 = [sin(2*pi*20*t);rand(1,100);sin(2*pi*40*t);sin(2*pi*20*t+2);sin(2*pi*40*t+2)];
%   Class 2 data has high channel 2
class2 = [sin(2*pi*30*t);rand(1,100);sin(2*pi*15*t);sin(2*pi*30*t+2);sin(2*pi*15*t+2)];
%   Class 3 data has no high channel
class3 = [rand(1,100)*.5;rand(1,100);rand(1,100)*.5];
classtest= horzcat(class1,class2);

test = spatFilt(classtest,PTranspose,2);
%plot it
%figure;scatter3(classtest(1,:),classtest(2,:),classtest(3,:))
figure;scatter(test(1,:),test(2,:))

%the target outputs
group = horzcat(ones(1,100),2*ones(1,100));

%test with csp
class = classify(test',train',group');

%test without csp
%class2 = classify(classtest',classtrain',group');

c1=length(find(class == 1))/100
%c2=length(find(class2 == 1))/100
