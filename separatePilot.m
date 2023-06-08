% Remover pilotos
function [pilot_rec, symbol_rec] = separatePilot(all_symbols, spacing)

    indices = 1:length(all_symbols);

    pilot_rec = all_symbols(mod(indices, spacing) == 1);
    symbol_rec = all_symbols(mod(indices, spacing) ~= 1);

end