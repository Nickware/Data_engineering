# Ingeniería de datos

Este repositorio reúne apuntes, guías de instalación y ejercicios sobre tecnologías y prácticas de ingeniería de datos. Los temas incluyen integración y orquestación de pipelines, procesamiento distribuido y en streaming, almacenamiento tipo lakehouse y análisis con scripts.

El contenido está organizado por tecnología o caso de estudio. No es una aplicación única: cada carpeta contiene documentación y, en algunos casos, ejemplos ejecutables propios.

## Índice

### Tecnologías y plataformas

#### Integración y orquestación

- [Apache Airflow](Apache_Airflow/Readme.md): conceptos, instalación y [caso práctico](Apache_Airflow/cases/Readme.md) de un DAG de prueba.
- [Apache Hop](Apache_hop/Readme.md): plataforma visual para diseñar y ejecutar pipelines y workflows de datos.
- [Apache NiFi](Apache_Nifi/Readme.md): instalación y prueba de flujos de ingesta y enrutamiento.

#### Procesamiento y streaming

- [Apache Hadoop](Apache_Hadoop/Readme.md): almacenamiento distribuido y procesamiento de grandes volúmenes de datos.
- [Apache Spark](Apache_Spark/Readme.md): guía de instalación y verificación de Spark.
- [Apache Flink](Apache_Flink/Readme.md): procesamiento de flujos y guía de instalación; incluye una [prueba con PyFlink](Apache_Flink/cases/Readme.md) y el script [physics_prueba.py](Apache_Flink/cases/physics_prueba.py).
- [Apache Kafka](Apache_Kafka/Readme.md): instalación y prueba de una plataforma de streaming de eventos.

#### Lakehouse y formatos de tabla

- [Apache Lakehouse](Apache_Lakehouse/Readme.md): arquitectura lakehouse y tecnologías relacionadas.
- [Apache Iceberg](Apache_iceberg/Readme.md): formato de tablas para data lakes analíticos.
- [Apache Hudi](Apache_hudi/Readme.md): tablas transaccionales, actualizaciones e ingesta incremental.

### Casos y ejercicios

- [Caos y mapa logístico](Cases/Chaos/Readme.md): notas y recursos para estudiar bifurcaciones, el mapa logístico y el conjunto de Mandelbrot. La carpeta incluye scripts MATLAB/Octave, gnuplot y datos CSV.
- [Prueba de Airflow](Apache_Airflow/cases/Readme.md): ejemplo de DAG con tareas Bash y Python.
- [Prueba de Flink](Apache_Flink/cases/Readme.md): flujo PyFlink con una simulación de caída libre.

### Proyecto SDIS_SIRBE

- [Descripción del proyecto SDIS_SIRBE](sdis_sirve/README.md): colección de scripts R para análisis, tablas y gráficas.
- [Gráficas generales](sdis_sirve/scripts_graficas/generales/README.md): documentación y scripts [rscript_sirbe_3.R](sdis_sirve/scripts_graficas/generales/rscript_sirbe_3.R) y [rscript_sirbe_4.R](sdis_sirve/scripts_graficas/generales/rscript_sirbe_4.R).
- [Tablas generales](sdis_sirve/scripts_tablas/generales/README.md): documentación y script [rscript_sirbe_2.R](sdis_sirve/scripts_tablas/generales/rscript_sirbe_2.R).
- [Tablas desagregadas](sdis_sirve/scripts_tablas/desagregadas/README.md): documentación y script [rscript_sirbe_.R](sdis_sirve/scripts_tablas/desagregadas/rscript_sirbe_.R).

### Otras carpetas

- [Apache HTTP Server (HTTPD)](Apache/Readme.md): guía para instalar y probar el servidor web Apache en Linux. Es independiente de las guías de tecnologías de datos listadas arriba.
- `data_base/`: carpeta actualmente vacía, sin documentación ni proyecto descrito.

## Nota sobre el contenido

Las carpetas son independientes y sus guías pueden diferir en alcance y versión. Antes de ejecutar una instalación, revisa las versiones de software y los requisitos indicados en el README de esa tecnología. Los casos prácticos se documentan en sus propias carpetas.
