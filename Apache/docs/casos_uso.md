# Casos de uso de Apache HTTP Server

Estos ejercicios muestran dos formas de usar HTTPD junto con contenidos o servicios de datos: publicar un gráfico generado por R y colocar una capa de proxy delante de un recurso JSON. Se pueden realizar en una máquina local después de seguir la [guía de instalación](instalacion.md).

## Caso 1: publicar una gráfica de SDIS_SIRBE

El script `rscript_sirbe_4.R` genera una gráfica de distribución de beneficiarios por sexo en `/tmp/grafica.png`. Apache la puede servir como archivo estático para verla desde un navegador.

### Requisitos

- Apache HTTP Server instalado y en ejecución.
- R y los paquetes `ggplot2`, `scales` y `dplyr`.
- El archivo de datos `CargueSIRBEVejez.csv` disponible en `/tmp/SDIS_SIRBE/database/`, tal como requiere el script.

El CSV no está incluido en este repositorio. Usa únicamente datos para los que tengas autorización y publica resultados agregados o anonimizados. No expongas información personal de beneficiarios en un servidor accesible públicamente.

### Ejecución

Desde la raíz del repositorio, crea el directorio temporal que usa el script y ejecútalo:

```bash
mkdir -p /tmp/grafica
Rscript sdis_sirve/scripts_graficas/generales/rscript_sirbe_4.R
```

Copia el gráfico generado al directorio público de Apache:

```bash
sudo install -m 0644 /tmp/grafica.png /var/www/html/distribucion-sirbe.png
```

Comprueba la respuesta del servidor y abre la dirección en un navegador:

```bash
curl -I http://localhost/distribucion-sirbe.png
```

```text
http://localhost/distribucion-sirbe.png
```

Este ejemplo separa responsabilidades: R analiza y genera el gráfico; Apache solo publica el archivo resultante. El mismo patrón sirve para publicar reportes generados por procesos de Spark, Flink u otras herramientas, siempre que el proceso de exportación copie los artefactos a un directorio que HTTPD pueda servir.

## Caso 2: exponer un resultado JSON mediante proxy inverso

En este ejercicio, un servidor HTTP local representa un backend que entrega resultados de datos. Apache recibe las solicitudes por el puerto `8080` y las reenvía al backend, que escucha solo en `127.0.0.1:8001`.

### 1. Crear un resultado de ejemplo

En una primera terminal:

```bash
mkdir -p /tmp/resultado-datos
printf '%s\n' '{"origen":"demo-pipeline","estado":"completo","registros":3}' > /tmp/resultado-datos/resumen.json
python3 -m http.server 8001 --bind 127.0.0.1 --directory /tmp/resultado-datos
```

Deja ese proceso activo. El servidor integrado de Python solo entrega el archivo JSON; no ejecuta una transformación ni reemplaza una API de producción.

### 2. Configurar Apache como proxy inverso

Crea un archivo de configuración con este contenido:

```apache
Listen 8080

<VirtualHost *:8080>
    ProxyRequests Off
    ProxyPass "/datos/" "http://127.0.0.1:8001/"
    ProxyPassReverse "/datos/" "http://127.0.0.1:8001/"
</VirtualHost>
```

Guárdalo en la ruta correspondiente a tu distribución:

- Debian/Ubuntu: `/etc/apache2/conf-available/proxy-datos.conf`
- Fedora: `/etc/httpd/conf.d/proxy-datos.conf`

En Debian/Ubuntu, habilita los módulos y la configuración, valida y recarga Apache:

```bash
sudo a2enmod proxy proxy_http
sudo a2enconf proxy-datos
sudo apache2ctl configtest
sudo systemctl reload apache2
```

En Fedora, los módulos de proxy suelen estar incluidos en la configuración del paquete. Comprueba que estén cargados, valida la configuración y recarga el servicio:

```bash
sudo httpd -M | grep proxy
sudo httpd -t
sudo setsebool -P httpd_can_network_relay on
sudo systemctl reload httpd
```

El primer comando debe listar `proxy_module` y `proxy_http_module`. Si no aparecen, revisa los archivos de módulos de `/etc/httpd/conf.modules.d/` antes de continuar. El booleano de SELinux permite a HTTPD conectarse a su backend como proxy; no deshabilites SELinux para resolver problemas de conexión.

### 3. Verificar el proxy

En otra terminal, compara el backend directo con la URL publicada por Apache:

```bash
curl http://127.0.0.1:8001/resumen.json
curl http://localhost:8080/datos/resumen.json
```

Ambas solicitudes deben devolver el mismo JSON. En una arquitectura real, el backend podría ser una API que consulte resultados preparados por Spark o Flink. Apache solo reenvía HTTP; la autenticación, autorización y protección de datos deben configurarse antes de exponer servicios fuera de la máquina local.

## Referencias

- [Apache HTTP Server: documentación oficial 2.4](https://httpd.apache.org/docs/2.4/)
- [Apache HTTP Server: guía oficial de proxy inverso](https://httpd.apache.org/docs/2.4/howto/reverse_proxy.html)
- [Apache HTTP Server: documentación del módulo mod_proxy](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html)
