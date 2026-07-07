function normalizar_logistico()
  data = dlmread("atractores_grifo.csv", ",", 0, 0);
  
  T_range = range(data(:,2));
  x_norm = (data(:,2) - min(data(:,2))) / T_range;
  r_norm = (data(:,1) - min(data(:,1))) / (max(data(:,1)) - min(data(:,1))) * 1.5 + 3.0;
  
  % Guarda como logística pura
  logistica_data = [r_norm, x_norm];
  dlmread("bifurcacion_grifo_logistica.csv", ",", 0, 0) = logistica_data;
end
