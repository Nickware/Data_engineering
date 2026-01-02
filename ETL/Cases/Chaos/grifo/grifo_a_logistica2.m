function grifo_a_logistica()
  % 1) Extraer atractores del grifo
  extraer_atractores_grifo();
  
  % 2) Normalizar a logística
  normalizar_logistico();
  
  % 3) Graficar SUPERPOSICIÓN
  figure(3); clf;
  
  % Bifurcación del GRIFO real
  subplot(2,1,1);
  data_grifo = dlmread("atractores_grifo.csv");
  scatter(data_grifo(:,1), data_grifo(:,2), 3, "blue", "filled");
  xlabel("Caudal Q (ml/s)"); ylabel("Intervalo T (s)");
  title("Datos GRIFO: Mapa de retorno experimental");
  ylim([min(data_grifo(:,2))*0.9, max(data_grifo(:,2))*1.1]);
  
  % Bifurcación LOGÍSTICA (teórica)
  subplot(2,1,2);
  data_log = dlmread("bifurcacion_grifo_logistica.csv");
  scatter(data_log(:,1), data_log(:,2), 3, "red", "filled");
  hold on;
  
  % Logística TEÓRICA pura (para comparar)
  r_teor = linspace(3.0, 4.0, 500);
  bif_teor = generar_bifurcacion_teorica(r_teor);
  plot(r_teor, bif_teor, "k-", "LineWidth", 1.5);
  
  xlabel("r (logístico)"); ylabel("x (normalizado)");
  title("GRIFO mapeado → LOGÍSTICA (teórica)");
  legend("Datos grifo normalizados", "Logística teórica");
  ylim([0 1]);
end

function bif = generar_bifurcacion_teorica(r)
  bif = [];
  for i = 1:length(r)
    x = 0.5;
    for n = 1:200, x = r(i)*x*(1-x); end  % Transitorio
    for n = 1:30, x = r(i)*x*(1-x); bif(end+1,:) = x; end
  end
  bif = bif';
end
