% RAYLEIGH FADING SIMULATION - Comunicaciones Digitales Avanzadas Otoño 2023
% Agustín González - Diego Torreblanca - Luciano Vidal
% ----------------------------------------------------

% Demodulate a list of symbols acording to the desired modulation
% symbols_list: array with complex numbers
% mod_type: 'QPSK', '8PSK', '16QAM'
function bits_list = Demodulate(symbols_list, mod_type)

    if isequal(mod_type, 'QPSK')
        bits_list =int32(str2num(reshape(permute(dec2bin(pskdemod(symbols_list,4,[],'gray')), [2, 1]), [], 1))');
        
    elseif isequal(mod_type, '8PSK')
        bits_list =int32(str2num(reshape(permute(dec2bin(pskdemod(symbols_list,8,[],'gray')), [2, 1]), [], 1))');
    
                     
    elseif isequal(mod_type, '16QAM')                    
        symbols_const = [-0.7071 + 0.7071i, -0.2357 + 0.7071i, 0.7071 + 0.7071i, 0.2357 + 0.7071i,...
                         -0.7071 - 0.7071i, -0.2357 - 0.7071i, 0.7071 - 0.7071i, 0.2357 - 0.7071i,...  
                         -0.7071 + 0.2357i, -0.2357 + 0.2357i, 0.7071 + 0.2357i, 0.2357 + 0.2357i,...
                         -0.7071 - 0.2357i, -0.2357 - 0.2357i, 0.7071 - 0.2357i, 0.2357 - 0.2357i];
        bits_list = int32(str2num(reshape(permute(dec2bin(genqamdemod(symbols_list,symbols_const)), [2, 1]), [], 1))');
    end
end