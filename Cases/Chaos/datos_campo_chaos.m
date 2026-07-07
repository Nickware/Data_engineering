function datos_campo_chaos()
  % 1) CONEJOS: Población por generaciones
  generar_conejos("conejos.csv");
  
  % 2) GRIFO: Intervalos entre gotas
  generar_grifo("grifo.csv");
  
  % 3) MERCURIO: Frecuencias convectivas
  generar_mercurio("mercurio.csv");
  
  % 4) Análisis unificado (diagramas bifurcación)
  analizar_datos_campo();
end

function generar_conejos(filename)
  fid = fopen(filename, "w");
  fprintf(fid, "generacion,r_efectivo,poblacion_normalizada\n");
  for r = linspace(2.8, 3.85, 50)  % r varía por "temporadas"
    x = 0.4;
    for gen = 1:100
      x = r * x * (1 - x) + 0.02*randn;  % Ruido de campo
      if mod(gen, 10) == 0  % Muestreo cada 10 generaciones
        fprintf(fid, "%d,%.4f,%.4f\n", gen, r, x);
      end
    end
  end
  fclose(fid);
end

function generar_grifo(filename)
  fid = fopen(filename, "w");
  fprintf(fid, "gota_n,caudal_ml_s,intervalo_seg\n");
  for Q = linspace(4.5, 8.5, 40)  % Caudal creciente
    T = 1.0;  % Intervalo inicial
    for n = 1:80
      % Mapa aproximado experimental (con ruido)
      T = 9.5 - 0.95*Q + 0.15*Q*T*(8-T) + 0.01*randn;
      T = max(0.1, T);  % Límite físico
      if mod(n, 5) == 0
        fprintf(fid, "%d,%.3f,%.4f\n", n, Q, T);
      end
    end
  end
  fclose(fid);
end

function generar_mercurio(filename)
  fid = fopen(filename, "w");
  fprintf(fid, "experimento,Rayleigh,frecuencia_Hz\n");
  for R = linspace(1.5e4, 2.8e4, 45)  % Número Rayleigh
    f0 = 2.0;  % Frecuencia base
    f = f0;
    for k = 1:60
      % Modelo simplificado Libchaber (con ruido experimental)
      f = 1.95*f0 - 0.0001*R + 0.12*f*(3.5-f) + 0.005*randn;
      if mod(k, 8) == 0
        fprintf(fid, "%d,%.0f,%.4f\n", k, R, f);
      end
    end
  end
  fclose(fid);
end

function analizar_datos_campo()
  figure(2); clf;
  
  % Conejos: Bifurcación población vs r
  subplot(3,1,1);
  data = dlmread("conejos.csv", ",", 1, 0);
  scatter(data(:,2), data(:,3), 8, data(:,1), "filled");
  xlabel("r efectivo"); ylabel("Población normalizada");
  title("Conejos: Datos de campo → Bifurcación");
  ylim([0 1]);
  
  % Grifo: Intervalo vs caudal
  subplot(3,1,2);
  data = dlmread("grifo.csv", ",", 1, 0);
  scatter(data(:,2), data(:,3), 8, data(:,1), "filled");
  xlabel("Caudal (ml/s)"); ylabel("Intervalo entre gotas (s)");
  title("Grifo: Datos experimentales → Mapa retorno");
  
  % Mercurio: Frecuencia vs Rayleigh
  subplot(3,1,3);
  data = dlmread("mercurio.csv", ",", 1, 0);
  scatter(data(:,2)/1e3, data(:,3), 12, data(:,1), "filled");
  xlabel("Rayleigh (×10³)"); ylabel("Frecuencia (Hz)");
  title("Mercurio: Convección → Duplicación periodo");
  
  sgtitle("Datos de CAMPO → Ruta al Caos (bifurcaciones detectadas)");
end
