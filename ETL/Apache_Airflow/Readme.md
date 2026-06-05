# Apache Airflow

**Apache Airflow** es una plataforma de código abierto diseñada para **automatizar, programar y monitorear flujos de trabajo** (workflows) de forma programática utilizando Python . Nació en Airbnb en 2014 para solucionar los crecientes problemas de complejidad en la gestión de sus pipelines de datos y hoy es el estándar de facto en el ecosistema de datos .

---

### ¿Qué resuelve Airflow?

Antes de Airflow, las empresas dependían de una combinación de scripts en **bash/cron**, tareas programadas en bases de datos o sistemas internos frágiles. Estos métodos presentaban desafíos importantes:

- **Dependencias frágiles**: Gestionar qué tarea debía ejecutarse después de otra era complejo y propenso a errores.
- **Monitoreo limitado**: Sin logs centralizados, saber por qué un proceso fallaba se volvía una pesadilla.
- **Escalabilidad nula**: Un fallo en medio del flujo requería reprocesar todo desde cero .
- **Falta de visibilidad**: No había una forma clara de ver el historial de ejecuciones ni el estado actual de los pipelines .

Airflow resuelve estos problemas al permitirte definir **todo el flujo de trabajo como código Python**, manejar dependencias entre tareas de forma nativa y ofrecer una interfaz web robusta para monitoreo y depuración .

---

### ¿Cómo funciona?

Un flujo de trabajo en Airflow se define como un **DAG** (Directed Acyclic Graph o Grafo Acíclico Dirigido) .

#### Componentes principales

1.  **DAG (Directed Acyclic Graph)**: Es la definición de todo tu workflow: qué tareas hacer, en qué orden y qué dependencias existen entre ellas. Se define en un archivo `.py`.

2.  **Operators**: Son los "bloques de construcción" que ejecutan una tarea. Airflow tiene operadores para todo, desde ejecutar una función Python (`PythonOperator`) hasta transferir datos entre sistemas (`BashOperator`, `EmailOperator`, `MySqlOperator`) y docenas de integraciones listas para usar con servicios cloud (AWS, GCP, Azure) .

3.  **Task**: Es una instancia de un operador (una ejecución específica dentro del DAG).

4.  **Scheduler**: Es el "motor" de Airflow. Lee tus archivos DAG, respeta las dependencias y las reglas de programación, y envía las tareas a los workers para su ejecución. La versión 3.x ha mejorado drásticamente su confiabilidad y escalabilidad .

5.  **Executor** y **Worker**: El **Executor** decide cómo se ejecutan las tareas (localmente, en procesos separados, en un clúster de Kubernetes o en la nube). Los **Workers** son los procesos que realmente ejecutan el trabajo .

6.  **UI Web**: Proporciona una vista completa de tus DAGs: su estado, logs de ejecución, duración de tareas, árbol de dependencias, y la capacidad de activar/desactivar flujos manualmente. La nueva interfaz en Airflow 3 es moderna y eficiente, con visualizaciones optimizadas .

---

### Características Clave

| Característica | Descripción |
| :--- | :--- |
| **Código Python Puro** | Define tus workflows con Python. No más XML, interfaces gráficas complejas o lenguajes de plantillas. Puedes usar bucles, variables y funciones para crear pipelines dinámicos . |
| **Escalabilidad Masiva** | Su arquitectura de componentes desacoplados (scheduler, workers, base de datos) te permite escalar horizontalmente. Empresas como Uber y LinkedIn orquestan cientos de miles de tareas diarias con Airflow . |
| **Integraciones Robusta** | Existe una enorme colección de operadores preconstruidos para interactuar con prácticamente cualquier sistema: desde bases de datos y servicios de almacenamiento en la nube hasta herramientas de Big Data como Spark, Hive y Kafka . |
| **Programación y Dependencias** | Define horarios complejos (como cron) o activa flujos basados en la finalización de otros DAGs (con **Assets**). Las dependencias entre tareas son explícitas y visuales . |
| **Monitoreo y Depuración** | La interfaz de usuario te permite ver el estado de cada tarea, inspeccionar logs, reintentar tareas fallidas con un clic y visualizar el historial de ejecuciones con gráficos de Gantt . |

---

### Casos de Uso en la Industria

Airflow se usa para una variedad de propósitos en empresas de todos los tamaños:

*   **Snapp (Empresa de tecnología en Medio Oriente)**: Su equipo de mapas utilizaba tareas manuales que consumían mucho tiempo. Implementaron Airflow para automatizar la actualización de datos de tráfico (cada 10 minutos), pipelines de entrenamiento de modelos y despliegues. **Resultado**: Ahorraron **40 horas de trabajo manual por semana** .

*   **Sift (Plataforma de Confianza y Seguridad Digital)**: Necesitaban coordinar cientos de pasos en sus pipelines de entrenamiento de modelos de Machine Learning. Con Airflow, gestionan las dependencias complejas entre tareas de Spark y MapReduce, ejecutan experimentos en aislamiento y monitorean todo desde una UI central. **Resultado**: Les permitió crear nuevos pipelines complejos y dar soporte a un ecosistema de herramientas más diverso .

*   **Adopción General**: Gigantes tecnológicos como **Google, Netflix, PayPal y Twitter** confían en Airflow para gestionar sus flujos de trabajo más críticos, desde pipelines de ETL hasta orquestación de infraestructura .

---

### Airflow vs. Otras Tecnologías

Dado tu interés en el ecosistema de datos, es útil entender cómo se posiciona Airflow:

| Tecnología | Propósito Principal | Diferencia Clave con Airflow |
| :--- | :--- | :--- |
| **Apache Airflow** | Orquestación de flujos de trabajo | **Orquestador**: Su trabajo es *programar* y *coordinar* tareas, no procesar los datos en sí. |
| **Apache NiFi** | Flujo de datos en tiempo real | NiFi es más visual y está enfocado en la ingesta y el enrutamiento de flujos de datos. Airflow es más potente para orquestar pipelines complejos con muchas dependencias. |
| **Apache Spark** | Procesamiento distribuido de datos (batch y streaming) | Spark es un **motor de cómputo**. Un pipeline típico usa Airflow para *orquestar* un trabajo que luego es *ejecutado* por Spark. |
| **Apache Kafka** | Plataforma de streaming de mensajes | Kafka es el *bus de datos*. Airflow puede *programar* la ejecución de un proceso que consuma mensajes de Kafka o monitorizar que los datos estén llegando. |

---

### Limitaciones y Consideraciones

*   **Curva de aprendizaje conceptual**: Aunque escribir un DAG simple es fácil, entender el ecosistema (scheduler, workers, metadatabase) y las mejores prácticas requiere tiempo .
*   **No es un motor de procesamiento de datos**: Históricamente, la recomendación era no usarlo para transformar terabytes de datos; para eso están Spark o Flink. Aunque Airflow 3 ha mejorado esto, sigue siendo más un orquestador que un motor de cómputo pesado .
*   **Configuración y operación**: Escalar y operar Airflow en producción (especialmente si lo administras tú mismo) puede ser complejo, requiriendo una buena comprensión de sus configuraciones y componentes .

---

**Apache Airflow** es mucho más que un reemplazo moderno para cron. Es una plataforma completa, escalable y extensible que se ha convertido en el **tejido conectivo de la infraestructura de datos moderna** . Si tu objetivo es orquestar pipelines de datos complejos, automatizar flujos de trabajo de Machine Learning o, como en tus casos de estudio, integrar herramientas como Kafka y Spark, Airflow es la herramienta fundamental.

# Instalación de Apache Airflow en Linux

Paso a paso para instalar **Apache Airflow** en Linux (Ubuntu/Debian):

---

### **1. Prerrequisitos**

#### **Instalar Python y pip**:
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv -y
```

#### **Instalar dependencias del sistema**:
```bash
sudo apt install build-essential libssl-dev libffi-dev python3-dev -y
```

---

### **2. Crear entorno virtual (Recomendado)**
```bash
python3 -m venv airflow_env
source airflow_env/bin/activate
```

---

### **3. Instalar Apache Airflow**

#### **Establecer variables de entorno**:
```bash
export AIRFLOW_HOME=~/airflow
export AIRFLOW__CORE__EXECUTOR=SequentialExecutor
```

#### **Instalar Airflow con pip**:
```bash
pip install "apache-airflow[celery]==2.7.1" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.7.1/constraints-3.8.txt"
```

> **Nota**: Ajustar la versión (2.7.1) y Python (3.8) según su versión de Python (`python3 --version`).

---

### **4. Configurar Base de Datos**

#### **Inicializar la base de datos**:
```bash
airflow db init
```

#### **Crear usuario administrador**:
```bash
airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin
```

---

### **5. Iniciar los servicios**

#### **Terminal 1 - Servidor Web**:
```bash
airflow webserver --port 8080
```

#### **Terminal 2 - Scheduler**:
```bash
airflow scheduler
```

---

### **6. Acceder a la interfaz**
Abre tu navegador en:
```
http://localhost:8080
```
Usuario: `admin`
Contraseña: `admin`

---

### **Instalación con Docker (Alternativa más fácil)**

Si prefieres usar Docker:

#### **1. Instalar Docker**:
```bash
sudo apt install docker.io docker-compose -y
sudo usermod -aG docker $USER
# Reinicia sesión o ejecuta: newgrp docker
```

#### **2. Descargar docker-compose de Airflow**:
```bash
curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.7.1/docker-compose.yaml'
```

#### **3. Inicializar**:
```bash
mkdir -p ./dags ./logs ./plugins
echo -e "AIRFLOW_UID=$(id -u)" > .env
docker-compose up airflow-init
docker-compose up
```

---

### **Solución de problemas comunes**

#### **Error: "AIRFLOW_HOME not set"**:
```bash
echo 'export AIRFLOW_HOME=~/airflow' >> ~/.bashrc
source ~/.bashrc
```

#### **Error de dependencias**:
```bash
pip install "apache-airflow[postgres,redis,celery]==2.7.1" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.7.1/constraints-3.8.txt"
```

#### **Puerto ocupado**:
```bash
airflow webserver --port 8081
```

---

### **Verificar instalación**
```bash
airflow version
```
Deberías ver algo como:
```
2.7.1
```

---

### **Configuración recomendada para producción**

#### **Cambiar a PostgreSQL**:
```bash
sudo apt install postgresql postgresql-contrib -y
pip install "apache-airflow[postgres]"
```

#### **En `airflow.cfg`**:
```ini
executor = LocalExecutor
sql_alchemy_conn = postgresql+psycopg2://user:password@localhost/airflow
```

---

### **Comandos útiles**

```bash
# Desactivar entorno virtual
deactivate

# Reiniciar servicios
airflow webserver --port 8080 -D  # Demonio
airflow scheduler -D

# Listar DAGs
airflow dags list

# Probar un DAG
airflow dags test mi_dag 2023-01-01
```
