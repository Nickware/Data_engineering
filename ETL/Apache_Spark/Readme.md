# Instalación de Apache Spark

Paso a paso para instalar, configurar y testear Apache Spark en Ubuntu usando únicamente la terminal y navegador web. Este flujo cubre desde la descarga hasta una prueba básica de funcionalidad.

## 1. Actualizar el sistema

Asegúrarte de que el sistema esté actualizado.

```bash
sudo apt update && sudo apt upgrade -y
```

## 2. Instalar Java (opcional)

Si no está instalado, ejecutar:

```bash
sudo apt update
# verificar que versión esta disponible en el repositorio e instalar la mas reciente
sudo apt search opendjk
sudo apt install openjdk-21-jdk -y
```

Verifica la instalación de Java:

```bash
java -version
```

Se debe obtener algo como `/usr/lib/jvm/java-11-openjdk-amd64/bin/java`.

## 3. Descargar Apache Spark

Descarga la última versión de Apache Spark desde el sitio oficial o usar `wget` (ejemplo, versión 1.13.2):

```bash
wget https://dlcdn.apache.org/spark/spark-4.0.0/spark-4.0.0-bin-hadoop3.tgz
```

(Reemplazar `4.0.0` con la versión más reciente si es necesario).

## 4. Extraer el archivo descargado

Extraer el archivo descargado y moverlo a `/opt`:

```bash
tar -xzf spark-3.3.1-bin-hadoop3.tgz
sudo mv spark-3.3.1-bin-hadoop3 /opt/spark
```
## 5. Configurar variables de entorno

Editar el archivo `.bashrc `para agregar las variables de entorno:

```bash
nano ~/.bashrc
```
Agregar las siguientes líneas al final del archivo:

```bash
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin
```
Guardar y cerrar el archivo, luego ejecutar:

```bash
source ~/.bashrc
```

## 6. Verificar la instalación

Ejecutar el siguiente comando para verificar que Spark esté instalado correctamente
```bash
spark-shell
```
Debería ver la consola de Spark.
