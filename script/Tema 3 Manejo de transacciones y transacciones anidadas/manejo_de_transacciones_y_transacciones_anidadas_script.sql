-- SCRIPT DE MANEJO DE TRANSACCIONES
-- Base de Datos: DBMyVet
-- Escenario: Registro de una consulta

USE DBMyVet;
GO

-- ESCENARIO
-- Cuando se registra una consulta veterinaria completa se debe:
-- 1. Insertar un nuevo propietario (si no existe)
-- 2. Insertar una nueva mascota asociada al propietario
-- 3. Insertar el registro de la consulta veterinaria
-- 4. Actualizar el estado de la agenda a 'Finalizada'
-- 
-- Todas estas operaciones deben completarse exitosamente o ninguna debe aplicarse

-- Verificar datos iniciales

-- Ver cantidad de registros antes de las transacciones
SELECT COUNT(*) AS Total_Propietarios FROM propietario;
SELECT COUNT(*) AS Total_Mascotas FROM mascota;
SELECT COUNT(*) AS Total_Consultas FROM consulta;
SELECT COUNT(*) AS Total_Agendas FROM agenda;
GO

---Total_Propietarios:2
--Total_Mascotas:2
--Total_Consultas:1222628
--Total_Agenda:2

-- TRANSACCIÓN EXITOSA
-- Todas las operaciones se completan correctamente

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Insertar un nuevo propietario
    INSERT INTO propietario (
        nombre_propietario, 
        apellido_propietario, 
        dni, 
        direccion, 
        telefono, 
        telefono_alternativo
    )
    VALUES (
        'Juan Carlos',
        'Pérez García',
        12345678,
        'Av. Libertad 1234, Corrientes',
        '3794123456',
        '3794654321'
    );
    
    -- Obtener el ID del propietario recién insertado
    DECLARE @id_propietario_nuevo INT = SCOPE_IDENTITY();
    PRINT 'Propietario insertado con ID: ' + CAST(@id_propietario_nuevo AS VARCHAR(10));
    
    -- 2. Insertar una nueva mascota asociada al propietario
    INSERT INTO mascota (
        nombre,
        genero,
        fecha_nacimiento,
        estado_reproductivo,
        peso_en_kg,
        estado_mascota,
        id_raza,
        id_propietario
    )
    VALUES (
        'Max',
        'Macho',
        '2020-05-15',
        'Castrado',
        15.50,
        'Activo',
        1,  -- Ajustar según datos existentes
        @id_propietario_nuevo
    );
    
    -- Obtener el ID de la mascota recién insertada
    DECLARE @id_mascota_nueva INT = SCOPE_IDENTITY();
    PRINT 'Mascota insertada con ID: ' + CAST(@id_mascota_nueva AS VARCHAR(10));
    
    -- 3. Insertar el registro de la consulta veterinaria
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
        GETDATE(),
        'Consulta de primera vez',
        'Animal en buen estado de salud general',
        'Desparasitación y calendario de vacunación',
        DATEADD(MONTH, 1, GETDATE()),
        'Ninguno',
        @id_mascota_nueva,
        1
    );
    
    DECLARE @id_consulta_nueva INT = SCOPE_IDENTITY();
    PRINT 'Consulta insertada con ID: ' + CAST(@id_consulta_nueva AS VARCHAR(10));
    
    -- 4. Actualizar el estado de una agenda de 'Pendiente' a 'Finalizada'
    -- Buscar una agenda pendiente para actualizar
    DECLARE @id_agenda_actualizar INT;
    SELECT TOP 1 @id_agenda_actualizar = id_agenda 
    FROM agenda 
    WHERE agenda_estado = 'Pendiente' AND activo = 1;
    
    IF @id_agenda_actualizar IS NOT NULL
    BEGIN
        UPDATE agenda 
        SET agenda_estado = 'Finalizada',
            descripcion_agenda = 'Consulta completada - ID: ' + CAST(@id_consulta_nueva AS VARCHAR(10))
        WHERE id_agenda = @id_agenda_actualizar;
        
        PRINT 'Agenda actualizada con ID: ' + CAST(@id_agenda_actualizar AS VARCHAR(10));
    END
    ELSE
    BEGIN
        PRINT 'No se encontró agenda pendiente para actualizar';
    END
    
    -- Si todo salió bien, confirmar la transacción
    COMMIT TRANSACTION;
    PRINT 'TRANSACCIÓN EXITOSA: Todos los cambios han sido confirmados';
    
END TRY
BEGIN CATCH
    -- Si ocurrió algún error, revertir todos los cambios
    ROLLBACK TRANSACTION;
    
    PRINT 'ERROR EN LA TRANSACCIÓN: Todos los cambios han sido revertidos';
    PRINT 'Número de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Mensaje de Error: ' + ERROR_MESSAGE();
    PRINT 'Línea del Error: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    
END CATCH;
GO

-- Verificar los resultados después de la transacción exitosa
SELECT COUNT(*) AS Total_Propietarios FROM propietario;
SELECT COUNT(*) AS Total_Mascotas FROM mascota;
SELECT COUNT(*) AS Total_Consultas FROM consulta;
SELECT COUNT(*) AS Total_Agendas_Finalizadas FROM agenda WHERE agenda_estado = 'Finalizada';
GO

--(1 row(s) affected)
--Propietario insertado con ID: 3
--(1 row(s) affected)
--Mascota insertada con ID: 3
--(1 row(s) affected)
--Consulta insertada con ID: 1412083
--(1 row(s) affected)
--Agenda actualizada con ID: 1
--TRANSACCIÓN EXITOSA: Todos los cambios han sido confirmados

---Total_Propietarios:3
--Total_Mascotas:3
--Total_Consultas:1222629
--Total_Agenda:1

--TRANSACCIÓN CON ERROR PROVOCADO
-- Se provoca un error intencional después del primer INSERT
-- Todos los cambios deben revertirse

-- Ver cantidad de registros antes de la transacción con error
PRINT 'ANTES DE LA TRANSACCIÓN CON ERROR:';
SELECT COUNT(*) AS Total_Propietarios FROM propietario;
SELECT COUNT(*) AS Total_Mascotas FROM mascota;
SELECT COUNT(*) AS Total_Consultas FROM consulta;
GO

---Total_Propietarios:3
--Total_Mascotas:3
--Total_Consultas:1222629

BEGIN TRANSACTION;

BEGIN TRY
    -- 1. Insertar un nuevo propietario
    INSERT INTO propietario (
        nombre_propietario, 
        apellido_propietario, 
        dni, 
        direccion, 
        telefono, 
        telefono_alternativo
    )
    VALUES (
        'María Laura',
        'González Silva',
        87654321,
        'Calle San Martín 567, Corrientes',
        '3794987654',
        '3794456789'
    );
    
    DECLARE @id_propietario_error INT = SCOPE_IDENTITY();
    PRINT 'Propietario insertado temporalmente con ID: ' + CAST(@id_propietario_error AS VARCHAR(10));
    
    -- ERROR PROVOCADO INTENCIONALMENTE
    -- Se intenta insertar una mascota con un id_propietario que no existe (violación de FK)
    -- O se intenta insertar un DNI duplicado en propietario
    INSERT INTO mascota (
        nombre,
        genero,
        fecha_nacimiento,
        estado_reproductivo,
        peso_en_kg,
        estado_mascota,
        id_raza,
        id_propietario
    )
    VALUES (
        'Luna',
        'Hembra',
        '2021-08-20',
        'Esterilizada',
        8.30,
        'Activo',
        1,
        99999  -- ID de propietario inexistente - 
    );
    
    -- Este código nunca se ejecutará debido al error anterior
    INSERT INTO consulta (
        fecha_consulta,
        motivo,
        diagnostico,
        tratamiento,
        sintomas,
        id_mascota,
        id_veterinario
    )
    VALUES (
        GETDATE(),
        'Este registro no debería insertarse',
        'Este diagnóstico no debería guardarse',
        'Este tratamiento no debería guardarse',
        'Ninguno',
        1,
        1
    );
    
    -- Si llegara hasta aquí (no lo hará), confirmar la transacción
    COMMIT TRANSACTION;
    PRINT 'TRANSACCIÓN EXITOSA: Este mensaje NO debería aparecer';
    
END TRY
BEGIN CATCH
    -- El error es capturado y se revierten todos los cambios
    ROLLBACK TRANSACTION;
    
    PRINT '';
    PRINT 'ERROR CAPTURADO - TRANSACCIÓN REVERTIDA';
    PRINT 'Número de Error: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
    PRINT 'Mensaje de Error: ' + ERROR_MESSAGE();
    PRINT 'Línea del Error: ' + CAST(ERROR_LINE() AS VARCHAR(10));
    PRINT 'Procedimiento: ' + ISNULL(ERROR_PROCEDURE(), 'Script principal');
    PRINT '';
    PRINT 'RESULTADO: Ningún dato fue insertado. La base de datos mantiene su consistencia.';
    
END CATCH;
GO

--(1 row(s) affected)
--Propietario insertado temporalmente con ID: 4

--(0 row(s) affected)
 
--ERROR CAPTURADO - TRANSACCIÓN REVERTIDA
--Número de Error: 547
--Mensaje de Error: The INSERT statement conflicted with the FOREIGN KEY constraint --"FK_Mascota_Propietario". The conflict occurred in database "DBMyVet", table "dbo.propietario", --column 'id_propietario'.
--Línea del Error: 28
 
--RESULTADO: Ningún dato fue insertado. La base de datos mantiene su consistencia.

-- Verificar que NO se insertaron los registros (los contadores deben ser iguales a antes)
PRINT 'DESPUÉS DE LA TRANSACCIÓN CON ERROR:';
SELECT COUNT(*) AS Total_Propietarios FROM propietario;
SELECT COUNT(*) AS Total_Mascotas FROM mascota;
SELECT COUNT(*) AS Total_Consultas FROM consulta;
GO

---Total_Propietarios:3
--Total_Mascotas:3
--Total_Consultas:1222629

-- Verificar que el propietario "María Laura González Silva" NO existe
SELECT * FROM propietario WHERE nombre_propietario = 'María Laura' AND apellido_propietario = 'González Silva';
GO
-- CONCLUSIONES FINALES

-- Transacción Exitosa
-- Estado inicial: 2 propietarios, 2 mascotas, 1,222,628 consultas, 2 agendas
-- Estado final: 3 propietarios, 3 mascotas, 1,222,629 consultas, 1 agenda finalizada
-- Observación: Todas las operaciones se completaron exitosamente. Se insertó un propietario 
-- (ID: 3), una mascota (ID: 3) y una consulta (ID: 1,412,083), y se actualizó el estado de 
-- una agenda a 'Finalizada'. El uso de BEGIN TRANSACTION y COMMIT garantizó que todos los 
-- cambios se aplicaran de forma atómica, manteniendo la integridad referencial entre las tablas.

-- Transacción con Error Provocado
-- Estado inicial: 3 propietarios, 3 mascotas, 1,222,629 consultas
-- Estado final: 3 propietarios, 3 mascotas, 1,222,629 consultas (sin cambios)
-- Error capturado: Número 547 - Violación de clave foránea (FK_Mascota_Propietario)
-- Observación: Se insertó temporalmente un propietario (ID: 4), pero al intentar insertar 
-- una mascota con id_propietario inexistente (99999), se produjo un error que activó el 
-- bloque CATCH. El ROLLBACK revirtió exitosamente el INSERT del propietario, manteniendo 
-- la consistencia de la base de datos. Los contadores permanecieron idénticos a los valores 
-- previos a la transacción, confirmando que ningún dato quedó parcialmente insertado.

-- Conclusión
-- Las transacciones garantizan la propiedad ACID (Atomicidad, Consistencia, Aislamiento y 
-- Durabilidad) en las operaciones de base de datos. La atomicidad asegura que todas las 
-- operaciones dentro de una transacción se completen exitosamente o ninguna se aplique. 
-- En la Prueba 1, el COMMIT confirmó todos los cambios al completarse sin errores. En la 
-- Prueba 2, el mecanismo TRY-CATCH capturó el error de violación de clave foránea y el 
-- ROLLBACK revirtió automáticamente el INSERT del propietario, evitando datos huérfanos 
-- o inconsistencias. Esto demuestra que las transacciones son fundamentales para mantener 
-- la integridad de los datos en operaciones que involucran múltiples tablas relacionadas, 
-- especialmente en escenarios críticos como el registro de consultas veterinarias donde 
-- la relación entre propietario, mascota y consulta debe ser consistente.