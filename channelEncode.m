function [codeword] = channelEncode(bits_list)
%CHANNELENCODE Aplica codificación de canal a los bits a enviar
%   Se utiliza Hamming 7,4 para codificar los bits
    msg = double(bits_list);
    % Para hacer la multiplicación de matrices,
    % tiene que ser double
    len = length(msg);
    codeword = zeros(1,len*7/4);

    % Matriz Generadora G
    G = [1,0,0,0,1,1,1;
        0,1,0,0,1,1,0;
        0,0,1,0,1,0,1;
        0,0,0,1,0,1,1];

    % Codificación
    for i=1:len/4
        u = msg(4*i-3:4*i); % Extraer un mensaje de largo 4
        v = mod(u*G,2); % Obtener codeword generada de largo 7
        codeword(7*i-6:7*i) = int32(v);
    end
end

