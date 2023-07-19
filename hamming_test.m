clc
clear
bits_list = [1,0,1,0,1,1,1,0];
code_func = channelEncode(bits_list);
altered = code_func;
altered(2) = 1;
decoded_bits = channelDecode(altered);

disp(strcat("Mensaje a enviar:     ", num2str(bits_list(1:4))))
disp(strcat("Mensaje codificado:   ", num2str(code_func(1:7))))
disp(strcat("Mensaje recibido:     ", num2str((altered(1:7)))))
disp(strcat("Mensaje decodificado: ", num2str(decoded_bits(1:4))))


%% 
clc
clear
n_bits = 8*1000;
modulation = 'QPSK';
sinr = 8;

bits_list = GenerateBits(n_bits);

code_func = channelEncode(bits_list);

modulated_not_code = Modulate(bits_list, modulation);
modulated_code = Modulate(code_func, modulation);

received_not_code = awgn(modulated_not_code,sinr);
received_code = awgn(modulated_code,sinr);

received_demodulate_not_code=Demodulate(received_not_code,modulation);
received_demodulate_code=Demodulate(received_code,modulation);

decoded_bits = channelDecode(received_demodulate_code);

[~,rate_not_code]=biterr(bits_list,received_demodulate_not_code);
[~,rate_code]=biterr(bits_list,decoded_bits);

disp(strcat("BER sin codificación de Hamming (7,4): ",num2str(rate_not_code)))
disp(strcat("BER con codificación de Hamming (7,4): ",num2str(rate_code)))
