function extraer_atractores_grifo()
  data = dlmread("grifo.csv", ",", 1, 0);
  Q_vals = unique(data(:,2));  % Caudales discretos
  atractores = [];
  
  for i = 1:length(Q_vals)
    Q = Q_vals(i);
    % Filtra datos de este caudal (ventana ±0.01)
    idx = abs(data(:,2) - Q) < 0.01;
    T = data(idx, 3);  % Intervalos para este Q
    
    % Descarta transitorio (primeros 20%)
    n_trans = round(0.2 * length(T));
    T = T(n_trans:end);
    
    % Guarda (Q, T) para diagrama bifurcación
    atractores = [atractores; repmat(Q, length(T), 1), T];
  end
  
  dlmread("atractores_grifo.csv", ",", 0, 0) = atractores;
end
