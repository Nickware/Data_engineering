# Instalación de Apache NiFi

Paso a paso para instalar, configurar y testear Apache NiFi en Ubuntu usando únicamente la terminal y navegador web. Este flujo cubre desde la descarga hasta una prueba básica de funcionalidad.

## 1. Prerrequisitos: Instalación de Java

Apache NiFi requiere Java (OpenJDK recomendado). Verificar si se tiene Java instalado con:

```bash
java -version
```

Si no está instalado, ejecutar:

```bash
sudo apt update
sudo apt install openjdk-11-jdk -y
```

Confirmar la ruta de instalación con:

```bash
readlink -f $(which java)
```

Se debe obtener algo como `/usr/lib/jvm/java-11-openjdk-amd64/bin/java`.

## 2. Descargar Apache NiFi

Descargar la versión más reciente desde la página oficial o usar `wget` (ejemplo, versión 1.13.2):

```bash
wget https://downloads.apache.org/nifi/1.13.2/nifi-1.13.2-bin.tar.gz
```

(Consejo: Para la última versión, revisa la sección Download en https://nifi.apache.org/)[^1][^2][^3]

## 3. Instalar Apache NiFi

Extraer el archivo descargado y moverlo a `/opt`:

```bash
sudo tar -xvzf nifi-1.13.2-bin.tar.gz
sudo mv nifi-1.13.2 /opt/nifi
```


## 4. Configurar la variable JAVA_HOME (si es necesario)

Edita el archivo de entorno de NiFi si aparece una advertencia sobre JAVA_HOME:

```bash
sudo nano /opt/nifi/bin/nifi-env.sh
```

Agregar o editar la línea:

```bash
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

Guardar y cerrar.

## 5. (Opcional) Instalar como Servicio del Sistema

Esto permite manejar NiFi como un servicio estándar de Linux[^1]:

```bash
cd /opt/nifi
sudo bin/nifi.sh install
```

Ahora puede iniciar/parar/consultar con:

```bash
sudo service nifi start
sudo service nifi stop
sudo service nifi status
```


## 6. Iniciar Apache NiFi manualmente (alternativo)

Si no quiere el servicio:

```bash
cd /opt/nifi/bin
./nifi.sh start
```

Para ver el estado:

```bash
./nifi.sh status
```

Para detener:

```bash
./nifi.sh stop
```


## 7. Acceder a la Interfaz Web

NiFi expone una UI en el puerto `8080` por defecto:
Abrir el navegador y visitar:

```
http://localhost:8080/nifi
```

Si es un servidor remoto, usar la IP correspondiente, por ejemplo:

```
http://192.168.1.100:8080/nifi
```


## 8. Testear la funcionalidad básica

- Se debera ver la interfaz gráfica de NiFi.
- Probar arrastrar un procesador (“Processor”), con botón derecho -> Add Processor.
- Seleccionar, por ejemplo, `GenerateFlowFile`, conéctarlo a un `LogAttribute` y enlázarlo.
- Darle play al flujo y revisar que los logs aparecen correctamente.


### Notas Importantes

- Para proyectos productivos, configurar seguridad y cambiar el puerto si es necesario en `/opt/nifi/conf/nifi.properties`.
- Consultar logs en `/opt/nifi/logs/` si algo no funciona.
- El primer arranque puede demorar algunos segundos.

Este flujo básico deja NiFi completamente operativo en Ubuntu y capaz de procesar flujos de datos utilizando solo software libre[^1][^2][^4][^3].

<div style="text-align: center">⁂</div>

[^1]: https://nifi.apache.org/docs/nifi-docs/html/getting-started.html

[^2]: https://www.tecmint.com/install-apache-nifi-in-ubuntu/

[^3]: https://nifi.apache.org/nifi-docs/getting-started.html

[^4]: https://bobcares.com/blog/apache-nifi-on-ubuntu/

[^5]: https://nifi.apache.org

[^6]: https://www.reddit.com/r/nifi/comments/1c9dvzp/nifi_quick_setup_in_ubuntu_local/

[^7]: https://www.youtube.com/watch?v=dYFOluBIMMs

[^8]: https://community.cloudera.com/t5/Support-Questions/Apache-Nifi-1-17-0-installation-on-Linux-ubuntu-18-04/td-p/349413

[^9]: https://courses.cs.ut.ee/2021/cloud/spring/Main/Practice11

[^10]: https://techexpert.tips/es/apache-nifi-es/apache-nifi-instalacion-en-ubuntu-linux/

[^11]: https://community.cloudera.com/t5/Support-Questions/Learning-nifi-and-testing-between-2-laptop/td-p/383519

[^12]: https://blog.devgenius.io/installing-apache-nifi-2-0-0-m1-on-ubuntu-20-04-ec40ca9e10b1

[^13]: https://stackoverflow.com/questions/57062240/how-can-apache-nifi-flow-be-tested

[^14]: https://community.cloudera.com/t5/Support-Questions/Learning-nifi-and-testing-between-2-laptop/m-p/383562/highlight/true

[^15]: https://gist.github.com/shraddha-kr/b72e7a39e95a85ff025c6a586be2def9

