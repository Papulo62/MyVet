-- SCRIPT DE ÍNDICES COLUMNARES
-- Base de Datos: DBMyVet
-- Tabla origen: consulta (tabla de mayor ocurrencia)

USE DBMyVet;
GO

-- CREAR TABLAS DE PRUEBA
-- Se crean 2 copias de la tabla consulta para comparar rendimiento

-- Crear tabla sin índice columnar
SELECT * INTO consulta_sin_columnstore 
FROM consulta 
WHERE 1 = 0;

-- Crear tabla con índice columnar
SELECT * INTO consulta_con_columnstore 
FROM consulta 
WHERE 1 = 0;



GO

-- CARGA MASIVA DE REGISTROS
-- Se cargan las tres tablas con 1 millón de registros cada una
-- Los registros se generan variando datos de la tabla consulta original

SET NOCOUNT ON;
DECLARE @i INT = 0;

WHILE @i < 1000000
BEGIN
    INSERT INTO consulta_sin_columnstore (
        fecha_consulta, 
        motivo, 
        diagnostico, 
        tratamiento, 
        proximo_control,
        sintomas,
        id_mascota, 
        id_veterinario,
        activo
    )
    SELECT 
        DATEADD(DAY, @i % 30, DATEADD(MONTH, @i % 12, DATEADD(YEAR, @i % 5, GETDATE()))),
        motivo,
        diagnostico,
        tratamiento,
        DATEADD(DAY, 30, DATEADD(DAY, @i % 30, DATEADD(MONTH, @i % 12, DATEADD(YEAR, @i % 5, GETDATE())))),
        sintomas,
        1,
        1,
        1
    FROM consulta
    WHERE id_consulta = 5;

    INSERT INTO consulta_con_columnstore (
        fecha_consulta, 
        motivo, 
        diagnostico, 
        tratamiento, 
        proximo_control,
        sintomas,
        id_mascota, 
        id_veterinario,
        activo
    )
    SELECT 
        DATEADD(DAY, @i % 30, DATEADD(MONTH, @i % 12, DATEADD(YEAR, @i % 5, GETDATE()))),
        motivo,
        diagnostico,
        tratamiento,
        DATEADD(DAY, 30, DATEADD(DAY, @i % 30, DATEADD(MONTH, @i % 12, DATEADD(YEAR, @i % 5, GETDATE())))),
        sintomas,
        1,
        1,
        1
    FROM consulta
    WHERE id_consulta = 5;

    SET @i = @i + 1;
END;

-- Verificar que se hayan cargado correctamente los registros
SELECT COUNT(*) AS 'consulta_sin_columnstore cantidad' FROM consulta_sin_columnstore;
SELECT COUNT(*) AS 'consulta_con_columnstore cantidad' FROM consulta_con_columnstore;
GO

-- CREAR ÍNDICE
-- Crear índice columnar no agrupado en la tabla consulta_con_columnstore
CREATE NONCLUSTERED COLUMNSTORE INDEX IDX_Consulta_Columnstore 
ON consulta_con_columnstore (fecha_consulta, id_mascota, id_veterinario, motivo, diagnostico);
GO


-- CONSULTA ANALÍTICA - SIN ÍNDICE COLUMNAR
-- Consulta de agregación sobre la tabla sin índice columnar

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    id_veterinario,
    YEAR(fecha_consulta) AS año,
    MONTH(fecha_consulta) AS mes,
    COUNT(*) AS total_consultas,
    COUNT(DISTINCT id_mascota) AS mascotas_atendidas
FROM consulta_sin_columnstore
WHERE fecha_consulta BETWEEN '2024-01-01' AND '2030-12-31'
GROUP BY id_veterinario, YEAR(fecha_consulta), MONTH(fecha_consulta)
ORDER BY total_consultas DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- CONSULTA ANALÍTICA - CON ÍNDICE COLUMNAR
-- La misma consulta sobre la tabla con índice columnar

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    id_veterinario,
    YEAR(fecha_consulta) AS año,
    MONTH(fecha_consulta) AS mes,
    COUNT(*) AS total_consultas,
    COUNT(DISTINCT id_mascota) AS mascotas_atendidas
FROM consulta_con_columnstore
WHERE fecha_consulta BETWEEN '2024-01-01' AND '2030-12-31'
GROUP BY id_veterinario, YEAR(fecha_consulta), MONTH(fecha_consulta)
ORDER BY total_consultas DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO



--Pruebas de rendimiento
-- Tanda 1:
--
-- Primero los resultados de la tabla sin índice columnar:
-- Table 'consulta_sin_columnstore'. Scan count 1, logical reads 16825, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- SQL Server Execution Times:
-- CPU time = 2156 ms,  elapsed time = 9847 ms.

-- Ahora los resultados de la tabla con índice columnar:
-- Table 'consulta_con_columnstore'. Scan count 1, logical reads 16825, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- SQL Server Execution Times:
-- CPU time = 876 ms,  elapsed time = 6421 ms.
--
-- Tanda 2:
--
-- Primero los resultados de la tabla sin índice columnar:
-- Table 'consulta_sin_columnstore'. Scan count 1, logical reads 16825, physical reads 0, page server reads 0, read-ahead reads 16825, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- SQL Server Execution Times:
-- CPU time = 1923 ms,  elapsed time = 9234 ms.

-- Ahora los resultados de la tabla con índice columnar:
-- Table 'consulta_con_columnstore'. Scan count 1, logical reads 16825, physical reads 0, page server reads 0, read-ahead reads 16825, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- SQL Server Execution Times:
-- CPU time = 742 ms,  elapsed time = 5892 ms.
-- Tanda 3:
--
-- Primero los resultados de la tabla sin índice columnar:
-- Table 'consulta_sin_columnstore'. Scan count 1, logical reads 16825, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- SQL Server Execution Times:
-- CPU time = 2087 ms,  elapsed time = 9512 ms.

-- Ahora los resultados de la tabla con índice columnar:
-- Table 'consulta_con_columnstore'. Scan count 1, logical reads 16825, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
-- SQL Server Execution Times:
-- CPU time = 809 ms,  elapsed time = 6178 ms.

-- CONCLUSIONES FINALES

--|Tanda  |consulta_sin_columnstore|consulta_con_columnstore|--
--|-------|------------------------|------------------------|--
--|Tanda 1|       9847ms           |       6421ms           |--
--|Tanda 2|       9234ms           |       5892ms           |--
--|Tanda 3|       9512ms           |       6178ms           |--
--|-------|------------------------|------------------------|--
--|Promedio|      9531ms           |       6164ms           |--
---------------------------------------------------------------

-- Consulta sin índice columnar
-- Tiempo de CPU promedio: 2,055 ms
-- Tiempo transcurrido promedio: 9,531 ms
-- Lecturas lógicas: 16,825
-- Observación: La consulta realiza un escaneo completo de la tabla (Table Scan). 
-- El motor debe leer todas las columnas de todos los registros para realizar las 
-- agregaciones, resultando en un alto consumo de CPU y tiempo de ejecución prolongado.

-- Consulta con índice columnar
-- Tiempo de CPU promedio: 809 ms
-- Tiempo transcurrido promedio: 6,164 ms
-- Lecturas lógicas: 16,825
-- Observación: El índice columnar reduce significativamente el tiempo de CPU en un 
-- 60.6% y el tiempo transcurrido en un 35.3%. Aunque las lecturas lógicas son similares, 
-- el índice columnar lee únicamente las columnas necesarias (fecha_consulta, id_mascota, 
-- id_veterinario) y utiliza procesamiento por lotes (batch mode) para optimizar las 
-- operaciones de agregación (COUNT, GROUP BY).

-- Conclusión
-- Los índices columnares demuestran su efectividad en consultas analíticas con agregaciones, 
-- logrando mejoras del 35% en tiempo de ejecución y del 60% en uso de CPU. El índice columnar 
-- optimiza el procesamiento al leer solo las columnas necesarias en formato comprimido y 
-- aplicar procesamiento vectorizado para operaciones de agregación. En un sistema veterinario, 
-- esta mejora es especialmente valiosa para generar reportes estadísticos mensuales, análisis 
-- de consultas por período y dashboards gerenciales, reduciendo los tiempos de respuesta y 
-- la carga del servidor. Los índices columnares son ideales para tablas de análisis histórico 
-- donde las operaciones de lectura predominan sobre las de escritura.