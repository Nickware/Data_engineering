# Apache HTTP Server

Apache HTTP Server (HTTPD) es un servidor web de código abierto desarrollado dentro de la Apache Software Foundation. Recibe solicitudes HTTP o HTTPS y responde con páginas, archivos u otros recursos web. Puede servir contenido estático directamente y, mediante módulos de proxy, reenviar solicitudes a aplicaciones y APIs que se ejecutan por separado.

Su papel es exponer contenido mediante la web; no es un motor para transformar datos, un sistema de mensajería ni un orquestador. Por eso complementa, pero no sustituye, tecnologías como Kafka, Spark, Flink, NiFi o Airflow.

## Papel en una plataforma de datos

Una plataforma puede usar varias herramientas en etapas diferentes: NiFi o Kafka reciben y mueven datos; Spark o Flink los procesan; Hadoop, Iceberg o Hudi ayudan a almacenarlos; y Airflow puede coordinar ejecuciones. Apache HTTP Server puede ocupar una capa de publicación al final, por ejemplo:

- Servir páginas HTML, documentación o reportes estáticos generados a partir de resultados analíticos.
- Publicar archivos disponibles para descarga en una red interna.
- Actuar como proxy inverso delante de una aplicación o API de análisis.

La conexión entre estas piezas depende de la arquitectura: HTTPD no consume automáticamente tópicos de Kafka ni lee tablas Iceberg o Hudi. Una aplicación, un proceso de exportación o una API debe preparar el contenido que HTTPD servirá o al que reenviará las solicitudes. Airflow y NiFi, por su parte, ya cuentan con sus propias interfaces web para sus funciones habituales; no necesitan Apache HTTP Server para arrancar en una instalación básica.

## Documentación

- [Instalación y prueba en Debian/Ubuntu y Fedora](docs/instalacion.md): instalación del paquete, gestión del servicio, acceso local y notas de firewall y rutas de configuración.
- [Casos de uso ejecutables](docs/casos_uso.md): publicación de una gráfica creada por un script R de SDIS_SIRBE y proxy inverso para un resultado JSON de ejemplo, con instrucciones para ambas familias de distribuciones.

## Referencias

- [Documentación oficial de Apache HTTP Server 2.4](https://httpd.apache.org/docs/2.4/): configuración, módulos, seguridad y operación del servidor.
- [Guía oficial de proxy inverso](https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html): publicación de aplicaciones y servicios backend mediante HTTPD.
- [Módulo mod_proxy](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html): directivas `ProxyPass`, `ProxyPassReverse` y configuración de proxy.
