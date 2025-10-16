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

> **Nota**: Ajusta la versión (2.7.1) y Python (3.8) según tu versión de Python (`python3 --version`).

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
