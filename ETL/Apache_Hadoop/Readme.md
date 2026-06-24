# Apache Hadoop

Apache Hadoop es un framework de código abierto diseñado específicamente para **almacenar y procesar volúmenes masivos de datos** (lo que conocemos como *Big Data*).

Fue creado inspirándose en documentos técnicos de Google de principios de los años 2000, cuando se dieron cuenta de que las bases de datos tradicionales no daban abasto con la explosión de información en la web.

Su filosofía principal es disruptiva pero simple: en lugar de gastar millones de dólares en una supercomputadora hiperpotente (escalabilidad vertical), Hadoop te permite conectar cientos o miles de computadoras comunes y corrientes (hardware comercial) para que trabajen en equipo como si fueran una sola (escalabilidad horizontal).

---

## ¿Cómo funciona? Los 3 pilares de Hadoop

Para entender a Hadoop, imagíne como un centro de distribución masivo. Está compuesto por tres componentes esenciales que resuelven los dos grandes problemas del Big Data: **dónde guardo tanto dato** y **cómo los proceso rápido**.

### 1. HDFS (Hadoop Distributed File System) - *El Almacenamiento*

Es el sistema de archivos distribuido. Cuando subes un archivo gigante (por ejemplo, de 1 Terabyte) a Hadoop, HDFS no lo guarda entero en un solo disco.

* **División:** Lo rompe en bloques más pequeños (típicamente de 128 MB).
* **Distribución:** Distribuye esos bloques a lo largo de los diferentes nodos (computadoras) del clúster.
* **Replicación (Tolerancia a fallos):** Por defecto, hace tres copias de cada bloque en computadoras distintas. Si una máquina se quema o falla en mitad de la noche, los datos no se pierden y el sistema sigue funcionando como si nada.

### 2. MapReduce - *El Procesamiento*

Es el motor que procesa los datos en paralelo. En lugar de llevar los datos hacia donde está el algoritmo de procesamiento (lo cual saturaría la red si hablamos de Petabytes), MapReduce hace lo inverso: **lleva el código hacia donde ya están guardados los datos**.

* **Map:** Cada computadora del clúster procesa de forma simultánea el pedazo de datos que tiene guardado localmente.
* **Reduce:** Se consolidan y resumen los resultados de todas las máquinas para entregarte la respuesta final.

### 3. YARN (Yet Another Resource Negotiator) - *El Orquestador*

Introducido en Hadoop 2.0, es el cerebro operativo o el "policía de tráfico" del sistema. Se encarga de administrar los recursos del clúster (cuánta memoria RAM y cuántos núcleos de CPU se le asignan a cada tarea de procesamiento) para que los recursos se distribuyan de forma eficiente y el sistema no colapse.

---

## ¿Por qué es tan importante? Sus grandes ventajas

* **Alta tolerancia a fallos:** El software está diseñado para asumir que el hardware va a fallar eventualmente. Maneja las caídas de servidores de forma automática sin interrumpir el trabajo.
* **Económico:** No requiere servidores especializados ni almacenamiento empresarial costoso (como redes SAN). Corre en servidores estándar.
* **Flexibilidad:** A diferencia de las bases de datos relacionales (SQL), en Hadoop puedes almacenar datos **no estructurados** o **semiestructurados** (videos, imágenes, logs de servidores, tweets, JSONs) sin necesidad de definir un esquema previo (*Schema-on-Read*).

## El ecosistema de Hadoop

Hoy en día, Hadoop casi nunca se usa solo; se complementa con un ecosistema de herramientas que facilitan la vida a los ingenieros de datos:

* **Apache Hive:** Permite hacer consultas usando sintaxis muy similar a SQL sobre los datos guardados en HDFS.
* **Apache Spark:** Un motor de procesamiento mucho más moderno y rápido que MapReduce porque realiza las operaciones en memoria RAM en lugar de escribir constantemente en los discos.
* **Apache HBase:** Una base de datos NoSQL diseñada para ofrecer acceso de lectura/escritura en tiempo real sobre HDFS.

# Instalar **Apache Hadoop** 

Guía paso a paso para instalar **Apache Hadoop** en modo **standalone** (desarrollo) en Linux. Esta configuración es ideal para aprender y desarrollar:

---

### **1. Prerrequisitos**

#### **Instalar Java** (Hadoop requiere Java 8 u 11):
```bash
sudo apt update
sudo apt install openjdk-11-jdk -y
```

#### **Verificar Java**:
```bash
java -version
```

#### **Configurar variables de Java**:
```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
```

---

### **2. Crear usuario para Hadoop (Opcional pero recomendado)**
```bash
sudo adduser hadoopuser
sudo usermod -aG sudo hadoopuser
su - hadoopuser
```

---

### **3. Descargar e instalar Hadoop**

#### **Descargar Hadoop**:
```bash
cd ~
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
```

#### **Extraer y mover**:
```bash
tar -xzf hadoop-3.3.6.tar.gz
sudo mv hadoop-3.3.6 /opt/hadoop
```

#### **Configurar permisos**:
```bash
sudo chown -R $USER:$USER /opt/hadoop
```

---

### **4. Configurar variables de entorno**

Edita `~/.bashrc`:
```bash
nano ~/.bashrc
```

Agrega al final:
```bash
# Hadoop Environment Variables
export HADOOP_HOME=/opt/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
```

Aplica los cambios:
```bash
source ~/.bashrc
```

---

### **5. Configurar Hadoop**

#### **Configurar `hadoop-env.sh`**:
```bash
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo "export HADOOP_HOME=/opt/hadoop" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
```

#### **Configurar `core-site.xml`**:
```bash
cat > $HADOOP_HOME/etc/hadoop/core-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>
EOF
```

#### **Configurar `hdfs-site.xml`**:
```bash
cat > $HADOOP_HOME/etc/hadoop/hdfs-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:///opt/hadoop/data/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:///opt/hadoop/data/datanode</value>
    </property>
</configuration>
EOF
```

#### **Configurar `mapred-site.xml`**:
```bash
cat > $HADOOP_HOME/etc/hadoop/mapred-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
EOF
```

#### **Configurar `yarn-site.xml`**:
```bash
cat > $HADOOP_HOME/etc/hadoop/yarn-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
        <value>org.apache.hadoop.mapred.ShuffleHandler</value>
    </property>
</configuration>
EOF
```

---

### **6. Configurar SSH sin contraseña**

#### **Generar clave SSH**:
```bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

#### **Probar SSH**:
```bash
ssh localhost
# Debería conectarse sin contraseña
exit
```

---

### **7. Formatear HDFS**

#### **Crear directorios de datos**:
```bash
mkdir -p /opt/hadoop/data/namenode
mkdir -p /opt/hadoop/data/datanode
```

#### **Formatear NameNode**:
```bash
hdfs namenode -format
```

---

### **8. Iniciar servicios de Hadoop**

#### **Iniciar HDFS**:
```bash
start-dfs.sh
```

#### **Iniciar YARN**:
```bash
start-yarn.sh
```

#### **Verificar procesos**:
```bash
jps
```
Deberías ver:
```
NameNode
DataNode
SecondaryNameNode
ResourceManager
NodeManager
```

---

### **9. Verificar instalación**

#### **Interfaz web del NameNode**:
Abre en tu navegador:
```
http://localhost:9870
```

#### **Interfaz web del ResourceManager**:
```
http://localhost:8088
```

#### **Probar HDFS**:
```bash
hdfs dfs -mkdir /test
hdfs dfs -ls /
hdfs dfs -put $HADOOP_HOME/etc/hadoop/*.xml /test
hdfs dfs -ls /test
```

---

### **10. Ejecutar un ejemplo de MapReduce**

#### **Ejecutar wordcount**:
```bash
hdfs dfs -mkdir /input
hdfs dfs -put $HADOOP_HOME/etc/hadoop/*.xml /input

mapred streaming \
  -input /input \
  -output /output \
  -mapper /bin/cat \
  -reducer /usr/bin/wc
```

#### **Ver resultados**:
```bash
hdfs dfs -cat /output/*
```

---

### **Comandos útiles**

```bash
# Detener servicios
stop-dfs.sh
stop-yarn.sh

# Reiniciar servicios
stop-all.sh
start-all.sh

# Ver espacio en HDFS
hdfs dfsadmin -report

# Ver logs
tail -f $HADOOP_HOME/logs/hadoop-*-namenode-*.log
```

---

### **Solución de problemas comunes**

#### **Error: Puerto ocupado**:
```bash
netstat -tulpn | grep :9000
```

#### **Error: Java no encontrado**:
Verifica `JAVA_HOME` en `hadoop-env.sh`.

#### **Error: Permisos SSH**:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
