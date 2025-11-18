# Tema: Manejo de Transacciones y Transacciones Anidadas en SQL Server

## Introducción

El manejo de transacciones es fundamental en bases de datos relacionales para garantizar la integridad y consistencia de los datos cuando se realizan múltiples operaciones relacionadas. Una transacción representa un punto en el que los datos referenciados por una conexión son lógica y físicamente coherentes, permitiendo que todas las modificaciones se completen sin errores o se reviertan para devolver los datos a un estado conocido de coherencia .

## ¿Qué es una Transacción?

Una transacción es una secuencia de operaciones que se ejecutan como una sola unidad de trabajo. Cada transacción dura hasta que se completa sin errores y se emite COMMIT TRANSACTION para hacer las modificaciones permanentes, o se detectan errores y todas las modificaciones se borran con ROLLBACK TRANSACTION .

### Propiedades ACID

- **Atomicidad:** Todas las operaciones se completan o ninguna se aplica
- **Consistencia:** La base de datos pasa de un estado válido a otro estado válido
- **Aislamiento:** Las transacciones concurrentes no interfieren entre sí
- **Durabilidad:** Una vez confirmada, la transacción persiste incluso ante fallos

## Instrucciones de Control de Transacciones

### BEGIN TRANSACTION
Marca el punto de inicio de una transacción local explícita. Las transacciones explícitas empiezan con BEGIN TRANSACTION y acaban con COMMIT o ROLLBACK .
```sql
BEGIN TRANSACTION;
```

### COMMIT TRANSACTION
Hace que los cambios en la transacción se confirmen permanentemente en la base de datos .
```sql
COMMIT TRANSACTION;
```

### ROLLBACK TRANSACTION
Revierte una transacción explícita o implícita al principio de la transacción, o a un punto de guardado dentro de la transacción .
```sql
ROLLBACK TRANSACTION;
```

## Manejo de Errores con TRY...CATCH

Si no hay errores en el código incluido en un bloque TRY, cuando finaliza la última instrucción del bloque TRY, el control pasa a la instrucción inmediatamente después de END CATCH. Si hay un error, el control pasa a la primera instrucción del bloque asociado CATCH .
```sql
BEGIN TRY
    BEGIN TRANSACTION;
    -- Operaciones de base de datos
    INSERT INTO tabla1 VALUES (...);
    UPDATE tabla2 SET ... WHERE ...;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
```

### Funciones de Error

| Función | Descripción |
|---------|-------------|
| **ERROR_NUMBER()** | Número único del error |
| **ERROR_MESSAGE()** | Texto completo del mensaje de error |
| **ERROR_LINE()** | Línea donde ocurrió el error |

## Transacciones Anidadas

SQL Server permite anidar transacciones mediante múltiples instrucciones BEGIN TRANSACTION. La función @@TRANCOUNT registra el nivel de anidamiento. Cada BEGIN TRANSACTION incrementa @@TRANCOUNT en uno, y cada COMMIT lo reduce en uno .

**Comportamiento importante:**
Una instrucción ROLLBACK sin parámetro en cualquier nivel de un conjunto de transacciones anidadas revertirá todas las transacciones anidadas, incluida la más externa .
```sql
BEGIN TRANSACTION TxPrincipal;  -- @@TRANCOUNT = 1
    INSERT INTO tabla1 VALUES (...);
    
    BEGIN TRANSACTION TxAnidada;  -- @@TRANCOUNT = 2
        INSERT INTO tabla2 VALUES (...);
    COMMIT TRANSACTION;  -- @@TRANCOUNT = 1
    
COMMIT TRANSACTION;  -- @@TRANCOUNT = 0
```

## Ejemplo Práctico: Registro de Consulta Veterinaria
```sql
BEGIN TRANSACTION;
BEGIN TRY
    -- Insertar propietario
    INSERT INTO propietario (...) VALUES (...);
    DECLARE @id_propietario INT = SCOPE_IDENTITY();
    
    -- Insertar mascota asociada
    INSERT INTO mascota (..., id_propietario) VALUES (..., @id_propietario);
    DECLARE @id_mascota INT = SCOPE_IDENTITY();
    
    -- Insertar consulta
    INSERT INTO consulta (..., id_mascota) VALUES (..., @id_mascota);
    
    -- Actualizar agenda
    UPDATE agenda SET agenda_estado = 'Finalizada' WHERE id_agenda = @id;
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error: ' + ERROR_MESSAGE();
END CATCH;
```

## Conclusión

Las transacciones garantizan la integridad de los datos mediante las propiedades ACID. Permiten que todas las modificaciones se completen sin errores o se reviertan a un estado conocido de coherencia .

En sistemas veterinarios donde múltiples tablas relacionadas deben mantenerse sincronizadas, las transacciones aseguran que todas las operaciones se completen exitosamente o ninguna se aplique, evitando datos huérfanos o inconsistencias. El uso correcto de BEGIN TRANSACTION, COMMIT, ROLLBACK y TRY...CATCH permite construir aplicaciones confiables que mantienen la integridad incluso ante errores inesperados o violaciones de restricciones.

**Puntos clave:**
- Siempre usar TRY...CATCH con transacciones
- Mantener las transacciones cortas para evitar bloqueos prolongados
- Un ROLLBACK en transacciones anidadas revierte TODAS las transacciones
- Validar datos antes de iniciar la transacción cuando sea posible

