# Instalar Apache Flink 

Guía paso a paso para instalar **Apache Flink** en Linux (modo standalone para desarrollo):

---

### **1. Prerrequisitos**

#### **Instalar Java** (Flink requiere Java 8 u 11):
```bash
sudo apt update
sudo apt install openjdk-11-jdk -y
```

#### **Verificar Java**:
```bash
java -version
```

#### **Configurar JAVA_HOME**:
```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
```

---

### **2. Descargar e instalar Apache Flink**

#### **Descargar Flink**:
```bash
cd ~
wget https://downloads.apache.org/flink/flink-1.17.1/flink-1.17.1-bin-scala_2.12.tgz
```

#### **Extraer y mover**:
```bash
tar -xzf flink-1.17.1-bin-scala_2.12.tgz
sudo mv flink-1.17.1 /opt/flink
```

#### **Configurar permisos**:
```bash
sudo chown -R $USER:$USER /opt/flink
```

---

### **3. Configurar variables de entorno**

Editar `~/.bashrc`:
```bash
nano ~/.bashrc
```

Agregar al final:
```bash
# Flink Environment Variables
export FLINK_HOME=/opt/flink
export PATH=$PATH:$FLINK_HOME/bin
```

Aplicar los cambios:
```bash
source ~/.bashrc
```



---

### **4. Configurar Flink (Opcional)**

#### **Configurar memoria** (editar `conf/flink-conf.yaml`):
```bash
cd $FLINK_HOME
nano conf/flink-conf.yaml
```

Modificar o agrega:
```yaml
# Memoria para JobManager
jobmanager.memory.process.size: 1024m

# Memoria para TaskManager  
taskmanager.memory.process.size: 1024m

# Número de slots por TaskManager
taskmanager.numberOfTaskSlots: 2

# Parallelismo por defecto
parallelism.default: 2
```

---

### **5. Iniciar Flink en modo standalone**

#### **Iniciar cluster**:
```bash
$FLINK_HOME/bin/start-cluster.sh
```

#### **Verificar estado**:
```bash
$FLINK_HOME/bin/flink list
```

#### **Verificar procesos**:
```bash
jps
```
Deberías ver:
```
StandaloneSessionClusterEntrypoint
TaskManagerRunner
```

---

### **6. Acceder a la interfaz web**

Abrir tu navegador en:
```
http://localhost:8081
```

Deberías ver el **Dashboard de Flink** con información del cluster.

---

### **7. Probar Flink con ejemplos**

#### **Ejecutar ejemplo de WordCount**:
```bash
# Enviar job de ejemplo
$FLINK_HOME/bin/flink run $FLINK_HOME/examples/streaming/WordCount.jar

# Con entrada de parámetros
$FLINK_HOME/bin/flink run $FLINK_HOME/examples/streaming/WordCount.jar --input $FLINK_HOME/README.txt --output /tmp/wordcount-output
```

#### **Ver resultados**:
```bash
cat /tmp/wordcount-output
```

---

### **8. Ejecutar un job personalizado**

#### **Crear archivo Python** (para PyFlink):
```bash
cat > wordcount.py << 'EOF'
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.datastream.connectors import FileSource, StreamFormat
from pyflink.common import SimpleStringSchema, WatermarkStrategy

env = StreamExecutionEnvironment.get_execution_environment()
env.add_jars("file:///opt/flink/lib/flink-connector-files-1.17.1.jar")

# Crear source
ds = env.from_collection(["hello world", "hello flink", "flink is great"])

# Transformaciones
result = ds.flat_map(lambda line: line.split()) \
    .map(lambda word: (word, 1)) \
    .key_by(lambda x: x[0]) \
    .reduce(lambda a, b: (a[0], a[1] + b[1]))

# Imprimir resultado
result.print()

# Ejecutar
env.execute("WordCount Python")
EOF
```

#### **Ejecutar job Python**:
```bash
$FLINK_HOME/bin/flink run -py wordcount.py
```

---

### **9. Modo sesión interactiva**

#### **Iniciar SQL Client**:
```bash
$FLINK_HOME/bin/sql-client.sh
```

#### **Ejemplos en SQL Client**:
```sql
-- Crear tabla
CREATE TABLE Words (
    word STRING
) WITH (
    'connector' = 'datagen',
    'fields.word.length' = '5'
);

-- Consultar
SELECT word, COUNT(*) as count 
FROM Words 
GROUP BY word;
```

---

### **10. Detener Flink**

```bash
$FLINK_HOME/bin/stop-cluster.sh
```

---

### **Instalación con Docker (Alternativa)**

#### **Usar Docker Compose**:
```bash
mkdir flink-docker && cd flink-docker

cat > docker-compose.yml << 'EOF'
version: "2.2"
services:
  jobmanager:
    image: flink:1.17.1-scala_2.12
    ports:
      - "8081:8081"
    command: jobmanager
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        taskmanager.numberOfTaskSlots: 2
        
  taskmanager:
    image: flink:1.17.1-scala_2.12
    depends_on:
      - jobmanager
    command: taskmanager
    scale: 1
    environment:
      - |
        FLINK_PROPERTIES=
        jobmanager.rpc.address: jobmanager
        taskmanager.numberOfTaskSlots: 2
EOF

docker-compose up -d
```

---

### **Comandos útiles**

```bash
# Ver jobs ejecutándose
$FLINK_HOME/bin/flink list

# Cancelar job
$FLINK_HOME/bin/flink cancel <jobID>

# Ver logs
tail -f $FLINK_HOME/log/flink-*-standalonesession-*.log

# Configurar más TaskManagers
$FLINK_HOME/bin/taskmanager.sh start
```

---

### **Solución de problemas**

#### **Error: Puerto 8081 ocupado**:
```bash
# Cambiar puerto en flink-conf.yaml
rest.port: 8082
```

#### **Error: Java no encontrado**:
Verificar `JAVA_HOME` en `~/.bashrc`.

#### **Error: Memoria insuficiente**:
Aumentar en `conf/flink-conf.yaml`:
```yaml
taskmanager.memory.process.size: 2048m
jobmanager.memory.process.size: 2048m
```

