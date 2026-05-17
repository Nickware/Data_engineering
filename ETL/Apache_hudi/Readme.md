# Apache Hudi

**Apache Hudi** es un formato de tabla transaccional de código abierto diseñado para simplificar el procesamiento incremental y el flujo de datos en tiempo real sobre data lakes. A diferencia de los data lakes tradicionales que solo son eficientes para añadir datos, Hudi permite operaciones de actualización y eliminación a nivel de registro, así como la captura de cambios (CDC), convirtiendo el almacenamiento inmutable en un sistema de datos dinámico y manejable.

Nació en **Uber** en 2016 para resolver el problema de la ineficiencia en pipelines de datos a gran escala. La compañía necesitaba un sistema que pudiera manejar actualizaciones de alta frecuencia (como el estado de los viajes) y extraer únicamente los cambios (incrementos) para alimentar otros análisis, en lugar de reprocesar tablas enteras de petabytes diariamente. En 2019, se donó a la Apache Software Foundation y hoy es un proyecto de primer nivel ampliamente adoptado.

---

### Arquitectura y Funcionamiento

La arquitectura de Hudi se basa en cuatro pilares fundamentales que lo diferencian de otros formatos de tabla:

#### 1. Tipos de Tabla (COW vs MOR)
Hudi ofrece dos tipos de tabla que permiten elegir entre el rendimiento de lectura o escritura:

- **Copy on Write (COW - Copiar al Escribir)**:
    - **Mecanismo**: Cada vez que se hace una actualización, se reescribe por completo el archivo Parquet que contiene los datos afectados.
    - **Rendimiento**: Las escrituras son más lentas y costosas, pero las lecturas son extremadamente rápidas.
    - **Ideal para**: Tablas con pocas actualizaciones o donde la velocidad de consulta es crítica.

- **Merge on Read (MOR - Fusionar al Leer)**:
    - **Mecanismo**: Las actualizaciones se escriben en archivos de registro (`log files`) separados y pequeños. La fusión con el archivo base Parquet ocurre solo en el momento de la lectura.
    - **Rendimiento**: Las escrituras son muy rápidas (ideal para ingesta en tiempo real), pero las lecturas pueden ser más lentas si se leen muchos logs.
    - **Ideal para**: Ingesta de datos en tiempo real o CDC, donde la velocidad de escritura es primordial.

#### 2. Timeline (Línea de Tiempo)
El Timeline es el "cerebro" de Hudi. Registra todas las acciones que ocurren sobre la tabla (comits, ingestiones, limpiezas, compactaciones) como una serie de eventos atómicos en una estructura similar a un diario de base de datos. Esto permite a Hudi ofrecer aislamiento de instantáneas (MVCC), viajar en el tiempo a versiones anteriores de los datos y garantizar la consistencia incluso con múltiples escritores concurrentes.

#### 3. Indexación
Para saber en qué archivo específico se encuentra un registro (clave primaria) que se desea actualizar, Hudi utiliza índices. Evita así tener que escanear todos los archivos de la tabla, lo que sería inviable a gran escala.
- **Índices comunes**: Bloom Filter, bucket index, record-level index.
- **Beneficio**: Permite operaciones `upsert` (actualizar si existe, insertar si no) extremadamente rápidas y eficientes, una de las principales ventajas de Hudi.

#### 4. Almacenamiento
Físicamente, una tabla Hudi es un directorio en tu data lake (S3, HDFS, GCS). Dentro, los archivos se organizan en `File Groups` y `File Slices`, y toda la información de metadatos y transacciones reside en una carpeta especial llamada `.hoodie`.

---

### ✨ Características Clave

Gracias a esta arquitectura, Hudi ofrece capacidades que lo hacen único:
- **Upserts y Deletes**: Capacidad nativa y eficiente para actualizar y eliminar registros sin reprocesar tablas enteras. Es una de sus funcionalidades más maduras.
- **Change Data Capture (CDC)**: Permite obtener un stream de todos los cambios (inserciones, actualizaciones, eliminaciones) que han ocurrido en una tabla a partir de un punto en el tiempo, funcionando como una cola de mensajes (ej. Kafka) sobre el data lake.
- **Procesamiento Incremental**: En lugar de ejecutar costosos pipelines batch que procesan toda la tabla cada vez, Hudi permite consultar solo los datos que han cambiado desde la última ejecución, acelerando drásticamente los ETLs.
- **Auto-Mantenimiento (Self-Managing)**: Hudi cuenta con servicios de tabla integrados que se ejecutan en segundo plano para optimizar el rendimiento automáticamente, como `Cleaning` (borrar versiones antiguas de archivos), `Compaction` (fusionar archivos log en Parquet para tablas MOR) y `Clustering` (reorganizar datos para mejorar la velocidad de consulta).

---

### Hudi vs. Iceberg vs. Delta Lake

Entender a Hudi es más fácil cuando se compara con sus competidores directos. Las diferencias clave están en sus "personalidades" y especialidades:

| Característica               | Apache Hudi                                                  | Apache Iceberg                                               | Delta Lake                                              |
| :--------------------------- | :----------------------------------------------------------- | :----------------------------------------------------------- | :------------------------------------------------------ |
| **Especialización**          | Flujos de streaming / CDC intensivos                         | Arquitectura limpia y multi-engine                           | Ecosistema Spark                                        |
| **Rendimiento en Escritura** | **Muy Alto** (gracias a MOR e índices)                       | Medio                                                        | Medio                                                   |
| **Rendimiento en Lectura**   | Medio (en MOR) / Alto (en COW)                               | **Muy Alto** (optimizado para analítica)                     | Alto                                                    |
| **Punto Fuerte Único**       | **Upserts/Deletes nativos**, herramientas de ingesta (Hudi Streamer), CDC | Evolución de particiones, soporte multi-engine más amplio (Snowflake, BigQuery, DuckDB) | Integración perfecta y confiable con Spark y Databricks |
| **Curva de Aprendizaje**     | **Alta** (compleja de configurar)                            | Media                                                        | Baja                                                    |
| **Comunidad/Adopción**       | Fuerte en empresas con necesidades de streaming              | Más amplia y de rápido crecimiento, considerado el estándar de la industria | Grande, pero fuertemente ligada a Databricks            |

> **Nota**: Las fronteras se están desdibujando. Hudi 1.1 ya es compatible de forma nativa con el formato Iceberg, y Delta Lake tiene su "Universal Format". Sin embargo, el enfoque y las fortalezas de cada uno siguen siendo claros.

---

### 🚀 Caso de Uso Real: Zupee y la Optimización de Costes

**Zupee**, la plataforma de juegos online más grande de India, construyó su plataforma de datos con Apache Hudi y obtuvo resultados impresionantes.

**Problema**: Su arquitectura de datos legacy era costosa y no escalaba bien para la ingesta en tiempo real, una necesidad crítica para entender el comportamiento de los usuarios en un juego.

**Solución e Impacto**:

1.  **Reducción de Costes en un 60%**: Al habilitar la **Metadata Table** de Hudi, eliminaron las costosas operaciones de listado de archivos en S3, reduciendo drásticamente los costes de red.
2.  **Ingesta en 15 Minutos**: Lograron un SLA de ingesta de 2 a 5 millones de registros en solo 15 minutos utilizando tablas **Merge-On-Read (MOR)** e índices de Hudi para búsquedas eficientes.
3.  **30% de Ahorro en Almacenamiento**: Cambiaron la compresión de Snappy a ZSTD, lo que redujo el tamaño de los datos en un 30%.

**¿Por qué Hudi y no otro?** Probaron Delta Lake, pero para su carga de trabajo de ingesta en **tiempo real**, Hudi tuvo un rendimiento mucho mejor. La herramienta nativa **Hudi Streamer** fue clave para la ingesta desde Kafka y bases de datos.

---

### Conclusión: ¿Para quién es Hudi?

En resumen, Hudi es una tecnología muy potente con un caso de uso muy definido:

**Si la prioridad es el rendimiento en escritura y la gestión de datos cambiantes en tiempo real, Hudi es una seleccionable. Es la opción natural al proyecto si se centra en:**

- **Ingesta de datos en streaming** desde Kafka, CDC de bases de datos (Debezium, Maxwell), etc.
- **Operaciones frecuentes de actualización/eliminación (Upserts/Deletes)** sobre grandes volúmenes de datos.
- **Necesitas extraer un flujo de cambios (CDC)** de tu data lake para alimentar otros sistemas.
- **Estás dispuesto a asumir una configuración más compleja** a cambio de un alto rendimiento en escritura.

Si la prioridad es la máxima compatibilidad entre motores o una integración sencilla con Spark, Iceberg o Delta Lake podrían ser mejores opciones.
