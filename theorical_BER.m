% RAYLEIGH FADING SIMULATION - Comunicaciones Digitales Avanzadas Otoño 2023
% Agustín González - Diego Torreblanca - Luciano Vidal
% ----------------------------------------------------

% Calculates and graphs the theoretical BER of the different modulations
clear
close all
clc

% Where the plots are saved
folder = "./PLOTS/";
if ~isfolder(folder)
    mkdir(folder);
end

% SNR
SNRdB = -2:0.01:30; % dB
SNR = 10.^(SNRdB/10); % lineal

% Ref: Control Engineering in Robotics and Industrial Automation Malaysian 
% Society for Automatic Control Engineers (MACE) Technical Series 2018
% Chapter: BER Performance Evaluation of M-PSK and M-QAM Schemes in AWGN, 
% Rayleigh and Rician Fading Channels
% eqs. (5) and (8) from p. 259

% QPSK
aux_QPSK = 4 * SNR * sin(pi/4)^2;
BER_QPSK = (1/2)*(1-sqrt((aux_QPSK)./(2+aux_QPSK)));

% 8PSK
aux_8PSK = 6 * SNR * sin(pi/8)^2;
BER_8PSK = (1/3)*(1-sqrt((aux_8PSK)./(2+aux_8PSK)));

% 16QAM
aux_16QAM = (4/5) * SNR;
BER_16QAM = 3/8*(1-sqrt((aux_16QAM)./(2+aux_16QAM)));

fig=figure;
semilogy(SNRdB, BER_QPSK,'b')
hold on
semilogy(SNRdB, BER_8PSK,'r')
semilogy(SNRdB, BER_16QAM,'Color','#00b300')
xlabel("$\frac{E_b}{N_0}$ [dB]", "Interpreter", "latex", 'FontSize', 15)
ylabel("BER", 'FontSize', 15)
xlim([-2,30])
title("Theorical BER in a Rayleigh fading channel")
subtitle("for QPSK, 8PSK and 16QAM")
legend('QPSK','8PSK','16QAM')
grid on

exportgraphics(fig, fullfile(folder, "Theorical_BER"+".png"), 'Resolution', 300)


