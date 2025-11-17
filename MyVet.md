# PRESENTACIÓN (MyVet)

**Asignatura**: Bases de Datos I (FaCENA-UNNE)

**Integrantes**:
 - Coronel, Antonio.
 - Ovalle Bravo, Bautista.
 - Mas Gonzalez, Fernando.
 - Saucedo, Germán.

**Año**: 2025

## CAPÍTULO I: INTRODUCCIÓN

### Caso de estudio

El presente caso de estudio aborda el diseño y desarrollo de un sistema de gestión para una veterinaria. Este sistema permitirá administrar de manera centralizada la información de mascotas, propietarios, veterinarios, turnos, consultas médicas y vacunaciones, así como gestionar los distintos roles y permisos de usuario que interactúan con la aplicación.

El sistema busca optimizar el proceso de atención veterinaria y la gestión interna, permitiendo un manejo más eficiente y ágil de los datos relacionados con la salud de las mascotas y la organización de los turnos. La plataforma está orientada tanto a los veterinarios como al personal administrativo, brindando herramientas que faciliten la planificación de consultas, el seguimiento de tratamientos y vacunas, y el control del historial clínico de cada paciente.

### Definición o planteamiento del problema

El objetivo principal del sistema es resolver las dificultades que enfrentan mcuhas veterinarias debido a la ausencia de un sistema integrado que permita gestionar de manera eficiente las distintas áreas de atención y administración. Entre los problemas más comunes que se presentan se encuentran:

Registros dispersos o manuales: La información de mascotas, propietarios, consultas y vacunas suele estar fragmentada en planillas, archivos físicos o sistemas poco especializados, lo que incrementa el riesgo de pérdida de datos y errores administrativos.

Gestión ineficiente de turnos y consultas: La falta de un sistema organizado ocasiona solapamiento de horarios, cancelaciones mal registradas o dificultad para dar seguimiento al historial clínico de cada paciente.

Control limitado de tratamientos y vacunaciones: Sin un registro digital centralizado, resulta complejo llevar un seguimiento claro de vacunas aplicadas o tratamientos en curso, generando riesgos para la salud de las mascotas.

Problemas de trazabilidad en la atención médica: La ausencia de un historial clínico completo dificulta la toma de decisiones por parte de los veterinarios y limita la capacidad de personalizar la atención.

Falta de control de accesos y roles: Cuando diferentes usuarios (administrativos, veterinarios, recepcionistas) interactúan en el sistema sin un adecuado control de permisos, se generan problemas de seguridad y uso indebido de información sensible.


## CAPITULO II: MARCO CONCEPTUAL O REFERENCIAL

**TEMA 1 " Procedimientos y funciones almacenadas"**

> Acceder a la siguiente carpeta para ver el desarrollo del tema [Procedimientos y funciones almacenadas]()

**TEMA 2 "Optimización de consultas a través de índices"** 

> Acceder a la siguiente carpeta para ver el desarrollo del tema [Optimización de consultas a través de índices](https://github.com/Papulo62/MyVet/blob/main/script/Tema%202%20Optimizaci%C3%B3n%20de%20consultas%20a%20trav%C3%A9s%20de%20%C3%ADndices/Optimizaci%C3%B3n_de_consultas_a_trav%C3%A9s_de%20_indices.md)

**TEMA 3 "Manejo de transacciones y transacciones anidadas"** 

> Acceder a la siguiente carpeta para ver el desarrollo del tema [Manejo de transacciones y transacciones anidadas](https://github.com/Papulo62/MyVet/blob/main/script/Tema%203%20Manejo%20de%20transacciones%20y%20transacciones%20anidadas/Manejo_de_transacciones_y_transacciones_anidadas.md)

**TEMA 4 " Índices columnares en SQL server "**  

> Acceder a la siguiente carpeta para ver el desarrollo del tema [Índices columnares en SQL server](https://github.com/Papulo62/MyVet/blob/main/script/Tema%204%20%C3%8Dndices%20columnares%20en%20SQL%20server/%C3%8Dndices_columnares_en_SQL_server.md)

## CAPÍTULO III: METODOLOGÍA SEGUIDA 

 **a) Cómo se realizó el Trabajo Práctico**
Lo primero que hicimos fue decidir el caso estudio, cada uno propuso sus ideas y se terminó votando por el actual que nos pareció más idóneo.
Luego se creó el diseño del Modelo Entidad-Relacion (ER), y posteriormente se hizo la carga de datos y a continuación el diccionario de datos.

Luego de la primera entrega cada uno procedió a seleccionar un tema y desarrollarlo:
- Procedimientos y funciones almacenadas.
- Optimización de consultas a través de índices.
- Manejo de transacciones y transacciones anidadas.
- Índices columnares en SQL Server.

 **b) Herramientas (Instrumentos y procedimientos)**

Utilizamos las siguientes herramientas:

- ERD Plus es una herramienta intuitiva y efectiva para el modelado de bases de datos, que permite crear diagramas relacionales y conceptuales, además de generar código SQL. Con ERD Plus, logramos diseñar el esquema conceptual de nuestro proyecto.

- SQL Server Management Studio 20 es un software de administración de bases de datos creado por Microsoft, diseñado principalmente para trabajar con SQL Server y otros lenguajes de consulta, allí desarrollamos las consultas para los temas individuales y carga de datos.


## CAPÍTULO IV: DESARROLLO DEL TEMA / PRESENTACIÓN DE RESULTADOS 

### Diagrama relacional
![diagrama_relacional](https://raw.githubusercontent.com/Papulo62/MyVet/refs/heads/main/doc/modelo_relacional.png)

### Diccionario de datos

Acceso al documento [PDF](doc/diccionario_datos.pdf) del diccionario de datos.


### Desarrollo TEMA 1 "Procedimientos y funciones almacenadas"
> Acceder a la siguiente carpeta para ver el desarrollo del script [Procedimientos y funciones almacenadas]()

### Desarrollo TEMA 2 "Optimización de consultas a través de índices"
> Acceder a la siguiente carpeta para ver el desarrollo del script [Optimización de consultas a través de índices](https://github.com/Papulo62/MyVet/blob/main/script/Tema%202%20Optimizaci%C3%B3n%20de%20consultas%20a%20trav%C3%A9s%20de%20%C3%ADndices/optimizacion_de_consultas_a_traves_de_indices_script.sql)

### Desarrollo TEMA 3 "Manejo de transacciones y transacciones anidadas"
> Acceder a la siguiente carpeta para ver el desarrollo del script [Manejo de transacciones y transacciones anidadas](https://github.com/Papulo62/MyVet/blob/main/script/Tema%203%20Manejo%20de%20transacciones%20y%20transacciones%20anidadas/manejo_de_transacciones_y_transacciones_anidadas_script.sql)

### Desarrollo TEMA 4 "Índices columnares en SQL server"
> Acceder a la siguiente carpeta para ver el desarrollo del script [Índices columnares en SQL server](https://github.com/Papulo62/MyVet/blob/main/script/Tema%204%20%C3%8Dndices%20columnares%20en%20SQL%20server/indices_columnares_script.sql)

## CAPÍTULO V: CONCLUSIONES

Este trabajo práctico permitió comprender en profundidad la relevancia de las herramientas que ofrece SQL Server para mejorar el rendimiento, la integridad y la organización de los procesos dentro de una base de datos. A medida que avanzamos en cada uno de los temas, logramos alcanzar los objetivos propuestos, fortaleciendo nuestra capacidad para diseñar soluciones eficientes y seguras en entornos de gestión de datos.

El análisis de los procedimientos y funciones almacenadas evidenció la importancia de centralizar la lógica del sistema, reducir la repetición de código y facilitar el mantenimiento. Su implementación permite estandarizar operaciones frecuentes, mejorar la organización interna y aumentar la cohesión del diseño de la base de datos.

En cuanto a la optimización de consultas mediante índices pudimos comprobar cómo la elección correcta de índices adecuados eleva significativamente el rendimiento de las consultas. Su uso mejora los tiempos de respuesta, reduce la carga sobre el motor y garantiza un acceso más eficiente a la información almacenada.

El manejo de transacciones y transacciones anidadas resultó esencial para comprender cómo garantizar la integridad de los datos en operaciones complejas o críticas. El uso de COMMIT, ROLLBACK y SAVEPOINT permitió observar cómo SQL Server asegura que un conjunto de acciones se ejecute de forma completa y consistente, evitando inconsistencias y facilitando la recuperación en caso de errores durante el proceso.

Finalmente, el estudio de los índices columnares nos permitió apreciar su utilidad en escenarios con grandes volúmenes de datos. Este tipo de índice, diseñado específicamente para cargas analíticas, ofrece mejoras significativas en compresión, velocidad de lectura y eficiencia en consultas orientadas a análisis masivos.

En conjunto, la aplicación de estos conceptos demuestra la importancia de comprender tanto las herramientas de optimización como los mecanismos de control interno del motor SQL Server. Un uso adecuado de estas técnicas permite construir bases de datos más seguras, eficientes y preparadas para responder de manera óptima ante diversas necesidades operativas. 



## BIBLIOGRAFÍA DE CONSULTA
1. - Procedimientos almacenados: https://learn.microsoft.com/es-es/sql/relational-databases/stored-procedures/stored-procedures-database-engine?view=sql-server-ver16
 2. - Create Function (Transact-SQL): https://learn.microsoft.com/es-es/sql/t-sql/statements/create-function-transact-sql?view=sql-server-ver16
 3. - Roles en el nivel de base de datos: https://learn.microsoft.com/es-es/sql/relational-databases/security/authentication-access/database-level-roles?view=sql-server-ver16
 4. - Índices columnares en SQL server: https://learn.microsoft.com/es-es/sql/relational-databases/indexes/columnstore-indexes-overview?view=sql-server-ver16
 5. - Referencia: Medina, B. (2019, octubre 16). Diseño efectivo de índices agrupados SQL Server. SQLShack en Español. https://www.sqlshack.com/es/diseno-efectivo-de-indices-agrupados-sql-server/
 6. - Referencia: Medina, B. (2019, octubre 9). ¿Cuál es la diferencia entre índices agrupados y no agrupados en SQL Server? SQLShack en Español. https://www.sqlshack.com/es/cual-es-la-diferencia-entre-indices-agrupados-y-no-agrupados-en-sql-server/
 7. - Referencia: Listopro Community. (n.d.). Índices y optimización en SQL. Listopro Community. https://community.listopro.com/indices-y-optimizacion-en-sql/

