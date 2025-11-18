# Tema: Procedimientos y funciones almacenadas en bases de datos

## Introducción

Los procedimientos y funciones almacenadas son bloques de código que se guardan en la base de datos y permiten realizar operaciones de manera repetitiva y eficiente. En sistemas con gran cantidad de datos, como un sistema de gestión veterinaria, su uso facilita el manejo de datos y mejora la organización del código, evitando repetir sentencias SQL en diferentes consultas.

La principal diferencia entre procedimientos y funciones es que los procedimientos almacenados pueden realizar acciones como INSERT, UPDATE, DELETE y no necesariamente retornan un valor, mientras que las funciones almacenadas devuelven un valor y pueden ser usadas dentro de consultas SQL como SELECT o WHERE.

## Qué es un procedimiento almacenado?

Un procedimiento almacenado es un conjunto de instrucciones SQL que se almacena en la base de datos y se ejecuta mediante un único llamado. Esto permite reutilizar código en varias partes del sistema, mantener la lógica centralizada y reducir errores al no repetir las mismas consultas en distintos lugares.

Ejemplo de uso: insertar una nueva mascota en la tabla mascota mediante un procedimiento almacenado:
EXEC sp_InsertarMascota @nombre = 'Fido', @genero = 'Macho', @fecha_nacimiento = '2022-05-10', @estado_reproductivo = 'Castrado', @peso_en_kg = 12.5, @estado_mascota = 'Sano', @id_raza = 1, @id_propietario = 1;

## Qué es una función almacenada?

Una función almacenada es similar a un procedimiento, pero siempre devuelve un valor y puede usarse dentro de otras consultas SQL. Por ejemplo, se puede calcular la edad de una mascota a partir de su fecha de nacimiento:
SELECT nombre, dbo.fn_CalcularEdad(fecha_nacimiento) AS edad FROM mascota;

Ventajas de las funciones: permiten cálculos reutilizables, se pueden usar en SELECT, WHERE o ORDER BY y mantienen el código más limpio y organizado.

## Tipos de funciones

Las funciones escalares devuelven un único valor, como la edad de una mascota, mientras que las funciones de tabla devuelven una tabla completa que puede ser usada como cualquier otra tabla en la base de datos.

## Ventajas de procedimientos y funciones almacenadas

Reutilización del código, seguridad al poder asignar permisos de ejecución a determinados usuarios sin darles acceso directo a la tabla, mantenimiento más sencillo al centralizar la lógica y eficiencia porque el servidor SQL guarda el plan de ejecución, mejorando el rendimiento.

Ejemplo práctico en un sistema veterinario

Procedimientos almacenados: sp_InsertarMascota inserta un nuevo registro en la tabla mascota, sp_ActualizarMascota actualiza datos de una mascota existente y sp_EliminarMascota elimina un registro de mascota.

Funciones almacenadas: fn_CalcularEdad devuelve la edad de una mascota, fn_PesoIdeal indica si el peso de la mascota es bajo, normal o alto y fn_EsAdulto devuelve 1 si la mascota tiene 2 años o más, 0 en caso contrario.

Uso combinado: se pueden insertar 100,000 mascotas con INSERT directo y también usando el procedimiento sp_InsertarMascota, actualizar y eliminar registros usando procedimientos y consultar datos calculados usando las funciones para evaluar edad, peso y si la mascota es adulta.

## Comparación entre consultas directas y procedimientos/funciones

Aunque escribir sentencias SQL directas funciona, usar procedimientos y funciones hace que el código sea más limpio, más seguro y más fácil de mantener, especialmente cuando hay muchos registros.

## Consideraciones de diseño

Los procedimientos y funciones deben recibir parámetros claros para evitar errores, se pueden agregar validaciones dentro de ellos para proteger los datos, se pueden asignar permisos de ejecución a usuarios que no tienen acceso directo a las tablas y hay que tener en cuenta que funciones complejas sobre millones de registros pueden ser lentas.

## Conclusión

Los procedimientos y funciones almacenadas son herramientas esenciales para manejar grandes volúmenes de información y mantener un código limpio y seguro. Los procedimientos permiten operaciones CRUD centralizadas y más seguras, mientras que las funciones permiten cálculos reutilizables dentro de consultas SQL. Combinarlas reduce errores, facilita el mantenimiento y mejora la eficiencia de la base de datos. En un sistema veterinario con muchas mascotas, consultas de edad, peso y estado de salud, estas herramientas permiten obtener información rápidamente y de manera confiable. Se recomienda usar procedimientos para todas las operaciones de inserción, actualización y eliminación, y funciones para cálculos que se usan en varias consultas.
