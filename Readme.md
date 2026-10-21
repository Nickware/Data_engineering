# Ingeniería de datos

Este repositorio reúne apuntes, guías de instalación y ejercicios relacionados con el ciclo de trabajo de los datos: integrar fuentes, mover y almacenar información, procesarla de forma distribuida o continua y preparar resultados para análisis. Incluye documentación de herramientas del ecosistema Apache, ejemplos de análisis estadístico en R y ejercicios de modelado numérico.

No es una aplicación única ni todas las carpetas forman parte de un mismo pipeline. Cada sección es material independiente: algunas carpetas son guías conceptuales o de instalación y otras contienen casos prácticos o scripts que requieren sus propios datos y dependencias.

## Cómo se relaciona el repositorio con la ingeniería de datos

Una plataforma de datos combina herramientas con responsabilidades distintas. En este repositorio, la integración y el movimiento de datos se representan con Apache NiFi, Kafka y Hop; la coordinación de tareas, con Airflow y también con los workflows de Hop; el almacenamiento distribuido, con Hadoop; y el procesamiento, con Spark para cargas distribuidas y Flink para flujos de eventos. Las guías de Lakehouse, Iceberg y Hudi abordan cómo organizar tablas analíticas confiables sobre un data lake.

El proyecto SDIS_SIRBE muestra una etapa posterior del ciclo: leer datos, resumirlos y producir tablas y gráficas con R. Los ejercicios de caos son material de análisis y modelado computacional relacionado con los datos, aunque no constituyen por sí mismos una plataforma o pipeline de ingeniería de datos. Apache HTTP Server representa la capa de publicación web: puede servir reportes o documentación producidos por otros componentes, o actuar como proxy de una aplicación; no procesa los datos por sí mismo.

## Clasificación general de herramientas y tecnologías

Estas categorías son una referencia general para ubicar las tecnologías documentadas aquí; no implican que todas estén implementadas o integradas entre sí en el repositorio.

| Categoría | Función habitual | Contenidos relacionados |
| --- | --- | --- |
| Ingesta e integración | Recibir, enrutar y conectar datos de distintas fuentes | Apache NiFi, Apache Kafka y Apache Hop |
| Orquestación | Programar tareas y coordinar sus dependencias | Apache Airflow y workflows de Apache Hop |
| Almacenamiento distribuido | Guardar y distribuir grandes volúmenes de datos | Apache Hadoop y HDFS |
| Procesamiento de datos | Transformar datos en lote o en streaming | Apache Spark, Apache Flink y MapReduce en Hadoop |
| Lakehouse y formatos de tabla | Gestionar tablas analíticas sobre almacenamiento tipo data lake | Apache Iceberg, Apache Hudi y los conceptos de Lakehouse |
| Análisis y presentación | Resumir datos y comunicar resultados mediante tablas y gráficas | Scripts R del proyecto SDIS_SIRBE |
| Publicación y acceso web | Servir páginas y archivos o enrutar solicitudes a aplicaciones web | Apache HTTP Server (HTTPD) |
| Lenguajes y herramientas de apoyo | Implementar ejemplos, analizar datos y visualizar resultados | Python, R, MATLAB/Octave y gnuplot, según cada carpeta |

## Índice

### Tecnologías y plataformas

#### Integración y orquestación

- [Apache Airflow](Apache_Airflow/Readme.md): explica DAGs, operadores, scheduler, workers y ejecución; incluye instrucciones de instalación y puesta en marcha. Su [caso práctico](Apache_Airflow/cases/Readme.md) crea un DAG con tareas Bash y Python, dependencias y comprobación desde la interfaz web.
- [Apache Hop](Apache_hop/Readme.md): presenta Hop GUI, pipelines, workflows, ejecución por línea de comandos y Hop Server. Incluye un ejemplo conceptual de ETL y un caso de monitoreo IoT que relaciona Hop con Kafka y Spark.
- [Apache NiFi](Apache_Nifi/Readme.md): guía de instalación y configuración en Linux, arranque como servicio o manual y prueba de un flujo sencillo con procesadores desde la interfaz web.

#### Procesamiento y streaming

- [Apache Hadoop](Apache_Hadoop/Readme.md): introduce HDFS, MapReduce y YARN para almacenamiento distribuido, procesamiento paralelo y gestión de recursos; también inicia una guía de instalación.
- [Apache Spark](Apache_Spark/Readme.md): guía para instalar Spark en Ubuntu, configurar `SPARK_HOME` y verificar la instalación con `spark-shell`.
- [Apache Flink](Apache_Flink/Readme.md): describe procesamiento de eventos con estado, semántica del tiempo, ventanas, arquitectura y APIs; además, incluye instrucciones de instalación de Flink y PyFlink. La [prueba con PyFlink](Apache_Flink/cases/Readme.md), implementada en [physics_prueba.py](Apache_Flink/cases/physics_prueba.py), combina un saludo y un cálculo de caída libre en un flujo.
- [Apache Kafka](Apache_Kafka/Readme.md): guía de instalación y primera configuración de Kafka; muestra cómo iniciar los servicios y crear un tópico de prueba para mensajería distribuida.

#### Lakehouse y formatos de tabla

- [Apache Lakehouse](Apache_Lakehouse/Readme.md): explica la arquitectura que combina data lakes y data warehouses, compara formatos y presenta un ejemplo de stack para e-commerce con MinIO, Iceberg, Spark, Trino y Airflow.
- [Apache Iceberg](Apache_iceberg/Readme.md): describe catálogos, metadatos y snapshots, además de transacciones, evolución de esquema y particiones y consultas históricas; incluye un ejemplo de uso con Spark.
- [Apache Hudi](Apache_hudi/Readme.md): explica las tablas Copy on Write y Merge on Read, upserts, deletes, CDC y procesamiento incremental, y compara sus enfoques con Iceberg y Delta Lake.

#### Publicación y acceso web

- [Apache HTTP Server (HTTPD)](Apache/Readme.md): explica cómo un servidor web puede publicar reportes, archivos o documentación generados por otros componentes y actuar como proxy de una aplicación o API. La [guía de instalación](Apache/docs/instalacion.md) cubre Debian/Ubuntu y Fedora; los [casos de uso](Apache/docs/casos_uso.md) publican una gráfica de SDIS_SIRBE y exponen un resultado JSON a través de un proxy.

### Casos y ejercicios

- [Caos y mapa logístico](Cases/Chaos/Readme.md): material de modelado sobre crecimiento poblacional, mapa logístico, diagramas de bifurcación y relación con el conjunto de Mandelbrot. La carpeta contiene programas MATLAB/Octave, una configuración gnuplot y datos CSV, incluidos ejemplos relacionados con un grifo que gotea.
- [Prueba de Airflow](Apache_Airflow/cases/Readme.md): ejercicio de orquestación que define tareas, dependencias y una simulación de caída libre; documenta cómo activar el DAG y revisar su ejecución.
- [Prueba de Flink](Apache_Flink/cases/Readme.md): ejercicio de procesamiento en streaming que emite una confirmación solo cuando concluyen correctamente las etapas del flujo.

### Proyecto SDIS_SIRBE

- [Descripción del proyecto SDIS_SIRBE](sdis_sirve/README.md): identifica el repositorio de scripts del proyecto. Los análisis trabajan con datos de beneficiarios del sistema SIRBE y esperan archivos de entrada en las rutas descritas dentro de los scripts.
- [Gráficas generales](sdis_sirve/scripts_graficas/generales/README.md): agrupa scripts R de visualización. [rscript_sirbe_3.R](sdis_sirve/scripts_graficas/generales/rscript_sirbe_3.R) resume por modalidad de atención y edad; [rscript_sirbe_4.R](sdis_sirve/scripts_graficas/generales/rscript_sirbe_4.R) grafica la distribución de beneficiarios por sexo.
- [Tablas generales](sdis_sirve/scripts_tablas/generales/README.md): [rscript_sirbe_2.R](sdis_sirve/scripts_tablas/generales/rscript_sirbe_2.R) cruza tipo de vivienda y edad, calcula totales y porcentajes y exporta resultados a Excel, incluido un gráfico.
- [Tablas desagregadas](sdis_sirve/scripts_tablas/desagregadas/README.md): [rscript_sirbe_.R](sdis_sirve/scripts_tablas/desagregadas/rscript_sirbe_.R) desglosa frecuencias por tipo de vivienda y grupos de edad, y genera tablas y gráficas.

### Otras carpetas

- `data_base/`: carpeta actualmente vacía, sin documentación ni archivos de proyecto.

## Nota sobre el contenido

Las guías son independientes y pueden diferir en alcance, versiones y requisitos. Comprueba las versiones y rutas antes de ejecutar sus comandos. Algunos scripts SDIS_SIRBE dependen de archivos CSV o Excel y de rutas locales que no están incluidas en este repositorio; consulta cada script y su README para conocer sus entradas y salidas.
