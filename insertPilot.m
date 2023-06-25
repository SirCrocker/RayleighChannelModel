% Insertar piloto
% symbols_array: arreglo de símbolos a enviar (sin pilotos)
% spacing: distancia entre los símbolos pilotos
function [s_n_p] = insertPilot(symbols_array, p_symbol, spacing)
    
    % Necesitamos agregar la piloto cada spacing - 1 símbolos
    len_of_snp = ceil(length(symbols_array) * spacing / (spacing - 1) );
    s_n_p = complex(zeros(1, len_of_snp));
    
    % Indices
    indices = 1:len_of_snp;
    
    % Se insertan los símbolos en la posición correcta
    s_n_p(mod(indices, spacing) == 1) = p_symbol;
    s_n_p(mod(indices, spacing) ~= 1) = symbols_array;

end