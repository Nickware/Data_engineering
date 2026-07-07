function mandelbrot_vector()
  xmin=-2.4; xmax=0.8; ymin=-1.2; ymax=1.2;
  width=600; height=450; max_iter=80;
  
  tic;
  [X,Y] = meshgrid(linspace(xmin,xmax,width), linspace(ymin,ymax,height));
  C = X + 1i*Y; img = zeros(size(C));
  
  Z = zeros(size(C));
  for n=1:max_iter
    Z = Z.^2 + C;
    img(abs(Z)>2) = n;
    Z(abs(Z)>2) = 2+2i;  % Evita overflow
  end
  toc
  
  figure; imagesc(img); colormap(jet); axis equal tight off; colorbar;
  title("Mandelbrot vectorizado");
end
