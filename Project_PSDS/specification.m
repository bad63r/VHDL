%specifikacija projekta iz PSDS

%definisanje frekfencije odabiranja

% This is unnecessary, wavread will return that
% fs = 22050;
%ucitavanje signala test.wav u promenjivu uzorak
[uzorak,fs] = wavread('test.wav');
ch1 = uzorak(:, 1);
ch2 = uzorak(:, 2);
%grafik signala
%vreme
% t=0:0.00001:300;
% This is delta time between two samples.
dt = 1/fs;
% This is how we can define time now.
t = 0:dt:(length(ch1)-1)*dt;
plot(t,ch1,'k')
hold on;
