-- SCRIPT DE OPTIMIZACIÓN CON ÍNDICES
-- Base de Datos: DBMyVet
-- Tabla: consulta
-- Campo fecha: fecha_consulta

USE DBMyVet;
GO

-- CARGA MASIVA DE REGISTROS
-- Se ejecuta una función automatizada para cargar un millón de registros en la tabla consulta

DECLARE @count INT = 0;

WHILE @count < 1000000
BEGIN
    DECLARE @fecha DATE = DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 730), GETDATE());
    INSERT INTO consulta (
        fecha_consulta, 
        motivo, 
        diagnostico, 
        tratamiento, 
        proximo_control,
        sintomas,
        id_mascota, 
        id_veterinario
    )
    VALUES (
        @fecha,
        'Control de rutina automatizado',
        'Diagnóstico generado para prueba de índices',
        'Tratamiento estándar',
        DATEADD(DAY, 30, @fecha),
        'Síntomas de prueba',
        1,
        1
    );
    
    SET @count = @count + 1;
END;

-- tiempo de ejecución: 00:07:40

-- Se verifica la cantidad total de registros insertados
SELECT COUNT(*) AS Total_Consultas FROM consulta;
GO
-- 1.222.628 hay algunos registros mas porque se hizo un insert de prueba antes

-- CONSULTA SIN ÍNDICE
-- Se realiza una búsqueda por período sin índice en la columna fecha_consulta
-- El objetivo es medir el rendimiento base antes de aplicar optimizaciones
-- Se consultan todas las consultas de los ultimos 90 días

-- Se activa las estadísticas de tiempo e I/O para medir el rendimiento
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    id_consulta,
    fecha_consulta,
    motivo,
    diagnostico,
    tratamiento,
    sintomas,
    id_mascota,
    id_veterinario
FROM consulta
WHERE fecha_consulta BETWEEN DATEADD(DAY, -90, GETDATE()) AND GETDATE();

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

--SQL Server Execution Times:
   CPU time = 0 ms,  elapsed time = 0 ms.

--(128570 row(s) affected)
--Table 'consulta'. Scan count 1, logical reads 23109, physical reads 0, read-ahead reads 0, lob logical --reads 0, lob physical reads 0, lob read-ahead reads 0.

 --SQL Server Execution Times:
   CPU time = 578 ms,  elapsed time = 4805 ms.

--  CREAR ÍNDICE AGRUPADO
-- Se define un índice agrupado (clustered) sobre la columna fecha_consulta
-- Solo puede existir un índice agrupado por tabla
-- Como la clave primaria ya es un índice agrupado, primero debe eliminarse

--Se elimina la clave primaria existente para poder crear el índice agrupado en fecha_consulta
ALTER TABLE consulta DROP CONSTRAINT PK_Consulta;
GO

-- Se crea el índice agrupado en la columna fecha_consulta
-- Este índice ordena físicamente los datos de la tabla según la fecha de consulta
CREATE CLUSTERED INDEX IDX_Consulta_FechaConsulta_Agrupado 
ON consulta (fecha_consulta);
GO

-- tiempo de ejecución: 00:00:019

--CONSULTA CON ÍNDICE AGRUPADO
-- Se repite la misma búsqueda por período pero ahora con el índice agrupado creado
-- Esto permite comparar el rendimiento con la consulta sin índice
-- Se registra el plan de ejecución utilizado por el motor y los tiempos de respuesta

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    id_consulta,
    fecha_consulta,
    motivo,
    diagnostico,
    tratamiento,
    sintomas,
    id_mascota,
    id_veterinario
FROM consulta
WHERE fecha_consulta BETWEEN DATEADD(DAY, -90, GETDATE()) AND GETDATE();

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

--SQL Server Execution Times:
--CPU time = 0 ms,  elapsed time = 0 ms.

--(128570 row(s) affected)
--Table 'consulta'. Scan count 1, logical reads 2531, physical reads 0, read-ahead reads 0, lob logical --reads 0, lob physical reads 0, lob read-ahead reads 0.

 --SQL Server Execution Times:
 --CPU time = 265 ms,  elapsed time = 4634 ms.

-- ELIMINAR ÍNDICE AGRUPADO
-- Se elimina el índice agrupado creado anteriormente

DROP INDEX IDX_Consulta_FechaConsulta_Agrupado ON consulta;
GO

-- CREAR ÍNDICE NO AGRUPADO CON COLUMNAS INCLUIDAS
-- Se restaura primero la clave primaria (que es un índice agrupado sobre id_consulta)
-- Luego se define un índice no agrupado sobre la columna fecha_consulta
-- La cláusula INCLUDE agrega las columnas que se seleccionan en la consulta
-- Esto crea un "covering index" que permite responder la consulta sin acceder a la tabla base

-- Restaurar la clave primaria como índice agrupado
ALTER TABLE consulta 
ADD CONSTRAINT PK_Consulta PRIMARY KEY CLUSTERED (id_consulta);
GO

-- Crear índice no agrupado con columnas incluidas
-- El índice se ordena por fecha_consulta e incluye todas las columnas del SELECT
CREATE NONCLUSTERED INDEX IDX_Consulta_FechaConsulta_Incluido
ON consulta (fecha_consulta)
INCLUDE (id_consulta, motivo, diagnostico, tratamiento, sintomas, id_mascota, id_veterinario);
GO

-- CONSULTA CON ÍNDICE NO AGRUPADO + INCLUDE
-- Se repite la misma búsqueda por período pero ahora con el índice no agrupado
-- Este índice incluye todas las columnas necesarias (covering index)
-- Se registra el plan de ejecución utilizado por el motor y los tiempos de respuesta

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    id_consulta,
    fecha_consulta,
    motivo,
    diagnostico,
    tratamiento,
    sintomas,
    id_mascota,
    id_veterinario
FROM consulta
WHERE fecha_consulta BETWEEN DATEADD(DAY, -90, GETDATE()) AND GETDATE();

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

--SQL Server Execution Times:
--CPU time = 0 ms,  elapsed time = 0 ms.
--(128570 row(s) affected)
--Table 'consulta'. Scan count 1, logical reads 2266, physical reads 0, read-ahead reads 0, lob logical --reads 0, lob physical reads 0, lob read-ahead reads 0.

 --SQL Server Execution Times:
 --CPU time = 391 ms,  elapsed time = 4457 ms.

-- *** CONCLUSIONES FINALES ***

-- Consulta sin índice
-- Tiempo de CPU: 578 ms
-- Tiempo transcurrido: 4805 ms
-- Lecturas lógicas: 23,109
-- Filas devueltas: 128,570 (10.5% del total)
-- Observación: La consulta realiza una exploración completa de la tabla (Table Scan), 
-- recorriendo todos los registros para encontrar las consultas de los últimos 90 días. 
-- Se observa un elevado número de lecturas lógicas debido a la falta de un índice 
-- en la columna fecha_consulta, lo que resulta en un tiempo de ejecución alto.

-- Consulta con índice agrupado en fecha_consulta
-- Tiempo de CPU: 265 ms
-- Tiempo transcurrido: 4634 ms
-- Lecturas lógicas: 2,531
-- Lecturas anticipadas: 0
-- Filas devueltas: 128,570
-- Observación: La creación de un índice agrupado en fecha_consulta reduce 
-- significativamente las lecturas lógicas en un 89% (de 23,109 a 2,531). 
-- El tiempo de CPU se reduce en un 54% (de 578 ms a 265 ms). El índice agrupado 
-- ordena físicamente los datos por fecha, permitiendo al motor acceder directamente 
-- al rango solicitado sin escanear toda la tabla.

-- Consulta con índice no agrupado en fecha_consulta con columnas incluidas
-- Tiempo de CPU: 391 ms
-- Tiempo transcurrido: 4457 ms
-- Lecturas lógicas: 2,266
-- Lecturas anticipadas: 0
-- Filas devueltas: 128,570
-- Observación: El índice no agrupado con columnas incluidas (covering index) logra 
-- la mayor reducción en lecturas lógicas, disminuyendo un 90% respecto a la consulta 
-- sin índice (de 23,109 a 2,266). Sin embargo, el tiempo de CPU aumenta ligeramente 
-- en comparación con el índice agrupado (391 ms vs 265 ms). Esto se debe al overhead 
-- de navegar la estructura del índice no agrupado, aunque evita acceder a la tabla base 
-- al incluir todas las columnas necesarias en el índice.

-- Conclusión
-- Ambos tipos de índices mejoran drásticamente el rendimiento en comparación con la 
-- consulta sin índice. El índice agrupado resulta ser la opción más eficiente para 
-- este tipo de consultas por rango de fechas, reduciendo las lecturas lógicas en un 89% 
-- y el tiempo de CPU en un 54%. El índice no agrupado con INCLUDE logra la mayor 
-- reducción en lecturas lógicas (90%), pero con un ligero aumento en el tiempo de CPU.
-- 
-- Para un sistema veterinario donde las consultas por rango de fechas son frecuentes, 
-- se recomienda el uso de un índice agrupado en fecha_consulta si esta columna es el 
-- criterio de búsqueda principal. Alternativamente, si la clave primaria debe mantenerse 
-- como índice agrupado, el índice no agrupado con INCLUDE es una excelente opción que 
-- balancea rendimiento y flexibilidad.
