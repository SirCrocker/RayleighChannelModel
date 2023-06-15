%% Estimación del canal
% Genera los coeficientes estimados el canal según la interpolación elegida
% para realizar la ecualización
% rxp: vector de símbolos piloto
% pilot: símbolo piloto definido
% interpolation: interpolación elegida
% nb: cantidad de símbolos
% N: separación de símbolos piloto

function cse = channel_estimate(rxp,pilot,interpolation, nb, N)

    csi=rxp/pilot; % Calculo del csi de la señal piloto
    if strcmp(interpolation,'fft')
        cse=interpft(csi,nb);on
    else
        total_symbols = nb * N / (N-1);
        t1=1:1:total_symbols; % Todos los símbolos
        t2=1:N:total_symbols;% Posiciones de los piloto
        m=1;
        for i=1:N:total_symbols
         t3(m:m+(N-2))=t1( i+1:i+(N-1));% Solo posiciones de símbolos de mensaje
         m=m+(N-1);
        end
        try 
            cse=interp1(t2,csi,t3,interpolation);
        catch
            error('Ingrese una interpolación válida: fft, spline, linear o pchip.')
        end
    end
end