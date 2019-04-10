%   Plot fisher score

data_input = load('D:\CHUM Pharino Master 2011-2013\Master 2011-2013\Research Paper\Matlab code\Signal processing\Feature extraction\Process\Fisher score fold 1-5.mat');
data_input = data_input.data_input;

score       = data_input{18};
c3_score    = score(:,:,27);
cz_score    = score(:,:,29);
c4_score    = score(:,:,31);
time        = data_input{19};
freq        = sort(data_input{20},'descend');
score_min   = min(min(min(score)));
score_max   = 2.5e5;
% score_max   = max(max(max(score)));
% 
colormap(jet);
surf(time,freq,c3_score,'edgecolor','none');
axis tight; 
caxis([score_min score_max]);
colorbar();
view(0,90);
xlabel('Time (seconds)'); 
ylabel('Frequency(Hz)');
title('Fisher score over channel C3 features');

figure
colormap(jet);
surf(time,freq,cz_score,'edgecolor','none');
axis tight; 
caxis([score_min score_max]);
colorbar();
view(0,90);
xlabel('Time(seconds)'); 
ylabel('Frequency(Hz)');
title('Fisher score over channel Cz features');

figure
colormap(jet);
surf(time,freq,c4_score,'edgecolor','none');
axis tight; 
caxis([score_min score_max]);
colorbar();
view(0,90);
xlabel('Time (seconds)'); 
ylabel('Frequency(Hz)');
title('Fisher score over channel C4 features');
