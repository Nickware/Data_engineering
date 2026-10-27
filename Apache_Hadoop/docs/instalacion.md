# Instalación y configuración de Apache Hadoop

Guía para instalar Apache Hadoop 3.3.6 en modo pseudo-distribuido de un solo nodo en Linux. En este modo, los componentes de HDFS y YARN se ejecutan como procesos separados en la misma máquina; es una configuración de aprendizaje, no de producción.

## 1. Prerrequisitos

### Instalar Java

Esta receta utiliza OpenJDK 11 en Ubuntu/Debian:

```bash
sudo apt update
sudo apt install openjdk-11-jdk -y
```

Verificar la instalación:

```bash
java -version
```

Configurar `JAVA_HOME`:

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc
```

### Crear usuario para Hadoop

Es recomendable ejecutar Hadoop con un usuario dedicado. Créalo desde una cuenta con permisos `sudo`:

```bash
sudo adduser hadoopuser
sudo usermod -aG sudo hadoopuser
su - hadoopuser
```

Los pasos restantes se ejecutan como `hadoopuser`, salvo que se indique lo contrario.

## 2. Descargar e instalar Hadoop

Descargar Hadoop 3.3.6:

```bash
cd ~
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
```

Extraerlo, moverlo a `/opt` y dar propiedad al usuario de Hadoop:

```bash
tar -xzf hadoop-3.3.6.tar.gz
sudo mv hadoop-3.3.6 /opt/hadoop
sudo chown -R "$USER:$USER" /opt/hadoop
```

## 3. Configurar variables de entorno

Agregar estas variables al final de `~/.bashrc`:

```bash
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

Aplicar los cambios:

```bash
source ~/.bashrc
```

## 4. Configurar Hadoop

### Configurar `hadoop-env.sh`

```bash
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> "$HADOOP_HOME/etc/hadoop/hadoop-env.sh"
echo "export HADOOP_HOME=/opt/hadoop" >> "$HADOOP_HOME/etc/hadoop/hadoop-env.sh"
```

### Configurar `core-site.xml`

```bash
cat > "$HADOOP_HOME/etc/hadoop/core-site.xml" << EOF
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

### Configurar `hdfs-site.xml`

```bash
cat > "$HADOOP_HOME/etc/hadoop/hdfs-site.xml" << EOF
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

### Configurar `mapred-site.xml`

```bash
cat > "$HADOOP_HOME/etc/hadoop/mapred-site.xml" << EOF
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

### Configurar `yarn-site.xml`

```bash
cat > "$HADOOP_HOME/etc/hadoop/yarn-site.xml" << EOF
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

## 5. Configurar SSH sin contraseña

Hadoop usa SSH local para que los scripts de gestión puedan iniciar procesos. Generar y autorizar una clave para el usuario `hadoopuser`:

```bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
```

Comprobar el acceso:

```bash
ssh localhost
```

La conexión debe completarse sin solicitar contraseña. Si no está disponible el servicio SSH, instala y activa el servidor SSH de la distribución antes de continuar.

## 6. Formatear HDFS

Crear los directorios locales donde NameNode y DataNode almacenarán sus datos, y formatear el NameNode:

```bash
mkdir -p /opt/hadoop/data/namenode
mkdir -p /opt/hadoop/data/datanode
hdfs namenode -format
```

El formateo es para inicializar una instalación nueva. No vuelvas a formatear un NameNode que ya contenga datos que quieras conservar.

## 7. Iniciar Hadoop

Iniciar HDFS y luego YARN:

```bash
start-dfs.sh
start-yarn.sh
```

Comprobar los procesos:

```bash
jps
```

Deberían aparecer procesos como:

```text
NameNode
DataNode
SecondaryNameNode
ResourceManager
NodeManager
```

## 8. Verificar la instalación

Interfaz web del NameNode:

```text
http://localhost:9870
```

Interfaz web del ResourceManager:

```text
http://localhost:8088
```

Probar HDFS:

```bash
hdfs dfs -mkdir /test
hdfs dfs -ls /
hdfs dfs -put "$HADOOP_HOME"/etc/hadoop/*.xml /test
hdfs dfs -ls /test
```

## 9. Ejecutar un ejemplo de MapReduce

El comando de Streaming incluido en Hadoop ejecuta programas externos como mapper y reducer. Este ejemplo procesa líneas y agrupa líneas idénticas; no es un contador de palabras:

```bash
hdfs dfs -mkdir /input
hdfs dfs -put "$HADOOP_HOME"/etc/hadoop/*.xml /input

mapred streaming \
  -input /input \
  -output /output \
  -mapper /bin/cat \
  -reducer /usr/bin/wc
```

Ver el resultado:

```bash
hdfs dfs -cat /output/*
```

HDFS no permite reutilizar un directorio de salida existente. Para volver a ejecutar el ejemplo, elimina `/output` primero si contiene resultados anteriores:

```bash
hdfs dfs -rm -r /output
```

## 10. Detener servicios y comandos útiles

Detener HDFS y YARN:

```bash
stop-dfs.sh
stop-yarn.sh
```

Consultar espacio en HDFS:

```bash
hdfs dfsadmin -report
```

Consultar los logs del NameNode:

```bash
tail -f "$HADOOP_HOME"/logs/hadoop-*-namenode-*.log
```

## Solución de problemas

### Puerto ocupado

Comprobar si algún proceso ya está usando el puerto RPC configurado para HDFS:

```bash
ss -ltnp | grep ':9000'
```

### Java no encontrado

Verificar `JAVA_HOME` en `~/.bashrc` y en `hadoop-env.sh`, volver a cargar la configuración del shell y comprobar `java -version`.

### Error de permisos SSH

Revisar los permisos del directorio y de `authorized_keys`:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
