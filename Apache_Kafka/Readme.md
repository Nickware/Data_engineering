# Instalación de Apache Kafka

Apache Kafka es una plataforma de streaming de datos que actúa como un sistema de mensajería distribuida. Paso a paso para instalar, configurar y testear Apache Kafka en Ubuntu usando únicamente la terminal . Este flujo cubre desde la descarga hasta una prueba básica de funcionalidad.

## 1. Descargar Kafka

Descargar la última versión de Kafka desde el sitio oficial:

```bash
wget https://downloads.apache.org/kafka/3.4.0/kafka_2.13-3.4.0.tgz
```
(Reemplazar `3.4.0` con la versión más reciente si es necesario).

## 2. Extraer el archivo descargado

```bash
tar -xzf kafka_2.13-3.4.0.tgz
sudo mv kafka_2.13-3.4.0 /opt/kafka
```

## 3. Configurar variables de entorno

Editar `~/.bashrc` y agrega:

```bash
export KAFKA_HOME=/opt/kafka
export PATH=$PATH:$KAFKA_HOME/bin
```
Luego, ejecutar:
```bash
source ~/.bashrc
```

## 4. Iniciar Zookeeper

Kafka depende de Zookeeper para la coordinación. Iniciar Zookeeper:

```bash
$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties
```

## 5. Iniciar Kafka

En otra terminal, iniciar Kafka:

```bash
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
```

## 6. Crear un tópico de Kafka

Crear un tópico llamado `test-topic`:

```bash
$KAFKA_HOME/bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
```

---

