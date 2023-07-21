% RAYLEIGH FADING SIMULATION - Comunicaciones Digitales Avanzadas Otoño 2023
% Agustín González - Diego Torreblanca - Luciano Vidal
% Versión con Channel Coding
% ----------------------------------------------------

% Distancia entre símbolos pilotos
pilotos = [5, 10];

% Escenarios a simular
% Placeholder | Número de paths | Velocidad del movil | frecuencia central de la portadora
Scenes = {};
Scenes{1} = {0, 10, 50, 700e6};
Scenes{2} = {0, 10, 50, 2500e6};
Scenes{3} = {0, 10, 50, 5900e6};

% Modulaciones
modulations = ["QPSK", "16QAM"];

% ** Número de escena a simular (1, 2 ó 3) ** 
n_scene = 1;
scene = Scenes{n_scene};

folder_name = fullfile(pwd, "DATA");
folder_plots = fullfile(pwd, "PLOTS");

% Crea las carpetas donde se guardarán los datos
if ~isfolder(folder_name)
    mkdir(folder_name);
end

if ~isfolder(folder_plots)
    mkdir(folder_plots);
end

%% Calcular BER
% Usa procesamiento en paralelo (se necesita más de 1 núcleo en el PC)
parfor modulationum = 1:length(modulations)
    modulation = modulations(modulationum);
    for encodechnl = [false, true]
        for n_pilots = pilotos
            filename = modulation + "_PILOT_" + num2str(n_pilots) + "_SCENE_" + num2str(n_scene) + "_ENCODED_" + num2str(encodechnl) +".mat";
            fullpath = fullfile(folder_name, filename);
    
            [~, ~, BER_linear, ~, BER_perfect] = scenarioBER(modulation, scene, n_pilots, encodechnl);
            parsave(fullpath, BER_perfect, BER_linear);
            disp(filename)
        end
    end
end

%% Gráficar resultados (curvas BER)
SNR_list = -2:1:30;

for modulation = modulations
    fig = figure('Visible', 'off', 'Position', [0, 0, 1000, 450]);
    for n_pilots = pilotos
        data_plot = zeros(33, 4);
        subplot(1, 2, n_pilots/5)
        for encodechnl = [false, true]
            filename = modulation + "_PILOT_" + num2str(n_pilots) + "_SCENE_" + num2str(n_scene) + "_ENCODED_" + num2str(encodechnl);
            fullpath = fullfile(folder_name, filename + ".mat");

            data = load(fullpath);
            BER_linear = data.linear;
            BER_perfect = data.perfect;

            data_plot(:, (encodechnl*2 + 1):(encodechnl*2 + 2)) =[BER_linear', BER_perfect'];

        end
        
        semilogy(SNR_list, data_plot)
        subtitle("Scenario: " + num2str(n_scene) + ",  Pilot distance: " + num2str(n_pilots), 'FontSize', 17)
        xlim([-2, 30]);
        grid on
        legend(["Linear", "Perfect", "Linear Enc.", "Perfect Enc."])
    end
    sgtitle("BER Curves for " + modulation, 'FontSize', 20)
    exportgraphics(fig, fullfile(folder_plots, modulation + "_BOTHPILOTS" + "_SCENE_" + num2str(n_scene) + "_WITHENCDN_" + ".png"), 'Resolution', 300)
end

%% Funciones auxiliares
% Guarda los datos obtenidos, se necesita al trabajar con 'parfor'
function parsave(fname, perfect, linear)
  save(fname, 'perfect', 'linear')
end
