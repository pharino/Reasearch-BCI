function plot_laplace(x1,x2,fs)
%%   plot_laplace(x1,x2,fs)

T = 1/fs;               % Period
m = length(x1);         % Length of signal  
nT = (0:m-1)*T;         % Time axes
[ spec_X1 frequency1] = fft_dB( x1,fs );
[ spec_X2 frequency2] = fft_dB( x2,fs );
%%  New figure
figure;
%% Plot temporal signal 1
subplot(2,2,1)
plot(nT,x1);
xlim([0 max(nT)]);
ylim([-500 500]);
title('Time domain of original signal');
xlabel('Time(s)');
ylabel('Amplitude(uV)');
%% Plot temporal signal 2
subplot(2,2,3)
plot(nT,x2);
xlim([0 max(nT)]);
ylim([-100 100]);
title('Time domain of signal after applied Laplace filter');
xlabel('Time(s)');
ylabel('Amplitude(uV)');

%% Plot Single side amplitude spectrum 1
subplot(2,2,2)
plot(frequency1,spec_X1);
title('Frequnecy power spectrum of original signal');
xlim([0 100]);
ylim([-150 0]);
xlabel('Frequency(Hz)');
ylabel('Power(dB)');
%% Plot Single side amplitude spectrum 2
subplot(2,2,4)
plot(frequency2,spec_X2);
title('Frequnecy power spectrum of signal after applied Laplace filter ');
xlim([0 100]);
ylim([-150 0]);
xlabel('Frequency(Hz)');
ylabel('Power(dB)');
end