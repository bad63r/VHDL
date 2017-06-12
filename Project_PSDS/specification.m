%specifikacija projekta iz PSDS

%definisanje frekfencije odabiranja
fs = 22050;
%ucitavanje signala test.wav u promenjivu uzorak
[uzorak,fs] = wavread('test.wav');
%grafik signala
  %vreme
  t=0:0.00001:300;
 plot(t,uzorak,'k')
 hold on;