-- ROLES

INSERT INTO rol (nombre_rol) VALUES
('Administrador'),
('Veterinario'),
('Recepcionista');

-- USUARIOS

INSERT INTO usuario (nombre, apellido, imagen_perfil, correo, contraseña, id_rol)
VALUES
('Carlos', 'Gómez', NULL, 'carlos.admin@vet.com', '1234', 1),
('Lucía', 'Martínez', NULL, 'lucia.vet@vet.com', '1234', 2),
('Pedro', 'Rivas', NULL, 'pedro.rec@vet.com', '1234', 3);

-- ESPECIES

INSERT INTO especie (nombre_especie) VALUES
('Canino'),
('Felino');

-- RAZAS

INSERT INTO raza (nombre_raza, id_especie) VALUES
('Labrador Retriever', 1),
('Bulldog', 1),
('Siames', 2),
('Persa', 2);

-- PROPIETARIOS

INSERT INTO propietario (nombre_propietario, apellido_propietario, dni, direccion, telefono, telefono_alternativo)
VALUES
('María', 'Lopez', 30123456, 'Av Siempre Viva 123', '1122334455', NULL),
('Juan', 'Pérez', 28999888, 'Calle Falsa 742', '1133445566', '1199887766');

-- MASCOTAS

INSERT INTO mascota (nombre, foto, genero, fecha_nacimiento, estado_reproductivo, peso_en_kg,
                     estado_mascota, id_raza, id_propietario)
VALUES
('Rocky', NULL, 'Macho', '2020-05-10', 'Castrado', 25.5, 'Sano', 1, 1),
('Luna', NULL, 'Hembra', '2021-08-20', 'Entera', 4.2, 'Sano', 3, 2);

-- ESPECIALIDADES

INSERT INTO especialidad (nombre_especialidad)
VALUES
('Clinica General'),
('Traumatología'),
('Dermatología');

-- VETERINARIO

INSERT INTO veterinario (matricula, id_especialidad, id_usuario)
VALUES
('VET-001', 1, 2);

-- VACUNAS

INSERT INTO vacuna (nombre_vacuna)
VALUES
('Quíntuple'),
('Rabia'),
('Triple Felina');

-- CONSULTAS

INSERT INTO consulta (motivo, diagnostico, tratamiento, proximo_control, url_archivo, sintomas,
                      id_mascota, id_veterinario)
VALUES
('Control anual', 'Sin anomalías', 'Ninguno', '2025-03-01', NULL, 'Ninguno', 1, 1),
('Pérdida de apetito', 'Gastroenteritis leve', 'Dieta blanda', '2025-02-20', NULL, 'Vómitos', 2, 1);

-- AGENDA

INSERT INTO agenda (fecha_inicio, fecha_fin, agenda_estado, descripcion_agenda, id_mascota, id_usuario)
VALUES
('2025-02-03 10:00', '2025-02-03 10:30', 'Pendiente', 'Consulta de control', 1, 2),
('2025-02-04 15:00', '2025-02-04 15:30', 'Pendiente', 'Consulta por síntomas', 2, 2);

-- VACUNACIONES

INSERT INTO vacunacion (laboratorio, lote, observaciones, id_vacuna, id_veterinario, id_mascota)
VALUES
('PfizerVet', 'L001A', 'Aplicación sin complicaciones', 1, 1, 1),
('VetLabs',  'A22F',  'Sin reacciones',               3, 1, 2);

-- MODULOS

INSERT INTO modulo (nombre_modulo) VALUES
('Usuarios'),
('Mascotas'),
('Consultas'),
('Vacunaciones'),
('Agenda');

-- PERMISOS

INSERT INTO permiso (descripcion, id_modulo)
VALUES
('Crear Usuario', 1),
('Editar Usuario', 1),
('Registrar Mascota', 2),
('Editar Mascota', 2),
('Registrar Consulta', 3),
('Registrar Vacunación', 4),
('Gestionar Agenda', 5);

-- PERMISOS POR ROL

-- Administrador: todos
INSERT INTO rol_permiso
SELECT id_permiso, 1 FROM permiso;

-- Veterinario
INSERT INTO rol_permiso (id_permiso, id_rol) VALUES
(5, 2),  -- Registrar consulta  
(6, 2),  -- Registrar vacunación  
(7, 2);  -- Gestionar agenda

-- Recepcionista
INSERT INTO rol_permiso (id_permiso, id_rol) VALUES
(3, 3),  -- Registrar mascota  
(4, 3),  -- Editar mascota  
(7, 3);  -- Gestionar agenda

-----LOTE DE PRUEBA

INSERT INTO propietario (nombre_propietario, apellido_propietario, dni, direccion, telefono)
VALUES ('Pablo', 'DNI', 123456789, 'Direccion X', '11111111'); -- DNI supera 8 dígitos, no se cumple con la restricciónCK_DNI

INSERT INTO mascota (nombre, foto, genero, fecha_nacimiento, estado_reproductivo,
                     peso_en_kg, estado_mascota, id_raza, id_propietario)
VALUES ('koko', NULL, 'Otro', '2020-01-01', 'Castrado', 10.5, 'Sano', 1, 1); -- Valor no permitido en CK_Mascota_Genero

INSERT INTO agenda (fecha_inicio, fecha_fin, agenda_estado, descripcion_agenda, id_mascota, id_usuario)
VALUES ('2025-02-10 15:00', '2025-02-10 14:00', 'Pendiente', 'Error fechas', 1, 2);--fecha_fin <= fecha_inicio

INSERT INTO usuario (nombre, apellido, correo, contraseña, id_rol)
VALUES ('Juan', 'Rodriguez', 'carlos.admin@vet.com', '1234', 1);-- Correo repetido




