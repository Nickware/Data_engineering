# Apache Iceberg

**Apache Iceberg** es un formato de tabla de código abierto de alto rendimiento, diseñado específicamente para conjuntos de datos masivos y analíticos en data lakes. Es una capa inteligente y moderna que se sitúa sobre tus archivos (en S3, GCS, HDFS) para dotarlos de las capacidades de una base de datos de data warehouse, sin los bloqueos de un proveedor.

A continuación, se presenta una visión completa de sus fundamentos, su arquitectura y por qué se ha convertido en un estándar en la industria.

### ¿Qué problema resuelve Iceberg?

Antes de Iceberg, trabajar con datos a gran escala en un data lake (usando formatos como Hive) era problemático:

-   **Falta de fiabilidad**: Las operaciones concurrentes de escritura podían corromper los datos y las lecturas eran inconsistentes.
-   **Particionado rígido**: Cambiar la estrategia de particionado (ej. de `fecha` a `categoría`) requería reescribir por completo tablas de petabytes.
-   **Evolución del esquema compleja**: Añadir o renombrar una columna era una operación arriesgada y lenta.
-   **Rendimiento degradado**: Con millones de archivos pequeños, la planificación de consultas se volvía extremadamente lenta.

Iceberg nació en Netflix para resolver estos problemas de fiabilidad y rendimiento a escala de petabytes. En 2018 se donó a la Apache Software Foundation, convirtiéndose en un proyecto de primer nivel. Hoy es adoptado por gigantes como Apple, Google, AWS y Snowflake.

### ¿Cómo funciona? Su arquitectura única

El éxito de Iceberg radica en su arquitectura de metadatos de tres niveles que actúa como un "directorio de archivos" avanzado:

1.  **Capa de Catálogo**: Es el "mapa" principal. Le dice al motor de consultas (ej. Spark) dónde está la versión más reciente de la tabla. Puede ser un Hive Metastore, AWS Glue o el REST de Iceberg.
2.  **Capa de Metadatos**: Un árbol de archivos JSON que contiene la historia completa de la tabla. Aquí se guarda el esquema actual, las particiones, y lo más importante: una lista de **"snapshots"** o instantáneas.
3.  **Capa de Datos**: Son tus archivos reales (en Parquet, ORC o Avro) que permanecen en tu data lake. Iceberg organiza su ubicación a través de los manifiestos.

Este diseño desacopla la lógica de la tabla de los archivos físicos y permite funcionalidades revolucionarias.

### Características Clave

Gracias a su arquitectura, Iceberg ofrece características que lo hacen indispensable:

-   **Transacciones ACID**: Las escrituras son atómicas (o se hacen todas o no se hace ninguna) y los lectores siempre ven una instantánea consistente. Olvídate de datos corruptos por escrituras concurrentes.
-   **Evolución del Esquema sin Dolor**: ¿Se requiere añadir, renombrar o reordenar una columna? Con Iceberg se hace en segundos y sin reescribir los archivos existentes. Es una funcionalidad que se da por sentada en bases de datos, pero era un dolor de cabeza en los data lakes tradicionales.
-   **Evolución de Particionado**: Puede cambiar la forma en que se organizan físicamente los datos en el almacenamiento (ej. pasar de particionar por `día` a por `mes`) sin tocar los datos antiguos. Las consultas seguirán funcionando sin problemas.
-   **"Time Travel" (Viaje en el Tiempo)**: Cada cambio en una tabla genera un nuevo "snapshot". Esto te permite consultar o incluso restaurar la tabla a cómo era en un momento específico del pasado. Es ideal para auditar, depurar pipelines o deshacer errores.
-   **"Hidden Partitioning" (Particionado Oculto)**: El usuario no necesita saber cómo están particionados los archivos para hacer una consulta rápida. Iceberg lo gestiona automáticamente, evitando errores humanos en las queries.

### Casos de Uso y el Ecosistema Actual

-   **Casos de Uso**:
    -   **Data Lakehouses**: La arquitectura para la que fue diseñado, uniendo lo mejor de data lakes y data warehouses.
    -   **Machine Learning (ML)**: Proporciona datasets versionados y consistentes para entrenar modelos reproducibles.
    -   **Auditoría y Cumplimiento**: Gracias al "time travel", puedes justificar el estado de los datos en cualquier momento.
-   **Adopción en la Industria**: Iceberg se ha convertido en un estándar de la industria. Grandes tecnológicas como Apple, Netflix y LinkedIn lo usan internamente, y todos los grandes proveedores de nube y datos le dan soporte nativo: AWS (Athena, EMR, Redshift), Google Cloud (BigLake, BigQuery), Snowflake, Databricks y Oracle. Esto lo convierte en una excelente opción para evitar la dependencia de un único proveedor.
-   **Motores Compatibles**: Funciona con prácticamente cualquier motor de procesamiento moderno: Apache Spark, Apache Flink, Trino, Presto, Hive, Impala, y DuckDB, entre otros.

### Iceberg vs. Otras Tecnologías

Es muy común confundir a Iceberg con otras tecnologías, pero la diferencia es clave:
-   **Es un Formato de Tabla, no un motor de ejecución**: No debe compararlo con Spark o Trino (que son motores de cómputo). Iceberg es el *estándar* sobre el que estos motores leen y escriben.
-   **Es un estándar abierto**: A menudo se le compara con **Delta Lake** (de Databricks) y **Apache Hudi** (de Uber). Aunque los tres solucionan problemas similares, Iceberg es el único que nació con una especificación completamente abierta y sin depender de una sola compañía, lo que le ha valido el respaldo unánime de la industria.

### Conclusión

Apache Iceberg no es solo una herramienta más; es un cambio de paradigma. Es el estándar que permite construir **Lakehouses abiertos, fiables y de alto rendimiento** sobre los data lakes de hoy.

