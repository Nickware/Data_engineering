%% 1. Configuración inicial
clc; clear; close all;  % Limpiar consola, variables y figuras
pkg load io;           % Cargar paquete para manejo de datos
graphics_toolkit('gnuplot');  % Seleccionar motor gráfico

disp('=== ANÁLISIS DE DATOS DEMOGRÁFICOS ===');

%% 2. Importación y preparación de datos
disp('=== 2.1 Carga de datos ===');

% Definir ruta y cargar archivo (ajustar la ruta según necesidad)
filename = 'CargueSIRBEVejez.csv';
try
  data = csv2cell(filename);  % Leer archivo CSV
  headers = data(1,:);       % Extraer encabezados
  data = data(2:end,:);      % Datos sin encabezados
  disp('Datos cargados correctamente');
catch
  error('Error al cargar el archivo. Verifique la ruta y el formato.');
end

%% 3. Procesamiento de datos
disp('=== 3.1 Análisis de frecuencias ===');

% Extraer columnas relevantes (ajustar índices según estructura real)
modalidades = data(:,2);  % Columna de modalidades de atención
edades = data(:,3);       % Columna de edades

% Crear tabla de frecuencias cruzadas
[unique_mod, ~, mod_idx] = unique(modalidades);
[unique_edad, ~, edad_idx] = unique(edades);

frecuencia = accumarray([mod_idx, edad_idx], 1, [], @sum);

% Mostrar estructura de datos
disp('Encabezados de columnas:');
disp(headers);
disp('Modalidades únicas:');
disp(unique_mod);

%% 4. Cálculos estadísticos
disp('=== 4.1 Cálculo de totales y porcentajes ===');

% Sumar frecuencias por modalidad
suma_frecuencia = sum(frecuencia, 2);

% Calcular total general
total = sum(suma_frecuencia);
disp(['Total general: ', num2str(total)]);

% Calcular porcentajes
porcentajes = suma_frecuencia / total;

% Crear tabla resumen
tabla_resumen = [suma_frecuencia, porcentajes];
colnames = {'Total', 'Porcentaje'};
rownames = unique_mod;

disp('Tabla resumen:');
disp(array2table(tabla_resumen, 'RowNames', rownames, 'VariableNames', colnames));

%% 5. Visualización de datos
disp('=== 5.1 Creación de gráficos ===');

% Configurar figura
figure('Position', [100, 100, 800, 600]);
set(gcf, 'Color', 'white');

% Crear gráfico de barras
h = bar(porcentajes, 'FaceColor', [0.2, 0.4, 0.6]);  % Azul acero
title('Distribución de población beneficiaria por modalidad de atención', ...
      'FontSize', 14, 'FontWeight', 'bold');
ylabel('Proporción', 'FontSize', 12);
xlabel('Modalidad de atención', 'FontSize', 12);
set(gca, 'XTick', 1:length(rownames), 'XTickLabel', rownames);
ylim([0 1]);
grid on;

% Rotar etiquetas del eje X si son largas
xtickangle(45);

% Añadir porcentajes en las barras
for i = 1:length(porcentajes)
  text(i, porcentajes(i)+0.02, sprintf('%.1f%%', porcentajes(i)*100), ...
       'HorizontalAlignment', 'center', 'FontSize', 10);
end

%% 6. Exportación de resultados
disp('=== 6.1 Guardar resultados ===');

% Guardar gráfico
print('-dpng', '-r300', 'distribucion_modalidades.png');
disp('Gráfico guardado como distribucion_modalidades.png');

% Guardar tabla resumen en CSV
resumen_celda = [{'Modalidad', 'Total', 'Porcentaje'}; ...
                 rownames, num2cell(tabla_resumen)];
cell2csv('resumen_modalidades.csv', resumen_celda);
disp('Datos resumen guardados como resumen_modalidades.csv');

%% 7. Funciones auxiliares
disp('=== 7.1 Funciones personalizadas ===');

% Función para formatear porcentajes (no necesaria en Octave, pero se incluye como ejemplo)
function str = formato_porcentaje(valor, digitos)
  str = sprintf(['%.', num2str(digitos), 'f%%'], valor*100);
end

%% 8. Ejercicios propuestos
disp('=== 8.1 Para practicar ===');
disp('1. Modifique el código para agrupar edades por rangos (ej. 0-10, 11-20, etc.)');
disp('2. Cree un gráfico de torta (pie chart) mostrando la distribución');
disp('3. Añada filtros para analizar subconjuntos de datos');
disp('4. Implemente cálculo de estadísticas descriptivas por modalidad');
disp('5. Genere un reporte automático en formato PDF');

%% 9. Recursos adicionales
disp('=== 9.1 Para aprender más ===');
disp('* Documentación de Octave: help bar, help csv2cell');
disp('* Libro: "Data Analysis Using Octave" (P. K. Mishra)');
disp('* Tutorial: Análisis de datos con Octave (YouTube)');
disp('* Repositorio: GitHub/octave-data-analysis');
