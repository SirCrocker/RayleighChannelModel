% Modulate a bit list acording to the desired modulation
% bit_list: array with 0,1
% mod_type: 'QPSK', '8PSK', '16QAM'
function symbols_list = Modulate(bits_list, mod_type)

    if isequal(mod_type, 'QPSK')
        len_symbol = 2;
        symbols_const = [1 + 0i, 0 + 1i, 0 - 1i, -1 - 0i];
        
    elseif isequal(mod_type, '8PSK')
        len_symbol = 3;
        symbols_const = [1 + 0i, 0.7071 + 0.7071i, -0.7071 + 0.7071i, 0 + 1i,...
                         0.7071 - 0.7071i,  0 - 1i, -1 + 0i,  -0.7071 - 0.7071i];
                     
    elseif isequal(mod_type, '16QAM')       
        len_symbol = 4;             
        symbols_const = [-0.7071 + 0.7071i, -0.2357 + 0.7071i, 0.7071 + 0.7071i, 0.2357 + 0.7071i,...
                         -0.7071 - 0.7071i, -0.2357 - 0.7071i, 0.7071 - 0.7071i, 0.2357 - 0.7071i,...  
                         -0.7071 + 0.2357i, -0.2357 + 0.2357i, 0.7071 + 0.2357i, 0.2357 + 0.2357i,...
                         -0.7071 - 0.2357i, -0.2357 - 0.2357i, 0.7071 - 0.2357i, 0.2357 - 0.2357i];
    end
    
    n_bits = length(bits_list);
    symbols_list = zeros(1,n_bits/len_symbol, 'like', symbols_const(1));

    for i=1:n_bits/len_symbol
        symbols_list(i) = symbols_const(bin2dec(join(string(bits_list(i*len_symbol-(len_symbol-1):i*len_symbol))))+1);
    end
end