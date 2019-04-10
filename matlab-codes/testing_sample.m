%% Load sample data
load('/media/pharino/Research Data/CHUM Pharino Master 2011-2013/Research Paper/EEG Database/Preprocessing data/Preprocessing V4/URIS-RIM-S1-IM1.mat')

%%  CAR
average = mean(Signal,2);

for i = 1:Information.SignalSize(2)
    Signal(:,i,:,:) = Signal(:,i,:,:) - average;
end
%% Get data ready: channel C3(52), 7-14Hz(1),
x       = Signal(:,26,1,:);
x       = permute(x,[4,1,2,3]);
label   = Information.class_output;
r       = 1:Information.fs;
k       = Information.fs*1;% 1s before stimuli
plot_option = true;

%% 
y1 = erd_ers(x,r(1),k,label,plot_option);

%%  ERD/ERS 
for i  = 1:length(r)
    y2(:,:,i) = erd_ers(x,r(i),k,label,false);
end

%% Plot ERD/ERS VS reference time
for i = 1:2
    temp = y2(i,:,:);
    temp = permute(temp,[2,3,1]);
    figure(i);
    surf(temp(100:end,:));
    view(0,90);
end



