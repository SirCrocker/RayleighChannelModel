function [decoded_bits] = channelDecode(codeword)
%CHANNELDECODE Decodifica la codificación de canal
%   Implementado en función de una codificación de canal Hamming 7,4
    recv_codeword = double(codeword);
    % Para hacer la multiplicación de matrices,
    % tiene que ser double
    len = length(recv_codeword);
    decoded_bits = zeros(1,len*4/7);

    % Matriz de Chequeo de Paridad H
    H = [1,1,1,0,1,0,0;
        1,1,0,1,0,1,0;
        1,0,1,1,0,0,1];

    % Decodificación
    for i=1:len/7

        v = recv_codeword(7*i-6:7*i); % Codeword recibida de largo 7
        syndrome = mod(H * v',2); % Obtener el síndrome
        pos_error = bi2de(fliplr(syndrome')); % Obtener la posición del bit erróneo
        v_invertido = fliplr(v);

        % Si el síndrome es distinto de cero, se puede corregir el
        % error invirtiendo el valor del bit en esa posición
        if pos_error > 0    
            v_invertido(pos_error) = mod(v_invertido(pos_error)+1,2);
        end

        % Reconstruir el mensaje original
        d7 = v_invertido(7);
        d6 = v_invertido(6);
        d5 = v_invertido(5);
        d4 = v_invertido(4);
        decoded_bits(4*i-3:4*i)=int32([d7,d6,d5,d4]);
    end
end

