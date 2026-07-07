# Apache Hop

**Apache Hop** es una plataforma de orquestación de datos de código abierto, diseñada para ser el sucesor moderno y flexible de Pentaho Data Integration (Kettle) .

Nació en 2019 como un fork (rama independiente) del proyecto Kettle, creado por miembros del equipo original de desarrollo de Kettle . Su objetivo principal es superar las limitaciones de su predecesor, adoptando prácticas modernas de desarrollo y operación. En 2022, se convirtió en un proyecto de primer nivel de la Apache Software Foundation .

A continuación, se presenta caracteristicas detalladas de Apache Hop

| Característica                      | Apache Hop                                                   |
| :---------------------------------- | :----------------------------------------------------------- |
| **Origen**                          | Fork del proyecto Kettle creado en 2019 .                    |
| **Principios de Diseño**            | Orientado a metadatos, nativo de la nube y extensible .      |
| **Interfaz Gráfica (GUI)**          | **Hop GUI**. Utiliza un lienzo y menú contextual con botón derecho para añadir transforms . |
| **Unidad Principal**                | **Pipeline** (equivalente a una transformación) .            |
| **Ejecución por Línea de Comandos** | `hop-run`: una sola herramienta para ejecutar pipelines y workflows . |
| **Servidor Remoto**                 | **Hop Server**. Expone una **API RESTful** (usa JSON) para una integración moderna (e.g., con Airflow) . |
| **Gestión de Proyectos**            | **Abierta y nativa**. Los metadatos se guardan como archivos legibles, facilitando el uso de **Git** para control de versiones y la integración en entornos cloud (e.g., S3) . |
| **Modelo de Ejecución**             | Ejecuta pipelines y workflows de forma nativa. Puede llevar estos mismos artefactos a motores de big data como **Spark o Flink** sin reescribirlos . |

### Componentes y arquitectura

Hop se compone de varias piezas que trabajan en conjunto :
*   **Hop GUI**: Es el entorno de desarrollo visual de escritorio donde diseñarás tus procesos (pipelines y workflows) .
*   **Hop Run**: Es la herramienta para ejecutar tus procesos desde la línea de comandos, ideal para automatización .
*   **Hop Server**: Es un servicio ligero que expone una **API RESTful** . Permite ejecutar y monitorear procesos de forma remota, lo que facilita su integración en arquitecturas modernas .
*   **Hop Web**: Es la interfaz de usuario basada en navegador que permite acceder y operar el servidor, también utilizada para administración .

### Proyecto: Pipeline de datos con Apache Hop

Un proyecto típico con Apache Hop tendría como objetivo construir un pipeline de datos (ETL) usando su interfaz visual (Hop GUI). Por ejemplo, un flujo que lea un archivo CSV, realice transformaciones como limpieza y filtrado, y finalmente escriba los resultados en archivos de texto separados .

El flujo de trabajo sería el siguiente:
1.  **Preparación**: Asegurar que Java 11 o 21 esté instalado. Descargar Apache Hop y descomprimirlo .
2.  **Diseño**: Abrir Hop GUI y crear un nuevo pipeline. Usar los transforms (componentes) como `CSV File Input`, `Select Values`, `Filter rows` y `Text File Output`, conectándolos en el lienzo para definir el flujo de datos .
3.  **Ejecución**: Ejecutar el pipeline directamente desde el GUI para probarlo o usar la herramienta `hop-run` desde la terminal para una ejecución automatizada .

### ¿Por qué elegir Apache Hop?

*   **Moderno y Abierto**: Su arquitectura orientada a metadatos y el uso de formatos de archivo estándar lo hacen perfecto para equipos que ya usan **Git, CI/CD y entornos cloud** .
*   **Integración Superior**: La API RESTful y la arquitectura limpia lo convierten en un candidato mucho más robusto para ser el motor de ejecución de tareas ETL orquestadas por herramientas como **Apache Airflow**, como se demuestra en casos de uso real .
*   **Sin Vendor Lock-in**: Al ser un proyecto Apache de código abierto, no dependes de una empresa específica, y la comunidad activa garantiza su evolución .
*   **Enfoque Cloud-Native**: Su diseño permite ejecutar los mismos pipelines en motores de big data como **Spark y Flink** .

Apache Hop no es solo un clon, sino una evolución. Corrige muchas de las rigideces de Kettle/PDI y lo prepara para las prácticas actuales de la ingeniería de datos.

A continuación se presenta un caso de estudio detallado que integra **Apache Spark**, **Apache Kafka** y **Apache Hop** en una arquitectura de procesamiento de datos en tiempo real para monitoreo IoT.

---

## Caso de Estudio: Plataforma de Monitoreo de Sensores Industriales en Tiempo Real

### Contexto del Problema

Una planta industrial necesita monitorear **500 sensores** que miden temperatura, vibración y presión en maquinaria crítica. El objetivo es:
- Detectar anomalías en **tiempo real** (latencia < 5 segundos)
- Procesar **1,000 eventos por segundo** en horas pico
- Almacenar datos históricos para **análisis predictivo**
- Integrarse con sistemas legacy (bases de datos locales)

### Arquitectura de la Solución

```
┌─────────────────────────────────────────────────────────────────┐
│                         CAPA DE INGESTA                          │
│  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐  │
│  │   Sensores   │─────▶│ Apache Kafka │      │  Apache Hop  │  │
│  │     IoT      │      │   (Broker)   │      │ (Kafka Cons.)│  │
│  └──────────────┘      └──────────────┘      └──────┬───────┘  │
│                                                      │          │
├─────────────────────────────────────────────────────┼──────────┤
│                    CAPA DE PROCESAMIENTO             │          │
│  ┌──────────────┐      ┌──────────────┐            │          │
│  │ Apache Spark │◀─────│ Apache Hop   │────────────┘          │
│  │ (Streaming)  │      │ (Pipeline    │                        │
│  └──────┬───────┘      │  de limpieza)│                        │
│         │              └──────────────┘                        │
│         ▼                                                      │
├─────────────────────────────────────────────────────────────────┤
│                    CAPA DE ALMACENAMIENTO                       │
│  ┌──────────────┐      ┌──────────────┐                        │
│  │   Delta      │      │  PostgreSQL  │                        │
│  │   Lake       │      │  (Alertas)   │                        │
│  └──────────────┘      └──────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

---

### Componentes y su Rol

#### 1. **Apache Kafka: El Bus de Eventos**
- Función: Recibir y bufferizar los datos de sensores en tiempo real
- Configuración: 
  - 3 particiones por tópico para procesamiento paralelo
  - Retención de datos: 7 días para reprocesamiento
- Tópicos creados:
  - `raw-sensor-data`: Datos crudos de sensores
  - `anomaly-alerts`: Alertas generadas

#### 2. **Apache Hop: El Transformador Visual**
Apache Hop actúa como el **orquestador de transformaciones iniciales** usando su interfaz visual .

**Pipeline de transformación en Hop:**

```
[Kafka Consumer] → [Field Mapper] → [Data Validator] → [Kafka Producer (clean-data)]
```

**Configuración del Kafka Consumer en Hop** :

- **Bootstrap servers**: `localhost:9092`
- **Tópico de suscripción**: `raw-sensor-data`
- **Consumer group**: `sensor-processors`
- **Batch settings**: 
  - Duración: 2000ms
  - Número de registros: 500 (el que se cumpla primero)

**Transformaciones realizadas en Hop**:
1. **Filtrar valores nulos**: Eliminar lecturas sin timestamp
2. **Convertir unidades**: °C a Kelvin, PSI a Pa
3. **Validación de rangos**: Temperatura > -50°C y < 150°C
4. **Enriquecimiento**: Agregar metadata del sensor (ubicación, tipo)

#### 3. **Apache Spark: El Procesador Inteligente**
Spark consume los datos limpios del tópico `clean-sensor-data` y realiza:

**Streaming estructurado con Kafka** :

```python
from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col, window

spark = SparkSession.builder \
    .appName("SensorAnomalyDetection") \
    .getOrCreate()

# Leer stream desde Kafka
df = spark.readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "clean-sensor-data") \
    .load()

# Parsear JSON
schema = "sensor_id STRING, temperature FLOAT, vibration FLOAT, timestamp TIMESTAMP"
parsed = df.select(from_json(col("value").cast("string"), schema).alias("data")).select("data.*")

# Detectar anomalías (ventana de 1 minuto)
anomalies = parsed \
    .withWatermark("timestamp", "10 seconds") \
    .groupBy(
        window(col("timestamp"), "1 minute"),
        col("sensor_id")
    ) \
    .agg(
        avg("temperature").alias("avg_temp"),
        stddev("temperature").alias("stddev_temp")
    ) \
    .where(col("avg_temp") > 100)  # Umbral de alerta
```

**Procesamiento en lote para ML**: Spark también ejecuta jobs diarios para entrenar modelos predictivos con datos históricos .

---

### Flujo de Datos Detallado

| **Paso** | **Tecnología**       | **Acción**                          | **Output**                               |
| -------- | -------------------- | ----------------------------------- | ---------------------------------------- |
| 1        | Sensores IoT         | Envían datos MQTT                   | JSON: `{sensor_id, temp, vibration, ts}` |
| 2        | Kafka Producer       | Publica en tópico `raw-sensor-data` | Mensajes en Kafka                        |
| 3        | Hop (Kafka Consumer) | Consume en batches de 500 o 2s      | DataFrame interno                        |
| 4        | Hop (Transform)      | Limpia, valida, enriquece           | Datos normalizados                       |
| 5        | Hop (Kafka Producer) | Publica en `clean-sensor-data`      | Mensajes limpios                         |
| 6        | Spark Streaming      | Detecta anomalías en ventanas       | Alertas en tiempo real                   |
| 7        | Spark Batch (diario) | Entrena modelos predictivos         | Modelos ML actualizados                  |

---

### Beneficios de la Integración

| **Tecnología** | **Aporte específico**                   | **Valor agregado**                              |
| -------------- | --------------------------------------- | ----------------------------------------------- |
| **Kafka**      | Buffer distribuido y replay de datos    | Tolerancia a fallos: 0 pérdida de eventos       |
| **Hop**        | Transformación visual y multi-motor     | Los mismos pipelines funcionan en Spark/Flink   |
| **Spark**      | Procesamiento en memoria y ML integrado | Latencia < 5 segundos para 1000 eventos/segundo |

> **Dato relevante**: Empresas como Miro procesan ~3.5 mil millones de eventos por día usando arquitecturas similares (Kafka + Spark), demostrando la escalabilidad de este stack .

---

### Configuración Técnica de Referencia

#### Crear tópicos en Kafka:
```bash
kafka-topics.sh --create --topic raw-sensor-data --partitions 3 --replication-factor 1
kafka-topics.sh --create --topic clean-sensor-data --partitions 3 --replication-factor 1
```

#### Pipeline de Hop (configuración YAML simplificada):
```yaml
pipeline:
  - transform: KafkaConsumer
    properties:
      bootstrap.servers: "localhost:9092"
      topics: "raw-sensor-data"
      consumer.group: "sensor-group"
      batch.size: 500
      batch.duration.ms: 2000
  - transform: FieldMapper
    properties:
      fields: ["temperature", "vibration"]
      conversions: ["celsius_to_kelvin", "none"]
  - transform: KafkaProducer
    properties:
      topic: "clean-sensor-data"
```

#### Spark Job (producción):
```python
query = parsed.writeStream \
    .outputMode("append") \
    .format("parquet") \
    .option("path", "/data/sensor-lake") \
    .option("checkpointLocation", "/checkpoints/") \
    .trigger(processingTime="10 seconds") \
    .start()
```

---

### Posibles Extensiones

1. **Orquestación con Airflow**: Para gestionar dependencias entre jobs batch y streaming
2. **Hop + Delta Lake**: Los pipelines de Hop pueden escribir directamente en tablas Delta para consultas ACID
3. **Hop + Feature Store**: Integración con Hopsworks para gestión de features de ML 

---

### Conclusión

Este caso demuestra cómo **Hop actúa como el "pegamento visual"** entre Kafka (ingesta) y Spark (procesamiento intensivo), aprovechando lo mejor de cada tecnología:

- **Kafka** para ingesta confiable y replay
- **Hop** para transformaciones visuales y multi-engine (ejecuta en Spark si es necesario) 
- **Spark** para cómputo distribuido y ML

La combinación permite construir pipelines **mantenibles** (por el approach visual de Hop) y **escalables** (por la capacidad de Spark/Kafka) .
