pilotos = [5,10,20];

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

modulation = "QPSK";
folder_name = "./DATA";

%% Calculate BER

parfor n_scene = 1:9
    scene = Scenes{n_scene};
    for n_pilots = pilotos
        filename = modulation + "_PILOT_" + num2str(n_pilots) + "_SCENE_" + num2str(n_scene) + ".mat";
        fullpath = fullfile(folder_name, filename);

        [BER_fft, BER_spline, BER_linear, BER_pchip, BER_perfect] = scenarioBER(modulation, scene, n_pilots);
        parsave(fullpath, BER_perfect, BER_pchip, BER_linear, BER_spline, BER_fft);
    end
    
end

%% Graph
SNR_list = -2:1:30;
for n_scene = 1:9
    for n_pilots = pilotos
        
        filename = modulation + "_PILOT_" + num2str(n_pilots) + "_SCENE_" + num2str(n_scene);
        fullpath = fullfile(folder_name, filename + ".mat");

        data = load(fullpath);
        BER_fft = data.fft;
        BER_spline = data.spline;
        BER_pchip = data.pchip;
        BER_linear = data.linear;
        BER_perfect = data.perfect;

        fig = figure('Visible','off');
        semilogy(SNR_list,BER_fft,'b-',SNR_list,BER_spline,'r-' ...
            ,SNR_list,BER_linear,'k-',SNR_list,BER_pchip,'g-',SNR_list,BER_perfect,'m-');
        legend('fft','cubic spline','linear','cubic','perfect','Location', 'sw');
        title('BER curves for different interpolation techniques');
        subtitle("Modulation: " + modulation +"    Scenario: " + num2str(n_scene) + "    Pilot distance: " + num2str(n_pilots))
        xlabel('SNR in dB');
        ylabel('BER');
        xlim([-2, 30]);
        grid on

        saveas(fig, fullfile("./PLOTS", filename + ".png"))

        close
    end
    
end


%% Function
function parsave(fname, perfect, pchip, linear, spline, fft)
  save(fname, 'perfect', 'pchip', 'linear', 'spline', 'fft')
end
