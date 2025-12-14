function mandelbrot_fast()
  xmin = -2.5; xmax = 1.0;
  ymin = -1.5; ymax = 1.5;
  width = 400; height = 300;  % ↓ Reducido
  max_iter = 64;             % ↓ Reducido
  
  tic; img = mandelbrot(xmin,xmax,ymin,ymax,width,height,max_iter); toc
  
  figure(1); clf;
  imagesc(img); colormap(hsv); axis equal tight off; colorbar;
  title("Mandelbrot - Tiempo de escape");
end

function img = mandelbrot(xmin,xmax,ymin,ymax,w,h,maxit)
  img = zeros(h,w);
  [X,Y] = meshgrid(linspace(xmin,xmax,w), linspace(ymin,ymax,h));
  C = X + 1i*Y;
  
  Z = zeros(size(C));
  for n = 1:maxit
    Z = Z.^2 + C;
    mask = abs(Z) <= 2;
    img = img + (1-mask);  % Incrementa si no escapó
    Z(~mask) = NaN;        % Para las que ya escaparon
  end
end
