clc;
clear;
close all
%% Inicialización

modulation = 'QPSK';

SNR_list=-2:1:30;
n_bits = 1e5 + 8; % Número de bits

n_pilots=10; % Separación de símbolos piloto
pilot_symbol=1+1i; % Símbolo piloto

rate_fft = zeros(1, length(SNR_list)); % BER para fft
rate_spline = zeros(1, length(SNR_list)); % BER para spline
rate_linear = zeros(1, length(SNR_list)); % BER para linear
rate_pchip = zeros(1, length(SNR_list)); % BER pchip
rate_perfect = zeros(1, length(SNR_list)); % BER perfect
%% Transmisor

bits_list = GenerateBits(n_bits); % Bits generados aleatoriamente
modulated_symbols = Modulate(bits_list, modulation); % Símbolos generados según modulación
n_symbols = length(modulated_symbols); % Número de símbolos

% Insertar señales piloto
tx_pilots = insertPilot(modulated_symbols, pilot_symbol, n_pilots);
len=length(tx_pilots);

% Obtener los coeficientes de canal
channel_coefs = create_channel(len, 50, 3e10, 3.6);

% Aplicar efectos del canal a la señal
tx_channel=tx_pilots.*channel_coefs; %Multiplying Rayleigh channel coeficients
 
for snr=1:length(SNR_list)
    % Agregar AWGN
    TX_signal=awgn(tx_channel,SNR_list(snr),'measured','db' );
    
    % Recibir la señal completa y separar los símbolos piloto
    [RX_pilots, RX_signal] = separatePilot(TX_signal, n_pilots);
    
    % Interpolaciones
    [ch_fft, ch_spline,ch_linear, ch_pchip] = channel_estimate(RX_pilots,pilot_symbol, n_symbols, n_pilots);
    
    [~, channel_coefs_symbols] = separatePilot(channel_coefs, n_pilots);

    % Ecualización ZF
    RX_fft=RX_signal./ch_fft;
    RX_spline=RX_signal./ch_spline;
    RX_linear=RX_signal./ch_linear;
    RX_pchip=RX_signal./ch_pchip;
    RX_perfect = RX_signal./channel_coefs_symbols;
    
    % Demodulación de la señal
    demod_fft=Demodulate(RX_fft,modulation);
    demod_spline=Demodulate(RX_spline,modulation);
    demod_linear=Demodulate(RX_linear,modulation);
    demod_pchip=Demodulate(RX_pchip,modulation);
    demod_perfect=Demodulate(RX_perfect,modulation);
    
    % Cálculo de BER según SNR
    [~,rate_fft(snr)]=biterr(bits_list,demod_fft); 
    [~,rate_spline(snr)]=biterr(bits_list,demod_spline); 
    [~,rate_linear(snr)]=biterr(bits_list,demod_linear); 
    [~,rate_pchip(snr)]=biterr(bits_list,demod_pchip);
    [~,rate_perfect(snr)]=biterr(bits_list,demod_perfect);
end
%% BER plot

figure
semilogy(SNR_list,rate_fft,'b-',SNR_list,rate_spline,'r-' ...
    ,SNR_list,rate_linear,'k-',SNR_list,rate_pchip,'g-',SNR_list,rate_perfect,'m-');
legend('fft','cubic spline','linear','cubic','perfect');
title('BER curves for different interpolation techniques');
xlabel('SNR in dB');
ylabel('BER');
xlim([-2, 30]);
grid on

%% Gráficos 

QAM_noise=awgn(modulated_symbols,15,'measured','db' );
figure
plot(real(QAM_noise),imag(QAM_noise),'x');
title('QAM AFFECTED WITH NOISE');
xlabel('REAL(DATA)');
ylabel('IMG(DATA)');

figure
plot(real(tx_channel),imag(tx_channel),'r.');
title('QAM AFFECTED WITH RAYLEIGH FADING');
xlabel('REAL(DATA)');
ylabel('IMG(DATA)');

figure
plot(real(RX_signal),imag(RX_signal),'r.');
title('QAM PLOT WITH NOISE AND RAYLEIGH FADING');
xlabel('REAL(DATA)');
ylabel('IMG(DATA)');

figure
plot(real(RX_fft),imag(RX_fft),'r.');
hold on;
plot(real(modulated_symbols),imag(modulated_symbols),'o');
grid on;
title('QAM PLOT');
xlabel('REAL(DATA)');
ylabel('IMG(DATA)');
legend('PLOT AT RX con Ecualización con interpolación fft','PLOT AT TX' );
