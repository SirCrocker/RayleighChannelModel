%% Coeficientes del canal con Rayleigh Fading
% Genera los coeficientes para el canal modelado como Rayleigh Fading.
% 
% Si se reciben 4 argumentos, se utiliza de la siguiente forma.
% channel_coeffs=create_channel(n_coeffs, paths, f_c, speed)
% n_coeffs: cantidad de coeficientes a generar
% paths: numero de paths o reflexiones
% f_c: frecuencia de la portadora
% speed: velocidad del móvil en km/h
% 
% Si solamente se le entrega un argumento, se modelará como un
% canal multipath Rayleigh multiplicativo (infinitos paths) usando
% channel_coeffs=create_channel(n_coeffs)

function channel_coeffs=create_channel(varargin)
    if nargin == 0
        error('Not enough input arguments.')
    elseif nargin == 1
        % Canal multipath Rayleigh multiplicativo (infinitos paths)
        n_coeffs = varargin{1};
        channel_coeffs = (randn( 1, n_coeffs) + 1i*randn(1, n_coeffs ))*sqrt(1/2);
    elseif nargin == 4
        % Rayleigh Fading
        n_coeffs = varargin{1};
        paths = varargin{2};
        f_c = varargin{3};
        speed = varargin{4};
        lambda = 3e8/f_c; %longitud de onda de la portadora
        v = speed/3.6; %velocidad del móvil UE m/s
        fmax = v/lambda; % Max doppler shift
        A=1; % Amplitude
        f=1e4; % Frecuencia de muestreo
        % Tiempo ajustado para que los gráficos se vean bien
        last_time = 10^(log10(f)-4)*((n_coeffs/f)-(1/f));
        t = linspace(0,last_time,n_coeffs);
        ct=zeros(1,n_coeffs);
        ph=2*pi* rand(1,paths);
        theta=2*pi*rand(1,paths);
        fd=fmax*cos(theta); %doppler shift
        for k=1:paths
        ct=ct+A*exp(1i*(2*pi*fd(k)*t+ph(k)));
        end
        channel_coeffs=ct/sqrt(paths); % Coeficientes del canal
    else
        error(['Se recibieron ', num2str(nargin), ' argumentos. Solamente se puede ingresar 1 argumento para ' ...
            'Canal multipath Rayleigh multiplicativo (infinitos paths) o 4 argumentos para Rayleigh Fading.']);
    end
end