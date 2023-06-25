% Remover pilotos
% all_symbols: arreglo con todos los símbolos recibidos 
% spacing: distancia entre los símbolos pilotos
function [pilot_rec, symbol_rec] = separatePilot(all_symbols, spacing)

    % Indices
    indices = 1:length(all_symbols);

    % Inserta símbolos en la posición correcta
    pilot_rec = all_symbols(mod(indices, spacing) == 1);
    symbol_rec = all_symbols(mod(indices, spacing) ~= 1);

end