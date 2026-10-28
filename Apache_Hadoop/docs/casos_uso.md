# Casos de uso de Apache Hadoop

Estos ejercicios asumen que Hadoop 3.3.6 está instalado en modo pseudo-distribuido y que HDFS y YARN están activos, como se describe en la [guía de instalación](instalacion.md). El primero practica operaciones de almacenamiento con HDFS; el segundo ejecuta un trabajo MapReduce con Hadoop Streaming.

## Caso 1: cargar y consultar un archivo en HDFS

Este caso simula la llegada de un pequeño lote de texto al data lake local de Hadoop.

Crear un directorio de trabajo y un archivo de entrada:

```bash
mkdir -p "$HOME/hadoop-practica"
printf '%s\n' \
  'Hadoop almacena datos' \
  'MapReduce procesa datos' \
  'YARN asigna recursos' \
  > "$HOME/hadoop-practica/entrada.txt"
```

Crear un directorio aislado para el ejercicio en HDFS, copiar el archivo y comprobar su contenido:

```bash
hdfs dfs -mkdir -p "/user/$USER/hadoop-practica/entrada"
hdfs dfs -put -f "$HOME/hadoop-practica/entrada.txt" \
  "/user/$USER/hadoop-practica/entrada/entrada.txt"
hdfs dfs -ls "/user/$USER/hadoop-practica/entrada"
hdfs dfs -cat "/user/$USER/hadoop-practica/entrada/entrada.txt"
```

La salida de `-cat` debe mostrar las tres líneas. El archivo ya está en HDFS y puede usarse como entrada del trabajo MapReduce del siguiente caso.

## Caso 2: contar palabras con MapReduce Streaming

El mapper emite pares `palabra\t1`; el reducer suma los valores de cada palabra. Así el ejemplo sí calcula frecuencias de palabras, a diferencia de ejecutar `cat` y `wc` por separado.

Crear los scripts en el directorio de trabajo:

```bash
cd "$HOME/hadoop-practica"
cat > mapper.py <<'PY'
#!/usr/bin/env python3
import re
import sys

for line in sys.stdin:
    for word in re.findall(r"\w+", line.lower()):
        print(f"{word}\t1")
PY

cat > reducer.py <<'PY'
#!/usr/bin/env python3
import sys

current_word = None
current_count = 0

for line in sys.stdin:
    word, count = line.rstrip("\n").split("\t", 1)
    count = int(count)
    if word == current_word:
        current_count += count
    else:
        if current_word is not None:
            print(f"{current_word}\t{current_count}")
        current_word = word
        current_count = count

if current_word is not None:
    print(f"{current_word}\t{current_count}")
PY
chmod +x mapper.py reducer.py
```

Ejecutar el trabajo. Se usa una ruta de salida nueva porque MapReduce no sobrescribe directorios existentes:

```bash
mapred streaming \
  -files "$HOME/hadoop-practica/mapper.py,$HOME/hadoop-practica/reducer.py" \
  -input "/user/$USER/hadoop-practica/entrada/entrada.txt" \
  -output "/user/$USER/hadoop-practica/salida-wordcount" \
  -mapper "python3 mapper.py" \
  -reducer "python3 reducer.py"
```

Leer el resultado desde HDFS:

```bash
hdfs dfs -cat "/user/$USER/hadoop-practica/salida-wordcount/part-*"
```

El resultado debe incluir `datos\t2`, `hadoop\t1`, `mapreduce\t1`, `procesa\t1`, `recursos\t1`, `almacena\t1`, `asigna\t1` y `yarn\t1` (el orden puede variar según la configuración regional y el comparador de claves).

Para repetir el trabajo, elimina únicamente el directorio de salida de este ejercicio y vuelve a ejecutarlo:

```bash
hdfs dfs -rm -r "/user/$USER/hadoop-practica/salida-wordcount"
```

## Relación con otras tecnologías del repositorio

Hadoop proporciona HDFS y MapReduce; no es por sí mismo un servicio de ingesta ni un orquestador. En una arquitectura más amplia, Kafka o NiFi podrían entregar datos a una zona de entrada, y Airflow podría coordinar la carga y el envío del trabajo. Estos ejercicios se limitan a las operaciones de Hadoop una vez que el archivo está disponible en el sistema local.
