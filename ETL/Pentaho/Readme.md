# Pentaho Community Edition (CE)

**Pentaho Community Edition (CE)**, que es la versión open-source del software de Business Intelligence de Pentaho. Sin embargo, hay algunos detalles importantes que debe conocer:

---

### **Pentaho Community Edition vs Pentaho Enterprise**

| **Característica**  | **Community Edition** | **Enterprise Edition** |
| ------------------- | --------------------- | ---------------------- |
| **Licencia**        | GPL v2                | Comercial              |
| **Costo**           | Gratuito              | De pago                |
| **Soporte**         | Comunidad             | Soporte oficial        |
| **Características** | Básicas               | Todas las funciones    |

---

### **Componentes de Pentaho Community Edition**

#### **1. Pentaho Data Integration (PDI) - Spoon**
- **Herramienta ETL/ELT** visual más popular de Pentaho
- **Interfaz gráfica**: Spoon
- **Motor**: Kitchen (para ejecución por línea de comandos)
- **Características**: Transformaciones, jobs, conexiones a múltiples bases de datos

#### **2. Pentaho Reporting**
- **Pentaho Report Designer**: Creador de reportes
- **Motor de reportes**: Generación de reports en PDF, Excel, HTML

#### **3. Pentaho Server Community Edition**
- **Servidor web** para publicar y ejecutar reportes y dashboards
- **Funcionalidades limitadas** comparado con la versión Enterprise

---

### **Instalación de Pentaho Community Edition**

#### **Prerrequisitos**:
```bash
# Instalar Java 8 (recomendado para compatibilidad)
sudo apt install openjdk-8-jdk -y
```

#### **Descargar Pentaho CE**:
```bash
# Pentaho Data Integration (PDI)
wget https://sourceforge.net/projects/pentaho/files/Data%20Integration/9.3/pdi-ce-9.3.0.0-428.zip/download -O pdi-ce-9.3.0.0-428.zip

# Pentaho Server CE
wget https://sourceforge.net/projects/pentaho/files/Pentaho%209.3/server/pentaho-server-ce-9.3.0.0-428.zip/download -O pentaho-server-ce-9.3.0.0-428.zip
```

#### **Instalar PDI (Spoon)**:
```bash
unzip pdi-ce-9.3.0.0-428.zip -d /opt/
cd /opt/data-integration
./spoon.sh
```

---

### **Alternativas Modernas a Pentaho CE**

Dado que **Pentaho CE** tiene versiones antiguas y limitaciones, te recomiendo estas alternativas open-source más activas:

#### **1. Apache Hop**
- **Descripción**: Fork moderno de Pentaho PDI
- **Ventajas**: Comunidad activa, mejor integración con tecnologías modernas
- **Instalación**:
  ```bash
  wget https://downloads.apache.org/hop/2.7.0/apache-hop-2.7.0.zip
  unzip apache-hop-2.7.0.zip -d /opt/
  cd /opt/apache-hop-2.7.0
  ./hop-gui.sh
  ```

#### **2. Talend Open Studio**
- **Descripción**: Herramienta ETL visual similar a Pentaho
- **Licencia**: Open Source

#### **3. Kettle** (nombre original de Pentaho PDI)
- Aún se encuentra en algunos repositorios, pero **Apache Hop** es su evolución

---

### **Ejemplo de Uso - Pentaho PDI**

#### **Crear una transformación simple**:
1. **Abrir Spoon**: `./spoon.sh`
2. **Agregar entrada**: "Table Input" (leer de base de datos)
3. **Agregar transformación**: "Calculator", "Select values"
4. **Agregar salida**: "Table Output" o "Text file output"

#### **Ejecutar desde línea de comandos**:
```bash
./kitchen.sh -file=/path/to/transformation.ktr
./pan.sh -file=/path/to/job.kjb
```

---

### **Limitaciones de Pentaho Community Edition**

1. **Sin clustering** automático
2. **Sin soporte** para algunos conectores empresariales
3. **Sin características** de seguridad avanzadas
4. **Versiones desactualizadas** en repositorios

---

### **Recomendación Personal**

Si busca una solución **moderna y activamente mantenida**, se recomienda **Apache Hop** que es el sucesor espiritual de Pentaho PDI con:

- ✅ Mejor integración con **tecnologías cloud**
- ✅ Comunidad **activa**
- ✅ **Docker** y **Kubernetes** nativos
- ✅ Conectores para **Spark, Kafka, BigQuery**

**Instalar Apache Hop**:

```bash
wget https://downloads.apache.org/hop/2.7.0/apache-hop-2.7.0.zip
unzip apache-hop-2.7.0.zip -d /opt/
cd /opt/apache-hop-2.7.0
./hop-gui.sh
```

---

### **Conclusión**

Pentaho Community Edition es una buena herramienta para **aprender conceptos ETL**, pero para **proyectos productivos** recomiendo **Apache Hop** o otras alternativas más modernas.
