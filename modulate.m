clear
close all
clc

n_bits = 12*100;
modulation = '8PSK';

bits_list = Generate_bits(n_bits);

symbols_list = Modulate(bits_list, modulation);

th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);

figure,plot(real(symbols_list),imag(symbols_list),'x');
hold on
plot(xunit, yunit); % plot a circle of radius 1
title('Symbols');
xlabel('REAL(DATA)');
ylabel('IMG(DATA)');
grid();

function bits_list = Generate_bits(n_bits)
    bits_list = int32(randi([0, 1], [1, n_bits]));
end

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
        symbols_const = [0.9 - 0.9i, -0.9 - 0.9i, 0.9 - 0.3i, -0.9 - 0.3i,...
                          0.9 + 0.3i,  -0.9 + 0.3i, 0.9 + 0.9i,  -0.9 + 0.9i,...  
                          0.3 - 0.9i,  -0.3 - 0.9i,   0.3 - 0.3i,  -0.3 - 0.3i,...
                          0.3 + 0.3i,  -0.3 + 0.3i,   0.3 + 0.9i,  -0.3 + 0.9i];
    end
    
    n_bits = length(bits_list);
    symbols_list = zeros(1,n_bits/len_symbol, 'like', symbols_const(1));

    for i=1:n_bits/len_symbol
        symbols_list(i) = symbols_const(bin2dec(join(string(bits_list(i*len_symbol-(len_symbol-1):i*len_symbol))))+1);
    end

end