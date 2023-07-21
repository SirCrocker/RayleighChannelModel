% RAYLEIGH FADING SIMULATION - Comunicaciones Digitales Avanzadas Otoño 2023
% Agustín González - Diego Torreblanca - Luciano Vidal
% ----------------------------------------------------

% Función que realiza todo el proceso de simular el canal, ver flujo para entender como funciona.
function [BER_fft, BER_spline, BER_linear, BER_pchip, BER_perfect] = scenarioBER(modulation, scene, n_pilots, coding)
    
    SNR_list=-2:1:30;
    n_bits = 1e5; % Número de bits
    montecarlo_number = 21;

    pilot_symbol=1+1i; % Símbolo piloto
    
    rate_fft = zeros(montecarlo_number, length(SNR_list)); % BER para fft
    rate_spline = zeros(montecarlo_number, length(SNR_list)); % BER para spline
    rate_linear = zeros(montecarlo_number, length(SNR_list)); % BER para linear
    rate_pchip = zeros(montecarlo_number, length(SNR_list)); % BER pchip
    rate_perfect = zeros(montecarlo_number, length(SNR_list)); % BER perfect
    
    % Transmisor
    for iter = 1:montecarlo_number
        
        bits_list = GenerateBits(n_bits); % Bits generados aleatoriamente

        % bloque de codificación de canal con Hamming (7,4)
        if coding
            coded_symbols = channelEncode(bits_list); % Obtener Codewords
            modulated_symbols = Modulate(coded_symbols, modulation); % Símbolos generados según modulación
        else
            modulated_symbols = Modulate(bits_list, modulation); % Símbolos generados según modulación
        end

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
            
            % Demodulación de la señal
            demod_fft=Demodulate(RX_fft,modulation);
            demod_spline=Demodulate(RX_spline,modulation);
            demod_linear=Demodulate(RX_linear,modulation);
            demod_pchip=Demodulate(RX_pchip,modulation);
            demod_perfect=Demodulate(RX_perfect,modulation);
            

            % bloque de decodificación

            if coding
                % Decodificación de codewords y correción de errores
                decoded_fft = channelDecode(demod_fft);
                decoded_spline = channelDecode(demod_spline);
                decoded_linear = channelDecode(demod_linear);
                decoded_pchip = channelDecode(demod_pchip);
                decoded_perfect = channelDecode(demod_perfect);

                % Cálculo de BER según SNR
                [~,rate_fft(iter, snr)]=biterr(bits_list,decoded_fft); 
                [~,rate_spline(iter, snr)]=biterr(bits_list,decoded_spline); 
                [~,rate_linear(iter, snr)]=biterr(bits_list,decoded_linear); 
                [~,rate_pchip(iter, snr)]=biterr(bits_list,decoded_pchip);
                [~,rate_perfect(iter, snr)]=biterr(bits_list,decoded_perfect);

            else
                % Cálculo de BER según SNR
                [~,rate_fft(iter, snr)]=biterr(bits_list,demod_fft); 
                [~,rate_spline(iter, snr)]=biterr(bits_list,demod_spline); 
                [~,rate_linear(iter, snr)]=biterr(bits_list,demod_linear); 
                [~,rate_pchip(iter, snr)]=biterr(bits_list,demod_pchip);
                [~,rate_perfect(iter, snr)]=biterr(bits_list,demod_perfect);
            end
        end
    end
    
    BER_fft = mean(rate_fft);
    BER_spline = mean(rate_spline);
    BER_linear = mean(rate_linear);
    BER_pchip = mean(rate_pchip);
    BER_perfect = mean(rate_perfect);
end
