-- SCRIPT DE ÍNDICES COLUMNARES
-- Base de Datos: DBMyVet
-- Tabla origen: consulta (tabla de mayor ocurrencia)

USE DBMyVet;
GO

-- CREAR TABLAS DE PRUEBA
-- Se crean tres copias de la tabla consulta para comparar rendimiento

-- Crear tabla sin índice columnar
SELECT * INTO consulta_sin_columnstore 
FROM consulta 
WHERE 1 = 0;

-- Crear tabla con índice columnar
SELECT * INTO consulta_con_columnstore 
FROM consulta 
WHERE 1 = 0;

-- Crear tabla con índice agrupado tradicional (para comparación)
SELECT * INTO consulta_con_agrupado 
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

    INSERT INTO consulta_con_agrupado (
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
SELECT COUNT(*) AS 'consulta_con_agrupado cantidad' FROM consulta_con_agrupado;
GO

-- CREAR ÍNDICES
-- Se crea un índice columnar y un índice agrupado tradicional

-- Crear índice columnar no agrupado en la tabla consulta_con_columnstore
CREATE NONCLUSTERED COLUMNSTORE INDEX IDX_Consulta_Columnstore 
ON consulta_con_columnstore (fecha_consulta, id_mascota, id_veterinario, motivo, diagnostico);
GO

-- Crear índice agrupado tradicional en la tabla consulta_con_agrupado
CREATE CLUSTERED INDEX IDX_Consulta_Agrupado_Fecha 
ON consulta_con_agrupado (fecha_consulta);
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

-- CONSULTA ANALÍTICA - CON ÍNDICE AGRUPADO TRADICIONAL
-- La misma consulta sobre la tabla con índice agrupado para comparación

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    id_veterinario,
    YEAR(fecha_consulta) AS año,
    MONTH(fecha_consulta) AS mes,
    COUNT(*) AS total_consultas,
    COUNT(DISTINCT id_mascota) AS mascotas_atendidas
FROM consulta_con_agrupado
WHERE fecha_consulta BETWEEN '2024-01-01' AND '2030-12-31'
GROUP BY id_veterinario, YEAR(fecha_consulta), MONTH(fecha_consulta)
ORDER BY total_consultas DESC;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- Documentar para cada prueba:
-- 1. Tiempo de CPU (CPU time)
-- 2. Tiempo transcurrido (elapsed time)
-- 3. Lecturas lógicas (logical reads)
-- 4. Scan count
-- 5. Número de filas devueltas