function dibuja_figuras()

%%
close all;
clear all;
clc;


%%
DIR_MED = 'MEDIDAS\';
DIR_SIM = 'SIM\';

load([DIR_MED 'MED.mat']);

load([DIR_SIM 'RX_100\SIM.mat']);
SIM_RX_100 = SIM;
clear('SIM');

load([DIR_SIM 'RX_150\SIM.mat']);
SIM_RX_150 = SIM;
clear('SIM');

IND_F = 5;

IND_DIST = 3;

FREQS = 1e3:1e3:300e3;

sigma = 5.8e7;                                 % conductividad cobre
ns = 150;                                      % numero de hebras
rs = 100e-6;                                   % radio de la hebra

DELTA = sqrt(2./(2*pi*FREQS*4*pi*1e-7*sigma));

%%
figure(1)
subplot(1,2,1);
plot(1e3*SIM_RX_100.d_x, 1e6*SIM_RX_100.M_TX_RX,'b-');
hold on;
grid on;
%plot(SIM_RX_150.d_x, SIM_RX_150.M_RX_TX,'k-')
plot(1e3*MED.L_100.d(IND_F,:), 1e6*MED.M_100.M(IND_F,:),'bo');
legend({'theorical M with z = 100 mm','experimental M with z = 100 mm'});
xlabel({"x shift","(mm)"});
ylabel({"Mutual inductance M","(uH)"});
title({"variation of mutual inductance M with the shift in x","(coils separated with z = 10 cm)"});

subplot(1,2,2);
plot(1e3*SIM_RX_150.d_x, 1e6*SIM_RX_150.M_TX_RX,'b-');
hold on;
grid on;
%plot(SIM_RX_150.d_x, SIM_RX_150.M_RX_TX,'k-')
plot(1e3*MED.M_150.d(IND_F,:), 1e6*MED.M_150.M(IND_F,:),'bo');
legend({'theorical M with z = 150 mm','experimental M with z = 150 mm'});
xlabel({"x shift","(mm)"});
ylabel({"Mutual inductance M","(uH)"});
title({"variation of mutual inductance M with the shift in x","(coils separated with z = 15 cm)"});
 
%%
% la resistance de conduction DC ne varie pas avec le shift (diff valeurs
% de LONG_RX. On instancie une fois pour chaque fréquence balayé.
R_cond_RX = ones(size(FREQS))*SIM_RX_150.LONG_RX(1,IND_DIST)/(ns*sigma*pi*rs^2);
R_prox_RX = ns*(2*pi/sigma)*(rs./DELTA).^4.*(SIM_RX_150.H02_RX(1,IND_DIST)./SIM_RX_150.I_RX(1,IND_DIST)^2);

figure()
%plot(FREQS/1e3, 1e3*R_cond_RX.*R_prox_RX,'k-');
plot(FREQS/1e3, 1e3*(R_cond_RX +R_prox_RX),'k-');
hold on;
grid on;
plot(MED.R_TX.f/1e3, 1e3*MED.R_TX.R_RX,'ko');
xlabel({"frequency","(kHz)"});
ylabel({"Resistance","(mOhm)"});
legend({'theorical R','experimental R'});
title(" variation of R with frequency");
% figure()
% plot(FREQS/1e3, 1e3*R_cond_TX,'k-'); % resistncia cond por simulacion
% hold on;
% grid on;
% plot(MED.R_TX.f/1e3, 1e3*MED.R_TX.R_TX, 'ko');


end