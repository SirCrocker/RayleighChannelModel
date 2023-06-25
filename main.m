% RAYLEIGH FADING SIMULATION - Comunicaciones Digitales Avanzadas Otoño 2023
% Agustín González - Diego Torreblanca - Luciano Vidal
% ----------------------------------------------------

% Distancia entre símbolos pilotos
pilotos = [5,10,20];

% Escenarios a simular
% Placeholder | Número de paths | Velocidad del movil | frecuencia central de la portadora
Scenes = {};
Scenes{1} = {0, 5, 80, 700e6};
Scenes{2} = {0, 40, 80, 700e6};
Scenes{3} = {0, 5, 30, 700e6};
Scenes{4} = {0, 40, 30, 700e6};
Scenes{5} = {0, 5, 80, 5.9e9};
Scenes{6} = {0, 40, 80, 5.9e9};
Scenes{7} = {0, 5, 30, 5.9e9};
Scenes{8} = {0, 40, 30, 5.9e9};
Scenes{9} = {0};

% Modulaciones posibles "QPSK", "8PSK" or "16QAM"
modulation = "QPSK";
folder_name = "./DATA";
folder_plots = "./PLOTS/";

% Crea las carpetas donde se guardarán los datos
if ~isfolder(folder_name)
    mkdir(folder_name);
end

if ~isfolder(folder_plots)
    mkdir(folder_plots);
end

%% Calcular BER
% Usa procesamiento en paralelo (se necesita más de 1 núcleo en el PC)
parfor n_scene = 1:9
    scene = Scenes{n_scene};
    for n_pilots = pilotos
        filename = modulation + "_PILOT_" + num2str(n_pilots) + "_SCENE_" + num2str(n_scene) + ".mat";
        fullpath = fullfile(folder_name, filename);

        [BER_fft, BER_spline, BER_linear, BER_pchip, BER_perfect] = scenarioBER(modulation, scene, n_pilots);
        parsave(fullpath, BER_perfect, BER_pchip, BER_linear, BER_spline, BER_fft);
    end
    
end

%% Gráficar resultados (curvas BER)
SNR_list = -2:1:30;
for n_pilots = pilotos
    
    fig = figure('Visible', 'off', 'Position', [0, 0, 1000, 900]);

    for n_scene = 1:9

        filename = modulation + "_PILOT_" + num2str(n_pilots) + "_SCENE_" + num2str(n_scene);
        fullpath = fullfile(folder_name, filename + ".mat");

        data = load(fullpath);
        BER_fft = data.fft;
        BER_spline = data.spline;
        BER_pchip = data.pchip;
        BER_linear = data.linear;
        BER_perfect = data.perfect;

        subplot(3,3, n_scene)
        semilogy(SNR_list,BER_fft,'b-',SNR_list,BER_spline,'r-' ...
            ,SNR_list,BER_linear,'k-',SNR_list,BER_pchip,'g-',SNR_list,BER_perfect,'m-');
        title("Scenario " + num2str(n_scene), 'FontSize', 20)
        xlim([-2, 30]);
        grid on

        if n_scene == 4
            ylabel("BER", 'FontSize', 24)
        end

        if n_scene == 8
            xlabel("$\frac{E_b}{N_0}$ [dB]", "Interpreter", "latex", 'FontSize', 24)
        end
        
    end
    sgtitle(modulation + "  -  BER curves for pilot distance = " + num2str(n_pilots), 'FontSize', 24)
    exportgraphics(fig, fullfile(folder_plots, modulation + "_PILOT_" + num2str(n_pilots) + "_ALLSCENES" + ".png"), 'Resolution', 300)
    close
end


%% Funciones auxiliares
% Guarda los datos obtenidos, se necesita al trabajar con 'parfor'
function parsave(fname, perfect, pchip, linear, spline, fft)
  save(fname, 'perfect', 'pchip', 'linear', 'spline', 'fft')
end
