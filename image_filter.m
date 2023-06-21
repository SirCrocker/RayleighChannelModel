% Definir la ruta de la carpeta "PLOTS"
folder_path = './PLOTS';

% Crear las carpetas para cada escenario
for escenario = 1:9
    % Crear el nombre de la carpeta
    carpeta_escenario = fullfile(folder_path, ['Escenario_', num2str(escenario)]);
    
    % Verificar si la carpeta ya existe, de lo contrario, crearla
    if ~isfolder(carpeta_escenario)
        mkdir(carpeta_escenario);
    end
    
    % Filtrar y copiar los archivos correspondientes al escenario
    patron_titulo = ['SCENE_', num2str(escenario)];
    archivos = dir(fullfile(folder_path, '*.png'));
    for i = 1:length(archivos)
        nombre_archivo = archivos(i).name;
        if contains(nombre_archivo, patron_titulo)
            copyfile(fullfile(folder_path, nombre_archivo), carpeta_escenario);
        end
    end
end


% Crear las carpetas para cada piloto
pilotos = [5, 10, 20];
for i = 1:length(pilotos)
    % Crear el nombre de la carpeta
    carpeta_piloto = fullfile(folder_path, ['Piloto_', num2str(pilotos(i))]);
    
    % Verificar si la carpeta ya existe, de lo contrario, crearla
    if ~isfolder(carpeta_piloto)
        mkdir(carpeta_piloto);
    end
    
    % Filtrar y copiar los archivos correspondientes al piloto
    patron_titulo = ['PILOT_', num2str(pilotos(i))];
    archivos = dir(fullfile(folder_path, '*.png'));
    for j = 1:length(archivos)
        nombre_archivo = archivos(j).name;
        if contains(nombre_archivo, patron_titulo)
            copyfile(fullfile(folder_path, nombre_archivo), carpeta_piloto);
        end
    end
end

