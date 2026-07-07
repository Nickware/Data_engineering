function grifo_a_logistica()
  % 1) Generar datos del grifo (si no existe)
  if ~exist("grifo.csv", "file")
    generar_grifo("grifo.csv");
  end
  
  % 2) Extraer atractores del grifo
  extraer_atractores_grifo();
  
  % 3) Normalizar a logística
  normalizar_logistico();
  
  % 4) Graficar SUPERPOSICIÓN
  graficar_superposicion();
end

function generar_grifo(filename)
  fid = fopen(filename, "w");
  fprintf(fid, "gota_n,caudal_ml_s,intervalo_seg\n");
  for Q = linspace(4.5, 8.5, 40)
    T = 1.0;
    for n = 1:80
      T = 9.5 - 0.95*Q + 0.15*Q*T*(8-T) + 0.01*randn;
      T = max(0.1, T);
      if mod(n, 5) == 0
        fprintf(fid, "%d,%.3f,%.4f\n", n, Q, T);
      end
    end
  end
  fclose(fid);
end

function extraer_atractores_grifo()
  data = dlmread("grifo.csv", ",", 1, 0);
  Q_vals = unique(data(:,2));
  atractores = [];
  
  for i = 1:length(Q_vals)
    Q = Q_vals(i);
    idx = abs(data(:,2) - Q) < 0.02;
    T = data(idx, 3);
    
    if length(T) > 10
      n_trans = round(0.2 * length(T));
      T = T(n_trans:end);
      atractores = [atractores; repmat(Q, length(T), 1), T];
    end
  end
  
  dlmwrite("atractores_grifo.csv", atractores, ",");
end

function normalizar_logistico()
  data = dlmread("atractores_grifo.csv", ",", 0, 0);
  
  r_min = min(data(:,1)); r_max = max(data(:,1));
  T_min = min(data(:,2)); T_max = max(data(:,2));
  
  r_norm = (data(:,1) - r_min) / (r_max - r_min) * 1.5 + 3.0;
  x_norm = (data(:,2) - T_min) / (T_max - T_min);
  
  logistica_data = [r_norm, x_norm];
  dlmwrite("bifurcacion_grifo_logistica.csv", logistica_data, ",");
end

function graficar_superposicion()
  figure(3); clf;
  
  % GRIFO real
  subplot(2,1,1);
  data_grifo = dlmread("atractores_grifo.csv", ",", 0, 0);
  scatter(data_grifo(:,1), data_grifo(:,2), 30, "b", "filled");
  xlabel("Caudal Q (ml/s)"); ylabel("Intervalo T (s)");
  title("1) GRIFO: Datos de campo");
  grid on;
  
  % Logística mapeada + TEÓRICA CORREGIDA
  subplot(2,1,2);
  data_log = dlmread("bifurcacion_grifo_logistica.csv", ",", 0, 0);
  scatter(data_log(:,1), data_log(:,2), 30, "r", "filled"); hold on;
  
  % *** Genera bifurcación teórica ***
  r_teor = linspace(3.0, 4.0, 500);
  [r_teor, bif_teor] = generar_bifurcacion_teorica_correcta(r_teor);
  plot(r_teor, bif_teor, "k-", "LineWidth", 1.5);
  
  xlabel("r (logístico)"); ylabel("x (normalizado)");
  title("2) GRIFO → LOGÍSTICA (¡MISMA estructura!)");
  legend("Datos grifo mapeados", "Logística teórica");
  ylim([0 1]); grid on;
end

function [r_out, bif_out] = generar_bifurcacion_teorica_correcta(r)
  % *** Retorna matrices Nx2 ***
  bif = [];
  for i = 1:length(r)
    x = 0.5;
    for n = 1:200  % Transitorio
      x = r(i)*x*(1-x);
    end
    for n = 1:30   % Muestra estable
      x = r(i)*x*(1-x);
      bif(end+1, :) = [r(i), x];
    end
  end
  r_out = bif(:,1);
  bif_out = bif(:,2);
end

