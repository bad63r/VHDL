% Specification of PSDS project
%-------------------------------

% Audio_sig is variable into which signal will be loaded and fs is sample frequency of audio signal
[audio_sig,fs] = audioread('/home/bad63r/Projects/matlab/proba.wav');
ch1 = audio_sig(:, 1);
ch2 = audio_sig(:, 2);
% Time
% This is delta time between two samples.
dt = 1/fs;
% This is how we can define time now.
t1 = 0:dt:(length(ch1)-1)*dt;
t2 = 0:dt:(length(ch2)-1)*dt;

% First graph - ch1
subplot(2,1,1)
plot(t1,ch1,'g');
title('channel 1');
xlabel('time');
ylabel('amplitude');

% Second graph - ch2
subplot(2,1,2)
plot(t2,ch2,'r');
title('channel 2');
xlabel('time');
ylabel('amplitude');
hold on;

% FFT


