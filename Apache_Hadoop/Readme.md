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

## Guía de instalación

La guía de instalación y configuración pseudo-distribuida de un solo nodo está en [docs/instalacion.md](docs/instalacion.md). Incluye los prerrequisitos, configuración de HDFS y YARN, acceso SSH local, arranque de servicios y ejemplos de verificación.
