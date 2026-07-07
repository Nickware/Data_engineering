

# Apache Lakehouse

Es una arquitectura de datos moderna que combina la flexibilidad y escalabilidad de un *Data Lake* (almacenamiento de bajo costo) con la confiabilidad y estructura de un *Data Warehouse*. Utiliza formatos de tabla abiertos como **Apache Iceberg**, **Delta Lake** o **Apache Hudi** para gestionar datos, permitiendo transacciones ACID, gobernanza y análisis en tiempo real en una misma plataforma. 

Un **Lakehouse** es una arquitectura de datos moderna que combina lo mejor de:
- **Data Lakes** (almacenamiento económico, datos brutos, múltiples formatos)
- **Data Warehouses** (gestión transaccional, ACID, SQL, performance)

---

## **Tecnologías Apache Clave para Lakehouse**

### **1. Apache Iceberg**
**Tablas abiertas para analytics a gran escala**

#### **Características**:
- **Formato de tabla abierta** para huge datasets
- **ACID compliance**: Transacciones atómicas
- **Time travel**: Consulta de datos históricos
- **Esquema evolutivo**: Cambios sin romper pipelines
- **Partition evolution**: Reorganización automática

#### **Instalación**:
```bash
# Con Spark
pyspark --packages org.apache.iceberg:iceberg-spark-runtime-3.5_2.12:1.4.2

# O instalar standalone
wget https://downloads.apache.org/iceberg/apache-iceberg-1.4.2/apache-iceberg-1.4.2-bin.tar.gz
```

#### **Ejemplo**:
```python
# Crear tabla Iceberg con Spark
spark.sql("""
CREATE TABLE local.db.sales (
    id bigint,
    sale_date date,
    amount decimal(10,2)
) USING iceberg
PARTITIONED BY (months(sale_date))
LOCATION 's3://my-bucket/sales/'
""")
```

---

### **2. Apache Hudi** (Hadoop Upserts Deletes and Incrementals)
**Gestión de datos transaccionales**

#### **Características**:
- **Upserts/Deletes**: Operaciones tipo CRUD en data lakes
- **Incremental processing**: Solo procesar datos nuevos
- **Compaction automática**: Optimización de archivos

#### **Instalación**:
```bash
spark-shell --packages org.apache.hudi:hudi-spark3.5-bundle_2.12:0.14.0
```

#### **Ejemplo**:
```scala
val hudiOptions = Map[String,String](
  "hoodie.table.name" -> "sales",
  "hoodie.datasource.write.operation" -> "upsert",
  "hoodie.datasource.write.recordkey.field" -> "id",
  "hoodie.datasource.write.partitionpath.field" -> "sale_date"
)
```

---

### **3. Delta Lake**
**Aunque es de Databricks, tiene versión open-source**

#### **Características**:
- Transacciones ACID en data lakes
- Time travel y versionado
- Merge, Update, Delete operaciones
- Escalabilidad de Spark

#### **Instalación**:
```bash
pip install delta-spark
```

#### **Ejemplo**:
```python
from delta import *
# Crear tabla Delta
df.write.format("delta").save("/data/delta-table")
# Time travel
spark.read.format("delta").option("versionAsOf", 0).load("/data/delta-table")
```

---

### **4. Apache Paimon** (antes Flink Table Store)
**Lakehouse streaming-first**

#### **Características**:
- Procesamiento batch + streaming unificado
- Alta velocidad de upserts
- Integración nativa con Flink

#### **Instalación**:
```bash
# Con Flink
wget https://downloads.apache.org/paimon/paimon-0.7/paimon-0.7.tgz
```

---

## **Arquitectura de un Lakehouse Apache Completo**

```
┌─────────────────────────────────────────────────────────────┐
│                    Capa de Servicio                         │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │ Trino   │  │ Spark   │  │ Flink   │  │ Presto  │       │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘       │
├─────────────────────────────────────────────────────────────┤
│                    Capa de Tablas                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Apache Iceberg / Hudi / Delta Lake           │  │
│  └──────────────────────────────────────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                    Capa de Almacenamiento                   │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │   S3    │  │  HDFS   │  │  ADLS   │  │  GCS    │       │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘       │
└─────────────────────────────────────────────────────────────┘
```

---

## **Proyecto Práctico: Lakehouse para E-Commerce**

### **Stack Tecnológico**:
- **Almacenamiento**: MinIO (S3 compatible, open-source)
- **Tablas**: Apache Iceberg
- **Procesamiento**: Apache Spark
- **Consulta**: Trino
- **Orquestación**: Apache Airflow

### **Instalación del Stack**:

#### **1. Instalar MinIO** (S3 compatible):
```bash
wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
./minio server /data/minio --console-address :9090
```

#### **2. Configurar Iceberg con Spark**:
```bash
cat > iceberg-spark.conf << 'EOF'
spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions
spark.sql.catalog.local=org.apache.iceberg.spark.SparkCatalog
spark.sql.catalog.local.type=hadoop
spark.sql.catalog.local.warehouse=s3a://warehouse/
spark.sql.defaultCatalog=local
EOF

spark-shell --properties-file iceberg-spark.conf
```

#### **3. Crear Tablas Iceberg**:
```sql
-- Tabla de órdenes
CREATE TABLE local.ecommerce.orders (
    order_id BIGINT,
    customer_id BIGINT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status STRING
) USING iceberg
PARTITIONED BY (months(order_date));

-- Tabla de productos
CREATE TABLE local.ecommerce.products (
    product_id BIGINT,
    category STRING,
    price DECIMAL(10,2),
    stock_quantity INT
) USING iceberg;
```

#### **4. Consultas con Trino**:
```sql
-- Instalar Trino con conector Iceberg
cat >> /opt/trino/etc/catalog/iceberg.properties << 'EOF'
connector.name=iceberg
iceberg.catalog.type=hadoop
iceberg.warehouse=s3://warehouse/
EOF
```

---

## **Comparativa de Tecnologías Lakehouse**

| **Tecnología**     | **Creador**   | **Fortalezas**                    | **Mejor para**           |
| ------------------ | ------------- | --------------------------------- | ------------------------ |
| **Apache Iceberg** | Netflix/Apple | Formato abierto, comunidad grande | Ecosistemas multi-motor  |
| **Apache Hudi**    | Uber          | Upserts/Deletes eficientes        | CDC, datos cambiantes    |
| **Delta Lake**     | Databricks    | Integración Spark, documentación  | Entornos Spark           |
| **Apache Paimon**  | Apache        | Streaming-first, Flink nativo     | Pipelines en tiempo real |

---

## **Tendencias Emergentes**

1. **Formatos abiertos**: Iceberg se está convirtiendo en estándar
2. **Unificación batch/streaming**: Paimon y Flink
3. **GPU acceleration**: Rapids, cuDF para procesamiento acelerado
4. **Serverless query engines**: Trino, Athena, BigQuery

---

## **Recursos para Aprender**

1. **Iceberg**: [iceberg.apache.org](https://iceberg.apache.org)
2. **Hudi**: [hudi.apache.org](https://hudi.apache.org)
3. **Delta Lake**: [delta.io](https://delta.io)
4. **Libro**: "Data Lakehouse in Action" (Manning)

