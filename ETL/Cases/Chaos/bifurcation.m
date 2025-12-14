Nr = 500;
rmin = 2.5; rmax = 4.0;
rvals = linspace(rmin, rmax, Nr);
Nt_burn = 1000;
Nt_plot = 200;

fid = fopen("bifurcacion.dat","w");
for k = 1:Nr
  r = rvals(k);
  x = 0.5;
  for n = 1:Nt_burn
    x = r * x * (1 - x);
  end
  for n = 1:Nt_plot
    x = r * x * (1 - x);
    fprintf(fid, "%f %f\n", r, x);
  end
end
fclose(fid);
