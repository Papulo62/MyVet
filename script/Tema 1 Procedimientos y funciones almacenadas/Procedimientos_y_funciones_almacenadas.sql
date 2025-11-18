USE DBMyVet;
GO

-- =========================================
-- PROCEDIMIENTOS ALMACENADOS PARA MASCOTA
-- =========================================

-- INSERTAR MASCOTA
CREATE PROCEDURE sp_InsertarMascota
    @nombre VARCHAR(100),
    @foto VARCHAR(250) = NULL,
    @genero VARCHAR(20),
    @fecha_nacimiento DATE,
    @estado_reproductivo VARCHAR(100),
    @peso_en_kg DECIMAL(5,2),
    @estado_mascota VARCHAR(100),
    @id_raza INT,
    @id_propietario INT
AS
BEGIN
    INSERT INTO mascota (
        nombre, foto, genero, fecha_nacimiento, estado_reproductivo,
        peso_en_kg, estado_mascota, id_raza, id_propietario
    )
    VALUES (
        @nombre, @foto, @genero, @fecha_nacimiento, @estado_reproductivo,
        @peso_en_kg, @estado_mascota, @id_raza, @id_propietario
    );
END;
GO

-- ACTUALIZAR MASCOTA
CREATE PROCEDURE sp_ActualizarMascota
    @id_mascota INT,
    @nombre VARCHAR(100),
    @peso_en_kg DECIMAL(5,2),
    @estado_mascota VARCHAR(100)
AS
BEGIN
    UPDATE mascota
    SET nombre = @nombre,
        peso_en_kg = @peso_en_kg,
        estado_mascota = @estado_mascota
    WHERE id_mascota = @id_mascota;
END;
GO

-- ELIMINAR MASCOTA
CREATE PROCEDURE sp_EliminarMascota
    @id_mascota INT
AS
BEGIN
    DELETE FROM mascota
    WHERE id_mascota = @id_mascota;
END;
GO

-- =========================================
-- FUNCIONES ALMACENADAS
-- =========================================

-- FUNCION PARA CALCULAR EDAD
CREATE FUNCTION fn_CalcularEdad(@fecha_nac DATE)
RETURNS INT
AS
BEGIN
    DECLARE @edad INT;
    SET @edad = DATEDIFF(YEAR, @fecha_nac, GETDATE()) - 
                CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @fecha_nac, GETDATE()), @fecha_nac) > GETDATE() THEN 1 ELSE 0 END;
    RETURN @edad;
END;
GO

-- FUNCION PARA DETERMINAR PESO IDEAL (EJEMPLO SIMPLE)
CREATE FUNCTION fn_PesoIdeal(@peso DECIMAL(5,2))
RETURNS VARCHAR(20)
AS
BEGIN
    RETURN CASE 
        WHEN @peso < 5 THEN 'Bajo'
        WHEN @peso BETWEEN 5 AND 20 THEN 'Normal'
        ELSE 'Alto'
    END;
END;
GO

-- FUNCION PARA SABER SI LA MASCOTA ES ADULTA
CREATE FUNCTION fn_EsAdulto(@fecha_nac DATE)
RETURNS BIT
AS
BEGIN
    IF dbo.fn_CalcularEdad(@fecha_nac) >= 2
        RETURN 1;
    RETURN 0;
END;
GO

-- =========================================
-- INSERCION MASIVA DE REGISTROS (100,000)
-- =========================================

DECLARE @i INT = 1;

WHILE @i <= 100000
BEGIN
    -- INSERT DIRECTO
    INSERT INTO mascota (nombre, genero, fecha_nacimiento, estado_reproductivo, peso_en_kg, estado_mascota, id_raza, id_propietario)
    VALUES (
        CONCAT('Mascota_', @i),
        CASE WHEN @i % 2 = 0 THEN 'Macho' ELSE 'Hembra' END,
        DATEADD(DAY, -@i, GETDATE()),
        'Castrado',
        CAST((5 + (@i % 15)) AS DECIMAL(5,2)),
        'Sano',
        1,
        1
    );

    -- INSERT USANDO PROCEDIMIENTO
    EXEC sp_InsertarMascota
        @nombre = CONCAT('ProcMascota_', @i),
        @genero = CASE WHEN @i % 2 = 0 THEN 'Macho' ELSE 'Hembra' END,
        @fecha_nacimiento = DATEADD(DAY, -@i, GETDATE()),
        @estado_reproductivo = 'Castrado',
        @peso_en_kg = CAST((5 + (@i % 15)) AS DECIMAL(5,2)),
        @estado_mascota = 'Sano',
        @id_raza = 1,
        @id_propietario = 1;

    SET @i = @i + 1;
END;
GO

-- =========================================
-- UPDATE Y DELETE DE PRUEBA
-- =========================================

-- Actualizamos 3 mascotas
EXEC sp_ActualizarMascota 1, 'FidoActualizado', 12.5, 'Sano';
EXEC sp_ActualizarMascota 2, 'LunaActualizada', 8.3, 'Enfermo';
EXEC sp_ActualizarMascota 3, 'MaxActualizado', 15.0, 'Sano';

-- Eliminamos 2 mascotas
EXEC sp_EliminarMascota 4;
EXEC sp_EliminarMascota 5;
GO

-- =========================================
-- CONSULTA DE PRUEBA USANDO FUNCIONES
-- =========================================

SELECT TOP 10 
    nombre,
    dbo.fn_CalcularEdad(fecha_nacimiento) AS edad,
    dbo.fn_PesoIdeal(peso_en_kg) AS peso_ideal,
    dbo.fn_EsAdulto(fecha_nacimiento) AS es_adulto
FROM mascota;
GO

-- =========================================
-- CONCLUSIONES FINALES (ESTILO ÍNDICES)
-- =========================================

-- Observación:
-- 1. Se crearon procedimientos para insertar, actualizar y eliminar registros en la tabla mascota.
-- 2. Se crearon tres funciones para calcular edad, peso ideal y determinar si la mascota es adulta.
-- 3. Se insertaron 100,000 registros usando INSERT directo y también invocando procedimientos.
-- 4. Se realizaron actualizaciones y eliminaciones usando procedimientos.
-- 5. La consulta final muestra el uso de funciones y cómo devuelven valores calculados automáticamente.
-- 6. Esto demuestra que los procedimientos facilitan operaciones CRUD repetitivas y las funciones permiten cálculos reutilizables.
-- 7. Al usar procedimientos y funciones, se simplifica la manipulación de datos y se mantiene un código más limpio y organizado.

