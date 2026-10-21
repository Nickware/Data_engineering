# Instalación de Apache HTTP Server

Esta guía instala el servidor web Apache en distribuciones basadas en Debian (como Ubuntu) y Fedora. Los paquetes y nombres del servicio difieren entre familias: Debian/Ubuntu usa `apache2`, mientras Fedora usa `httpd`.

## Requisitos

- Una cuenta con permisos para ejecutar `sudo`.
- Una distribución con `systemd` y acceso a los repositorios de paquetes.
- Acceso a la máquina desde un navegador o una terminal para verificar el servicio.

## Debian y Ubuntu

Actualizar la información de paquetes e instalar Apache y `curl`:

```bash
sudo apt update
sudo apt install apache2 curl -y
```

Habilitar e iniciar el servicio:

```bash
sudo systemctl enable --now apache2
sudo systemctl status apache2 --no-pager
```

En una instalación local, probar la respuesta:

```bash
curl -I http://localhost
```

También se puede abrir `http://localhost` en un navegador de la misma máquina.

## Fedora

Instalar Apache y `curl` con `dnf`:

```bash
sudo dnf install httpd curl -y
```

Habilitar e iniciar el servicio:

```bash
sudo systemctl enable --now httpd
sudo systemctl status httpd --no-pager
```

Para permitir solicitudes HTTP desde otras máquinas cuando `firewalld` está activo:

```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

Probar localmente:

```bash
curl -I http://localhost
```

SELinux suele estar habilitado en Fedora y permite servir el contenido del directorio web predeterminado. No es necesario deshabilitarlo para esta prueba. Si se cambia la ubicación del contenido, se debe configurar el contexto SELinux correspondiente.

## Publicar una página de prueba

En ambas familias, el directorio raíz web predeterminado es `/var/www/html`. Se puede crear una página independiente para verificar la entrega de contenido sin reemplazar la página inicial existente:

```bash
printf '%s\n' 'Apache HTTP Server está funcionando.' | sudo tee /var/www/html/prueba-apache.html
curl http://localhost/prueba-apache.html
```

La respuesta debe incluir `Apache HTTP Server está funcionando.`. Si se accede desde otra máquina, reemplazar `localhost` por la dirección IP del servidor y comprobar que el firewall permita HTTP.

## Rutas y diagnóstico

| Elemento | Debian/Ubuntu | Fedora |
| --- | --- | --- |
| Nombre del servicio | `apache2` | `httpd` |
| Configuración principal | `/etc/apache2/apache2.conf` | `/etc/httpd/conf/httpd.conf` |
| Directorio de sitios o configuración adicional | `/etc/apache2/sites-available/` y `/etc/apache2/sites-enabled/` | `/etc/httpd/conf.d/` |
| Raíz web predeterminada | `/var/www/html/` | `/var/www/html/` |
| Logs de errores | `/var/log/apache2/error.log` | `/var/log/httpd/error_log` |

Si no responde, revisar que el servicio esté activo, que ningún otro servidor esté usando el puerto 80 y que las reglas del firewall permitan el tráfico. En Fedora, mantener SELinux habilitado y revisar sus contextos antes de cambiar la ubicación de los archivos.