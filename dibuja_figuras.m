function dibuja_figuras()

%%
close all;
clear all;
clc;


%%
DIR_MED = 'MEDIDAS\';
DIR_SIM = 'SIM\';

load([DIR_MED 'MED.mat']);

%% load simulation data, z =100 mm,  with 9 steps
load([DIR_SIM 'Z_100\SIM.mat']);
SIM_Z_100 = SIM;
clear('SIM');

%% load simulation data, z =150 mm,  with 9 steps
load([DIR_SIM 'Z_150\SIM.mat']);
SIM_Z_150 = SIM;
clear('SIM');

%% load simulation data, z =150 mm,  with 100 steps
load([DIR_SIM 'Z_150\SIM_x_150_100steps.mat']);
SIM_Z_150_100steps = SIM;
clear('SIM');

%% variables definition
IND_F = 5;

IND_DIST = 3;

FREQS = 1e3:1e3:300e3;

sigma = 5.8e7;                                 % conductividad cobre
ns = 150;                                      % numero de hebras
rs = 100e-6;                                   % radio de la hebra

DELTA = sqrt(2./(2*pi*FREQS*4*pi*1e-7*sigma));

%% draw Mutual inductance graphes
figure(1)
plot(1e3*SIM_Z_100.d_x, 1e6*SIM_Z_100.M_TX_RX,'b-');
hold on;
grid on;
%plot(SIM_Z_150.d_x, SIM_Z_150.M_RX_TX,'k-')
plot(1e3*MED.M_100.d(IND_F,:), 1e6*MED.M_100.M(IND_F,:),'bo');

plot(1e3*SIM_Z_150.d_x, 1e6*SIM_Z_150.M_TX_RX,'g-');
plot(1e3*SIM_Z_150_100steps.d_x, 1e6*SIM_Z_150_100steps.M_TX_RX,'g-.');

%plot(SIM_Z_150.d_x, SIM_Z_150.M_RX_TX,'k-')
plot(1e3*MED.M_150.d(IND_F,:), 1e6*MED.M_150.M(IND_F,:),'go');
legend({'theorical M with z = 100 mm', 'experimental M with z = 100 mm', 'theorical M with z = 150 mm (9 steps)','theorical M with z = 150 mm (100 steps)','experimental M with z = 150 mm'},'location','south');
xlabel({"x shift","(mm)"});
ylabel({"Mutual inductance M","(uH)"});
title({"variation of mutual inductance M with the shift in x"});
 
%% draw R graphes
% la resistance de conduction DC ne varie pas avec le shift (diff valeurs
% de LONG_RX. On instancie une fois pour chaque fréquence balayé.
R_cond_RX = ones(size(FREQS))*SIM_Z_150.LONG_RX(1,IND_DIST)/(ns*sigma*pi*rs^2);
R_prox_RX = ns*(2*pi/sigma)*(rs./DELTA).^4.*(SIM_Z_150.H02_RX(1,IND_DIST)./SIM_Z_150.I_RX(1,IND_DIST)^2);

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