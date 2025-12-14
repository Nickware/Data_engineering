set terminal pngcairo size 1600,900 enhanced font "Helvetica,12"
set output "bifurcacion_logistico.png"

set title "Diagrama de bifurcación del mapa logístico"
set xlabel "r"
set ylabel "x"

set xrange [2.5:4.0]
set yrange [0:1]

set key off
set border lw 1.5
set tics out

# Puntos pequeños y densos
set style line 1 pt 7 ps 0.05 lc rgb "black"

plot "bifurcacion.dat" using 1:2 with points ls 1
