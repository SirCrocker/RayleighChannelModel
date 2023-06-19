%% Estimación del canal
% Genera los coeficientes estimados del canal según las interpolaciones
% lineal, fft, spline y pchip para realizar la ecualización
% rxp: vector de símbolos piloto
% pilot: símbolo piloto definido
% nb: cantidad de símbolos de mensaje
% N: separación de símbolos piloto

function [fft, spline, linear, pchip] = channel_estimate(rxp,pilot,nb, N)
    csi = rxp/pilot; % Calculo del csi de la señal piloto
    total_symbols = ceil(nb * N / (N-1));
    t1 = 1:1:total_symbols; % Todos los símbolos
    t2 = 1:N:total_symbols; % Posiciones de los símbolos piloto
    t3 = t1(mod(t1, N) ~= 1); % Posiciones de los símbolos de mensaje
    fft = interpft(csi,nb); % interpolación fft
    spline = interp1(t2,csi,t3,'spline'); % interpolación spline (cubic)
    linear = interp1(t2,csi,t3,'linear','extrap'); % interpolación lineal
    pchip = interp1(t2,csi,t3,'pchip'); % interpolación pchip (cubic)
end