clc;
clear;
close all
%% Inicialización
% Constelaciones
% TODO: ARREGLAR LAS FIGURAS !!!!!!!

modulation = "QPSK";
n_pilots=10; % Separación de símbolos piloto
scene = {0, 50, 3e10, 3.6};
montecarlo_number = 1;
graph_const = true;

SNR_list = [-5, 0, 10, 30];
n_bits = 1e5 + 8; % Número de bits

pilot_symbol=1+1i; % Símbolo piloto

rate_fft = zeros(montecarlo_number, length(SNR_list)); % BER para fft
rate_spline = zeros(montecarlo_number, length(SNR_list)); % BER para spline
rate_linear = zeros(montecarlo_number, length(SNR_list)); % BER para linear
rate_pchip = zeros(montecarlo_number, length(SNR_list)); % BER pchip
rate_perfect = zeros(montecarlo_number, length(SNR_list)); % BER perfect

%% Transmisor
for iter = 1:montecarlo_number
    
    bits_list = GenerateBits(n_bits); % Bits generados aleatoriamente
    modulated_symbols = Modulate(bits_list, modulation); % Símbolos generados según modulación
    n_symbols = length(modulated_symbols); % Número de símbolos
    
    % Insertar señales piloto
    tx_pilots = insertPilot(modulated_symbols, pilot_symbol, n_pilots);
    len=length(tx_pilots);
    scene{1} = len;
    
    % Obtener los coeficientes de canal
    channel_coefs = create_channel(scene{:});
    
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
        
        QAM_noise=TX_signal;
        figure
        plot(real(QAM_noise),imag(QAM_noise),'x');
        title(modulation + " AFFECTED WITH NOISE");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        
        figure
        plot(real(tx_channel),imag(tx_channel),'r.');
        title(modulation + " AFFECTED WITH RAYLEIGH FADING");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        
        figure
        plot(real(RX_signal),imag(RX_signal),'r.');
        title(modulation + " PLOT WITH NOISE AND RAYLEIGH FADING");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        
        figure
        plot(real(RX_fft),imag(RX_fft),'r.');
        hold on;
        plot(real(modulated_symbols),imag(modulated_symbols),'o');
        grid on;
        title(modulation + " PLOT");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        legend('PLOT AT RX con Ecualización con interpolación FFT','PLOT AT TX' );

        figure
        plot(real(RX_spline),imag(RX_spline),'r.');
        hold on;
        plot(real(modulated_symbols),imag(modulated_symbols),'o');
        grid on;
        title(modulation + " PLOT");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        legend('PLOT AT RX con Ecualización con interpolación CUBIC SPLINE','PLOT AT TX' );

        figure
        plot(real(RX_linear),imag(RX_linear),'r.');
        hold on;
        plot(real(modulated_symbols),imag(modulated_symbols),'o');
        grid on;
        title(modulation + " PLOT");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        legend('PLOT AT RX con Ecualización con interpolación LINEAR','PLOT AT TX' );

        figure
        plot(real(RX_pchip),imag(RX_pchip),'r.');
        hold on;
        plot(real(modulated_symbols),imag(modulated_symbols),'o');
        grid on;
        title(modulation + " PLOT");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        legend('PLOT AT RX con Ecualización con interpolación CUBIC PCHIP','PLOT AT TX' );

        figure
        plot(real(RX_perfect),imag(RX_perfect),'r.');
        hold on;
        plot(real(modulated_symbols),imag(modulated_symbols),'o');
        grid on;
        title(modulation + " PLOT");
        xlabel('REAL(DATA)');
        ylabel('IMG(DATA)');
        legend('PLOT AT RX con Ecualización con interpolación PERFECT','PLOT AT TX' );

    end
end
