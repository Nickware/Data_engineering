# Apache Hop

**Apache Hop** es una plataforma de orquestación de datos de código abierto, diseñada para ser el sucesor moderno y flexible de Pentaho Data Integration (Kettle) .

Nació en 2019 como un fork (rama independiente) del proyecto Kettle, creado por miembros del equipo original de desarrollo de Kettle . Su objetivo principal es superar las limitaciones de su predecesor, adoptando prácticas modernas de desarrollo y operación. En 2022, se convirtió en un proyecto de primer nivel de la Apache Software Foundation .

A continuación, se presenta caracteristicas detalladas de Apache Hop

| Característica                      | Apache Hop                                                   |
| :---------------------------------- | :----------------------------------------------------------- |
| **Origen**                          | Fork del proyecto Kettle creado en 2019 .                    |
| **Principios de Diseño**            | Orientado a metadatos, nativo de la nube y extensible .      |
| **Interfaz Gráfica (GUI)**          | **Hop GUI**. Utiliza un lienzo y menú contextual con botón derecho para añadir transforms . |
| **Unidad Principal**                | **Pipeline** (equivalente a una transformación) .            |
| **Ejecución por Línea de Comandos** | `hop-run`: una sola herramienta para ejecutar pipelines y workflows . |
| **Servidor Remoto**                 | **Hop Server**. Expone una **API RESTful** (usa JSON) para una integración moderna (e.g., con Airflow) . |
| **Gestión de Proyectos**            | **Abierta y nativa**. Los metadatos se guardan como archivos legibles, facilitando el uso de **Git** para control de versiones y la integración en entornos cloud (e.g., S3) . |
| **Modelo de Ejecución**             | Ejecuta pipelines y workflows de forma nativa. Puede llevar estos mismos artefactos a motores de big data como **Spark o Flink** sin reescribirlos . |

### Componentes y arquitectura

Hop se compone de varias piezas que trabajan en conjunto :
*   **Hop GUI**: Es el entorno de desarrollo visual de escritorio donde diseñarás tus procesos (pipelines y workflows) .
*   **Hop Run**: Es la herramienta para ejecutar tus procesos desde la línea de comandos, ideal para automatización .
*   **Hop Server**: Es un servicio ligero que expone una **API RESTful** . Permite ejecutar y monitorear procesos de forma remota, lo que facilita su integración en arquitecturas modernas .
*   **Hop Web**: Es la interfaz de usuario basada en navegador que permite acceder y operar el servidor, también utilizada para administración .

### Proyecto: Pipeline de datos con Apache Hop

Un proyecto típico con Apache Hop tendría como objetivo construir un pipeline de datos (ETL) usando su interfaz visual (Hop GUI). Por ejemplo, un flujo que lea un archivo CSV, realice transformaciones como limpieza y filtrado, y finalmente escriba los resultados en archivos de texto separados .

El flujo de trabajo sería el siguiente:
1.  **Preparación**: Asegurar que Java 11 o 21 esté instalado. Descargar Apache Hop y descomprimirlo .
2.  **Diseño**: Abrir Hop GUI y crear un nuevo pipeline. Usar los transforms (componentes) como `CSV File Input`, `Select Values`, `Filter rows` y `Text File Output`, conectándolos en el lienzo para definir el flujo de datos .
3.  **Ejecución**: Ejecutar el pipeline directamente desde el GUI para probarlo o usar la herramienta `hop-run` desde la terminal para una ejecución automatizada .

### ¿Por qué elegir Apache Hop?

*   **Moderno y Abierto**: Su arquitectura orientada a metadatos y el uso de formatos de archivo estándar lo hacen perfecto para equipos que ya usan **Git, CI/CD y entornos cloud** .
*   **Integración Superior**: La API RESTful y la arquitectura limpia lo convierten en un candidato mucho más robusto para ser el motor de ejecución de tareas ETL orquestadas por herramientas como **Apache Airflow**, como se demuestra en casos de uso real .
*   **Sin Vendor Lock-in**: Al ser un proyecto Apache de código abierto, no dependes de una empresa específica, y la comunidad activa garantiza su evolución .
*   **Enfoque Cloud-Native**: Su diseño permite ejecutar los mismos pipelines en motores de big data como **Spark y Flink** .

Apache Hop no es solo un clon, sino una evolución. Corrige muchas de las rigideces de Kettle/PDI y lo prepara para las prácticas actuales de la ingeniería de datos.
