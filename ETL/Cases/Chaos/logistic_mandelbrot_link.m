function logistic_mandelbrot_link()
  % 1) Diagrama bifurcación logística
  r = linspace(2.5, 4, 800);
  bif_points = [];
  for i=1:length(r)
    x = 0.3;  % Condición inicial
    for n=1:200  x = r(i)*x*(1-x); end  % Transitorio
    for n=1:50   x = r(i)*x*(1-x); bif_points(end+1,:) = [r(i), x]; end
  end
  
  % 2) Corte real del Mandelbrot (c ∈ [-2, 0.25])
  c_vals = linspace(-2, 0.25, 800);
  mandel_real = [];
  for i=1:length(c_vals)
    z = 0;
    for n=1:100
      z = z^2 + c_vals(i);
      if abs(z) > 2, break; end
    end
    if abs(z) <= 2, mandel_real(end+1,:) = [c_vals(i), 0]; end
  end
  
  % 3) Gráfica superpuesta
  figure(1); clf;
  plot(bif_points(:,1), bif_points(:,2), 'k.', 'MarkerSize', 1); hold on;
  plot(c_vals, zeros(size(c_vals)), 'r-', 'LineWidth', 2);  % Eje real Mandelbrot
  plot(mandel_real(:,1), mandel_real(:,2), 'ro', 'MarkerSize', 2);
  
  xlabel('r (logístico)  ↔  c (Mandelbrot)'); ylabel('x ↔ Im(z)');
  title('Diagrama bifurcación logística = Corte real del Mandelbrot');
  legend('Bifurcación logística', 'Eje real Mandelbrot', 'Conjunto real');
  grid on; xlim([2.5 4]); ylim([0 1]);
end
