% RAYLEIGH FADING SIMULATION - Comunicaciones Digitales Avanzadas Otoño 2023
% Agustín González - Diego Torreblanca - Luciano Vidal
% ----------------------------------------------------
% Script que grafica las constelaciones
% Se limpia y cierra todo antes de ejecutar
clc;
clear;
close all

%% Inicialización
% Constelaciones

folder_name = "./CONST";

% Modulación a simular (opciones: 16QAM, 8PSK, QPSK)
modulation = "8PSK";
if ~isfolder(folder_name)
    mkdir(folder_name);
end

n_pilots=5;                 % Separación de símbolos piloto
scene = {0, 5, 80, 700e6};  % Escenario a simular
SNR_list = [-5, 0, 10, 30]; % SNR a simular
n_bits = 1e5 + 8;           % Número de bits
pilot_symbol=1+1i;          % Símbolo piloto
 
bits_list = GenerateBits(n_bits);                    % Bits generados aleatoriamente
modulated_symbols = Modulate(bits_list, modulation); % Símbolos generados según modulación
n_symbols = length(modulated_symbols);               % Número de símbolos

% Insertar señales piloto
tx_pilots = insertPilot(modulated_symbols, pilot_symbol, n_pilots);
len=length(tx_pilots);
scene{1} = len;

% Obtener los coeficientes de canal
channel_coefs = create_channel(scene{:});

% Aplicar efectos del canal a la señal
tx_channel=tx_pilots.*channel_coefs; %Multiplying Rayleigh channel coeficients

%% Constelaciones antes de ser transmitidas

th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);


fig = figure;
plot(real(modulated_symbols),imag(modulated_symbols),'ro');
hold on
plot(xunit, yunit,'b--'); % plot a circle of radius 1
title('Constellation before being transmitted for ' + modulation)
xlabel('Real axis ');
ylabel('Img axis');
xlim([-1.2, 1.2]);
ylim([-1.2, 1.2]);
grid();

filename = 'Constellation_' + modulation;
exportgraphics(fig,fullfile(folder_name, filename + ".png"),'Resolution',300)

%% Constelaciones recibidas con el efecto de ruido AWGN (SNR = -5dB, 0B, 10dB y 30dB)

noise_1=awgn(modulated_symbols,SNR_list(1),'measured','db' );
noise_2=awgn(modulated_symbols,SNR_list(2),'measured','db' );
noise_3=awgn(modulated_symbols,SNR_list(3),'measured','db' );
noise_4=awgn(modulated_symbols,SNR_list(4),'measured','db' );

fig=figure;
subplot(2,2,1)
plot(real(noise_1),imag(noise_1),'r.');
title('SNR = -5 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

subplot(2,2,2)
plot(real(noise_2),imag(noise_2),'r.');
title('SNR = 0 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

subplot(2,2,3)
plot(real(noise_3),imag(noise_3),'r.');
title('SNR = 10 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

subplot(2,2,4)
plot(real(noise_4),imag(noise_4),'r.');
title('SNR = 30 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

sgtitle('Constellations affected by noise for ' + modulation)
filename = 'Constellations_noise_' + modulation;
exportgraphics(fig,fullfile(folder_name, filename + ".png"),'Resolution',300)


%% Constelaciones recibidas con el efecto de ruido AWGN y canal (SNR = -5dB, 0B, 10dB y 30dB)
% Antes de la ecualización

noise_channel_1=awgn(tx_channel,SNR_list(1),'measured','db' );
noise_channel_2=awgn(tx_channel,SNR_list(2),'measured','db' );
noise_channel_3=awgn(tx_channel,SNR_list(3),'measured','db' );
noise_channel_4=awgn(tx_channel,SNR_list(4),'measured','db' );

[rx_pilot_1, rx_signal_1] = separatePilot(noise_channel_1, n_pilots);
[rx_pilot_2, rx_signal_2] = separatePilot(noise_channel_2, n_pilots);
[rx_pilot_3, rx_signal_3] = separatePilot(noise_channel_3, n_pilots);
[rx_pilot_4, rx_signal_4] = separatePilot(noise_channel_4, n_pilots);

fig=figure;

subplot(2,2,1)
plot(real(rx_signal_1),imag(rx_signal_1),'r.');
title('SNR = -5 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

subplot(2,2,2)
plot(real(rx_signal_2),imag(rx_signal_2),'r.');
title('SNR = 0 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

subplot(2,2,3)
plot(real(rx_signal_3),imag(rx_signal_3),'r.');
title('SNR = 10 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

subplot(2,2,4)
plot(real(rx_signal_4),imag(rx_signal_4),'r.');
title('SNR = 30 dB');
xlabel('Real axis ');
ylabel('Img axis');
grid on

sgtitle('Constellations with noise and Rayleigh fading for ' + modulation)
filename = 'Constellations_noise_fading_' + modulation;
exportgraphics(fig,fullfile(folder_name, filename + ".png"),'Resolution',300)

%% Constelaciones recibidas con el efecto de ruido AWGN y canal (SNR = -5dB, 0B, 10dB y 30dB)
% después de la ecualización 

[~, ~ , ~, cubic_1 ] = channel_estimate(rx_pilot_1,pilot_symbol, n_symbols, n_pilots);
[~, ~ , ~, cubic_2 ] = channel_estimate(rx_pilot_2,pilot_symbol, n_symbols, n_pilots);
[~, ~ , ~, cubic_3 ] = channel_estimate(rx_pilot_3,pilot_symbol, n_symbols, n_pilots);
[~, ~ , ~, cubic_4 ] = channel_estimate(rx_pilot_4,pilot_symbol, n_symbols, n_pilots);

RX_1_fft=rx_signal_1./cubic_1; 
RX_2_fft=rx_signal_2./cubic_2; 
RX_3_fft=rx_signal_3./cubic_3; 
RX_4_fft=rx_signal_4./cubic_4; 

fig=figure;
subplot(2,2,1)
plot(real(RX_1_fft),imag(RX_1_fft),'r.'); 
title('SNR = -5 dB');
xlabel('Real axis ');
ylabel('Img axis');
xlim([-20, 20]);
ylim([-20, 20]);
grid on

subplot(2,2,2)
plot(real(RX_2_fft),imag(RX_2_fft),'r.'); 
title('SNR = 0 dB');
xlabel('Real axis ');
ylabel('Img axis');
xlim([-10, 10]);
ylim([-10, 10]);
grid on

subplot(2,2,3)
plot(real(RX_3_fft),imag(RX_3_fft),'r.'); 
title('SNR = 10 dB');
xlabel('Real axis ');
ylabel('Img axis');
xlim([-5, 5]);
ylim([-5, 5]);
grid on

subplot(2,2,4)
plot(real(RX_4_fft),imag(RX_4_fft),'r.'); 
title('SNR = 30 dB');
xlabel('Real axis ');
ylabel('Img axis');
xlim([-2, 2]);
ylim([-2, 2]);
grid on

sgtitle('Constellations with Equalization for ' + modulation)
filename = 'Constellations_eq_' + modulation;
exportgraphics(fig,fullfile(folder_name, filename + ".png"),'Resolution',300)
     
% fin
