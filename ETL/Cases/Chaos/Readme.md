# Ecuación logística y el modelado de crecimiento de Conejos

La versión continua de la ecuación logística permite modelar una población $N(t)$ con crecimiento limitado: $\frac{dN}{dt}=rN(1-\frac{N}{K})$, donde $r$ es la tasa de crecimiento y $K$ la capacidad de carga. En la literatura se usa regularmente como prototipo de “tasa de crecimiento de conejos”. En versión discreta y adimensional aparece el mapa logístico, $x_{n+1}=rx_n(1-x_n)$, donde $x_n\in[0,1]$ representa población normalizada generación a generación.[puente.lawr.ucdavis+1](https://puente.lawr.ucdavis.edu/pdf/Lesson_5_f.pdf)

## Mapa logístico, bifurcación y caos

Al variar $r$ en el mapa logístico, la solución pasa de un punto fijo estable a oscilaciones de periodo 2, luego 4, 8, etc., en una cascada de duplicación de periodo que culmina en comportamiento caótico; el diagrama de bifurcación muestra cómo los valores asintóticos de $x_n$ se ramifican al crecer $r$. Este mismo esquema de bifurcación-duplicación-de-periodo se observa en un gran número de sistemas disipativos unidimensionales suaves, lo que llevó a hablar de universalidad.[nature+3](https://www.nature.com/articles/s41598-024-62439-8)

## Conjunto de Mandelbrot y mapa cuadrático

El conjunto de Mandelbrot se define iterando $z_{n+1}=z_n^2+c$ en el plano complejo y recogiendo los parámetros $c$ para los cuales la órbita de $z=0$ permanece acotada. Existe una relación geométrica notable entre el diagrama de bifurcación del mapa logístico (o más generalmente del mapa cuadrático real) y ciertas “rebanadas” del Mandelbrot: las estructuras de bulbos y lenguas de estabilidad encajan al alinear adecuadamente ambos objetos.[wikipedia+1](https://en.wikipedia.org/wiki/Mandelbrot_set)

1. https://en.wikipedia.org/wiki/Logistic_map
2. https://www.nature.com/articles/s41598-024-62439-8
3. https://pmc.ncbi.nlm.nih.gov/articles/PMC3253168/
4. https://puente.lawr.ucdavis.edu/pdf/Lesson_5_f.pdf
5. https://en.wikipedia.org/wiki/Feigenbaum_constants
6. https://www.borges.pitt.edu/sites/default/files/1103.pdf
7. https://en.wikipedia.org/wiki/Mandelbrot_set
8. https://tomrocksmaths.com/wp-content/uploads/2022/05/maths-essay-competition-chaos-and-fractals-1.pdf
9. https://www.youtube.com/watch?v=ETrYE4MdoLQ
10. https://sites.ifi.unicamp.br/aguiar/files/2014/10/May-Nature-1976.pdf
11. https://legacy-www.math.harvard.edu/archive/153_fall_04/Additional_reading_material/R_May_76_Nature_Chaos.pdf
12. https://www.islandsoforder.com/the-logistic-map.html
13. https://www.youtube.com/watch?v=ovJcsL7vyrk
14. http://physics.bu.edu/~redner/482/13/may-logistic.pdf
15. https://wiredwhite.com/matlab-fractals-and-chaos/
16. https://hypertextbook.com/chaos/mandelbrot/
17. https://www.scirp.org/reference/referencespapers
18. https://www.facebook.com/groups/427283770644468/posts/7280564795316297/
19. https://www.hermes-investment.com/is/en/professional/insights/active-esg/constant-chaos-4-669-reasons-why-car-tech-could-outpace-insurers/
20. https://www.youtube.com/watch?v=1dwVxZR0vFM

# Programar el mapa logístico y generar el diagrama de bifurcación

Un plan mínimo es:  programar el mapa logístico y generar su diagrama de bifurcación, luego usar la analogía con el mapa cuadrático complejo para “alinear” mentalmente el Mandelbrot, y finalmente ver cómo tus sistemas biológicos/experimentales se reducen (por ajuste o heurística) a mapas 1D tipo logístico.[wikipedia+4](https://en.wikipedia.org/wiki/Logistic_map)

## 1) Diagrama de bifurcación (mapa logístico)

Idea básica se centra en barrer $r$ y, para cada $r$, iterar muchas veces $x_{n+1}=r x_n(1-x_n)$; descartar los primeros pasos (transitorio) y graficar los últimos valores de $x_n$ versus $r$.[puente.lawr.ucdavis+1](https://puente.lawr.ucdavis.edu/pdf/Lesson_5_f.pdf)

Pseudocódigo (Puede ser implementado en Octave, Python, C++ + xmgrace):

- Elegir un rango de parámetros, por ejemplo $r\in[2.5,4.0]$, con $N_r$ puntos (200–1000 típicamente).[wikipedia](https://en.wikipedia.org/wiki/Logistic_map)
- Para cada $r$:
  - Fijar $x=0.5$ (o cualquier valor en (0,1)).
  - Iterar, por ejemplo, 1000 pasos para “quemar” el transitorio.
  - Luego iterar otros 200 pasos, guardando cada par $(r,x)$.
- Graficar todos los puntos $(r,x)$ como nube de puntos.

En pseudo-Octave:

```
matlabNr = 500;
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
```

Luego en xmgrace: `xmgrace -nxy bifurcacion.dat` y ajustar ejes a $r\in[2.5,4]$, $x\in[0,1]$.[wikipedia](https://en.wikipedia.org/wiki/Logistic_map)

## 2) Superponerlo conceptualmente con el Mandelbrot

El mapa logístico real $x_{n+1}=r x_n(1-x_n)$ es conjugado al mapa cuadrático real $y_{n+1}=y_n^2 + c$ con cierto cambio de variable y de parámetro; así, el eje de parámetros $r$ se puede reinterpretar como una “rebanada” real del plano $c$.[wikipedia+2](https://en.wikipedia.org/wiki/Mandelbrot_set)

- El conjunto de Mandelbrot es el conjunto de parámetros $c$ tales que la órbita de $z=0$ bajo $z_{n+1}=z_n^2 + c$ permanece acotada.[wikipedia](https://en.wikipedia.org/wiki/Mandelbrot_set)
- Si se toma la sección real $c\in[-2,1/4]$, los intervalos de estabilidad de ciclos de periodo $1,2,4,\dots$ corresponden a los “bulbos” anclados a la espina principal del Mandelbrot.[hypertextbook+1](https://hypertextbook.com/chaos/mandelbrot/)
- El diagrama de bifurcación del mapa logístico muestra precisamente la aparición de estos ciclos estables al variar $r$; conceptualmente, puede imaginarse que el eje $r$ se “curva” sobre el eje real de $c$ y que cada lengua/bulbo estable del Mandelbrot corresponde a una banda vertical de puntos en el diagrama de bifurcación.[tomrocksmaths+2](https://tomrocksmaths.com/wp-content/uploads/2022/05/maths-essay-competition-chaos-and-fractals-1.pdf)

Es decir: el diagrama de bifurcación es “la vista 1D” (en el eje de parámetros reales) de la estructura 2D del Mandelbrot en el plano complejo.

## 3) Mapear ejemplos biológicos/experimentales a mapas 1D

La idea común es escoger una variable escalar que capture el estado de ciclo en cada iteración (o ciclo) y construir un mapa de retorno $x_{n+1}=f(x_n)$, que en muchos casos se aproxima por algo “tipo logístico”.[pmc.ncbi.nlm.nih+3](https://pmc.ncbi.nlm.nih.gov/articles/PMC3253168/)

- “Conejos” (población discreta):
  - Variable: densidad de población normalizada $x_n = N_n/K$ en la generación $n$.[nature+1](https://www.nature.com/articles/s41598-024-62439-8)
  - Mapa: $x_{n+1}=r x_n (1-x_n)$, o variantes con términos de competencia o cosecha; el parámetro $r$ representa tasa de reproducción efectiva por generación, modulable por recursos, depredación, etc.[nature+1](https://www.nature.com/articles/s41598-024-62439-8)
- Neuronas, disparo espontáneo:
  - Variable: intervalo entre spikes, amplitud del potencial o fase en cada ciclo de oscilación; con un Poincaré map se construye $x_{n+1}=f(x_n)$ a partir de un sistema continuo (Hindmarsh–Rose, Morris–Lecar, etc.).[pmc.ncbi.nlm.nih](https://pmc.ncbi.nlm.nih.gov/articles/PMC3253168/)
  - Ajuste: se observa que al variar una corriente de entrada $I$ o una conductancia, la secuencia de intervalos entre spikes muestra duplicación de periodo y caos; el mapa ajustado suele ser suave y unidimensional, por lo que se comporta cualitativamente como un mapa logístico.[pmc.ncbi.nlm.nih](https://pmc.ncbi.nlm.nih.gov/articles/PMC3253168/)
- Grifo que gotea (dripping faucet):
  - Variable: intervalo de tiempo entre gotas $T_n$.[borges.pitt](https://www.borges.pitt.edu/sites/default/files/1103.pdf)
  - Mapa: $T_{n+1}=f(T_n; Q)$, donde $Q$ es el caudal. El experimento muestra que al aumentar $Q$, la secuencia $T_n$ pasa de periódica a duplicación de periodo y caos, y el mapa empírico $f$ tiene curvatura similar a $r x(1-x)$.[southampton+1](https://www.southampton.ac.uk/~mb1a10/lect6.pdf)
- Fibrilación / arritmias en corazón (ej. conejos):
  - Variable: intervalo RR (entre latidos), duración del potencial de acción o amplitud de una onda de Ca$^{2+}$.[borges.pitt](https://www.borges.pitt.edu/sites/default/files/1103.pdf)
  - Mapa: $x_{n+1}=f(x_n; \mu)$, donde $\mu$ representa parámetros de excitabilidad, frecuencia de estimulación o intensidad de descargas externas. Cambiando $\mu$ se observan transiciones de 1:1 a 2:1, 4:1 y patrones irregulares, interpretables como cascadas de duplicación de periodo hacia caos en un mapa efectivamente unidimensional.[jstor+1](https://www.jstor.org/stable/2398227)

Todos estos sistemas son continuos y de alta dimensión en su descripción física “real”, pero su dinámica cíclica puede colapsarse a un mapa escalar de retorno cuando se observa el sistema “ciclo a ciclo”: ese mapa resulta ser, en muchos casos, topológicamente equivalente al mapa logístico (o a otro mapa unimodal suave), y por eso aparecen las mismas estructuras: diagrama de bifurcación, constante de Feigenbaum, ventanas periódicas en el caos y sensibilidad a condiciones iniciales.[muni+3](https://is.muni.cz/el/sci/jaro2020/M6201/um/ajp-jphyslet_1982_43_7_211_0.pdf)

1. https://en.wikipedia.org/wiki/Logistic_map
2. https://en.wikipedia.org/wiki/Mandelbrot_set
3. https://puente.lawr.ucdavis.edu/pdf/Lesson_5_f.pdf
4. https://pmc.ncbi.nlm.nih.gov/articles/PMC3253168/
5. https://is.muni.cz/el/sci/jaro2020/M6201/um/ajp-jphyslet_1982_43_7_211_0.pdf
6. https://tomrocksmaths.com/wp-content/uploads/2022/05/maths-essay-competition-chaos-and-fractals-1.pdf
7. https://hypertextbook.com/chaos/mandelbrot/
8. https://www.nature.com/articles/s41598-024-62439-8
9. https://www.borges.pitt.edu/sites/default/files/1103.pdf
10. https://www.southampton.ac.uk/~mb1a10/lect6.pdf
11. https://www.jstor.org/stable/2398227
12. https://en.wikipedia.org/wiki/Feigenbaum_constants
