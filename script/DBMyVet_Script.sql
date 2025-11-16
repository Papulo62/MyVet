-- SCRIPT TEMA "MyVet"
-- DEFINICIÓN DEL MODELO DE DATOS

Create DataBase DBMyVet
GO
Use DBMyVet 
GO

CREATE TABLE rol
(
  id_rol INT IDENTITY(1,1) NOT NULL,
  nombre_rol VARCHAR(100) NOT NULL,
  activo BIT NOT NULL CONSTRAINT DF_Rol_Activo DEFAULT 1,
  CONSTRAINT PK_Rol PRIMARY KEY (id_rol),
  CONSTRAINT UQ_Rol_Nombre UNIQUE (nombre_rol)
);


CREATE TABLE usuario
(
  id_usuario INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(50) NOT NULL,
  apellido VARCHAR(50) NOT NULL,
  imagen_perfil VARCHAR(200),
  correo VARCHAR(200) NOT NULL,
  contraseña VARCHAR(200) NOT NULL,
  id_rol INT NOT NULL,
  activo BIT NOT NULL   CONSTRAINT DF_Usuario_Activo DEFAULT 1,
  fecha_creacion DATETIME NOT NULL CONSTRAINT DF_Usuario_Fecha DEFAULT GETDATE(),
  CONSTRAINT PK_Usuario PRIMARY KEY (id_usuario),
  CONSTRAINT UQ_Usuario_Correo UNIQUE (correo),
  CONSTRAINT FK_Usuario_Rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);


CREATE TABLE especie
(
  id_especie INT IDENTITY(1,1) NOT NULL,
  nombre_especie VARCHAR(100) NOT NULL,
  activo BIT NOT NULL CONSTRAINT DF_Especie_Activo DEFAULT 1,
  CONSTRAINT PK_Especie PRIMARY KEY (id_especie),
  CONSTRAINT UQ_Especie_Nombre UNIQUE (nombre_especie)
);


CREATE TABLE raza
(
  id_raza INT IDENTITY(1,1) NOT NULL,
  nombre_raza VARCHAR(100) NOT NULL,
  id_especie INT NOT NULL,
  activo BIT NOT NULL   CONSTRAINT DF_Raza_Activo DEFAULT 1,
  CONSTRAINT PK_Raza PRIMARY KEY (id_raza),
  CONSTRAINT FK_Raza_Especie FOREIGN KEY (id_especie) REFERENCES especie(id_especie)
);


CREATE TABLE propietario
(
  id_propietario INT IDENTITY(1,1) NOT NULL,
  nombre_propietario VARCHAR(100) NOT NULL,
  apellido_propietario VARCHAR(100) NOT NULL,
  dni INT NOT NULL,
  direccion VARCHAR(250) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  telefono_alternativo VARCHAR(20),
  activo BIT NOT NULL  CONSTRAINT DF_Propietario_Activo DEFAULT 1,
  CONSTRAINT CK_DNI CHECK (dni BETWEEN 0 AND 99999999),
  CONSTRAINT PK_Propietario PRIMARY KEY (id_propietario),
  CONSTRAINT UQ_Propietario_DNI UNIQUE (dni)
);


CREATE TABLE mascota
(
  id_mascota INT IDENTITY(1,1) NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  foto VARCHAR(250),
  genero VARCHAR(20) NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  estado_reproductivo VARCHAR(100) NOT NULL,
  peso_en_kg DECIMAL(5,2) NOT NULL,
  estado_mascota VARCHAR(100) NOT NULL,
  id_raza INT NOT NULL,
  id_propietario INT NOT NULL,
  activo BIT NOT NULL  CONSTRAINT DF_Mascota_Activo DEFAULT 1,
  CONSTRAINT PK_Mascota PRIMARY KEY (id_mascota),
  CONSTRAINT FK_Mascota_Raza FOREIGN KEY (id_raza) REFERENCES raza(id_raza),
  CONSTRAINT FK_Mascota_Propietario FOREIGN KEY (id_propietario) REFERENCES propietario(id_propietario),
  CONSTRAINT CK_Mascota_Peso CHECK (peso_en_kg > 0),
  CONSTRAINT CK_Mascota_Genero CHECK (genero IN ('Macho', 'Hembra'))
);


CREATE TABLE agenda
(
  id_agenda INT IDENTITY(1,1) NOT NULL,
  fecha_inicio DATETIME NOT NULL CONSTRAINT DF_Agenda_FechaInicio DEFAULT GETDATE(),
  fecha_fin DATETIME NOT NULL,
  agenda_estado VARCHAR(20) NOT NULL CONSTRAINT DF_Agenda_Estado DEFAULT 'Pendiente',
  descripcion_agenda VARCHAR(250),
  id_mascota INT NOT NULL,
  id_usuario INT NOT NULL,
  activo BIT NOT NULL   CONSTRAINT DF_Agenda_Activo DEFAULT 1,
  CONSTRAINT PK_Agenda PRIMARY KEY (id_agenda),
  CONSTRAINT FK_Agenda_Mascota FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
  CONSTRAINT CK_Agenda_Estado CHECK (agenda_estado IN ('Pendiente', 'Finalizada', 'Cancelada')),
  CONSTRAINT FK_Agenda_Usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT CK_Agenda_Fechas CHECK (fecha_fin > fecha_inicio)
);


CREATE TABLE especialidad
(
  id_especialidad INT IDENTITY(1,1) NOT NULL,
  nombre_especialidad VARCHAR(100) NOT NULL,
  activo BIT NOT NULL   CONSTRAINT DF_Especialidad_Activo DEFAULT 1,
  CONSTRAINT PK_Especialidad PRIMARY KEY (id_especialidad),
  CONSTRAINT UQ_Especialidad_Nombre UNIQUE (nombre_especialidad)
);


CREATE TABLE vacuna
(
  id_vacuna INT IDENTITY(1,1) NOT NULL,
  nombre_vacuna VARCHAR(100) NOT NULL,
  activo BIT NOT NULL   CONSTRAINT DF_Vacuna_Activo DEFAULT 1,
  CONSTRAINT PK_Vacuna PRIMARY KEY (id_vacuna),
  CONSTRAINT UQ_Vacuna_Nombre UNIQUE (nombre_vacuna)
);


CREATE TABLE veterinario
(
  id_veterinario INT IDENTITY(1,1) NOT NULL,
  matricula VARCHAR(50) NOT NULL,
  id_especialidad INT NOT NULL,
  id_usuario INT NOT NULL,
  activo BIT NOT NULL  CONSTRAINT DF_Veterinario_Activo DEFAULT 1,
  CONSTRAINT PK_Veterinario PRIMARY KEY (id_veterinario),
  CONSTRAINT FK_Veterinario_Especialidad FOREIGN KEY (id_especialidad) REFERENCES especialidad(id_especialidad),
  CONSTRAINT FK_Veterinario_Usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT UQ_Veterinario_Matricula UNIQUE (matricula)
);


CREATE TABLE consulta
(
  id_consulta INT IDENTITY(1,1) NOT NULL,
  fecha_consulta DATE NOT NULL CONSTRAINT DF_Consulta_Fecha DEFAULT GETDATE(),
  motivo VARCHAR(250) NOT NULL,
  diagnostico VARCHAR(250) NOT NULL,
  tratamiento VARCHAR(250) NOT NULL,
  proximo_control DATE,
  url_archivo VARCHAR(250),
  sintomas VARCHAR(250) NOT NULL,
  id_mascota INT NOT NULL,
  id_veterinario INT NOT NULL,
  activo BIT NOT NULL CONSTRAINT DF_Consulta_Activo DEFAULT 1,
  CONSTRAINT PK_Consulta PRIMARY KEY (id_consulta),
  CONSTRAINT FK_Consulta_Mascota FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota),
  CONSTRAINT FK_Consulta_Veterinario FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario),
  CONSTRAINT CK_Consulta_Fechas CHECK (proximo_control IS NULL OR proximo_control >= fecha_consulta)
);


CREATE TABLE modulo
(
  id_modulo INT IDENTITY(1,1) NOT NULL,
  nombre_modulo VARCHAR(100) NOT NULL,
  CONSTRAINT PK_Modulo PRIMARY KEY (id_modulo),
  CONSTRAINT UQ_Modulo_Nombre UNIQUE (nombre_modulo)
);


CREATE TABLE permiso
(
  id_permiso INT IDENTITY(1,1) NOT NULL,
  descripcion VARCHAR(100) NOT NULL,
  id_modulo INT NOT NULL,
  CONSTRAINT PK_Permiso PRIMARY KEY (id_permiso),
  CONSTRAINT FK_Permiso_Modulo FOREIGN KEY (id_modulo) REFERENCES modulo(id_modulo),
  CONSTRAINT UQ_Permiso_Descripcion UNIQUE (descripcion)
);


CREATE TABLE rol_permiso
(
  id_permiso INT NOT NULL,
  id_rol INT NOT NULL,
  CONSTRAINT PK_RolPermiso PRIMARY KEY (id_permiso, id_rol),
  CONSTRAINT FK_RolPermiso_Permiso FOREIGN KEY (id_permiso) REFERENCES permiso(id_permiso),
  CONSTRAINT FK_RolPermiso_Rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);


CREATE TABLE vacunacion
(
  id_vacunacion INT IDENTITY(1,1) NOT NULL,
  laboratorio VARCHAR(100) NOT NULL,
  fecha_vacunacion DATE NOT NULL CONSTRAINT DF_Fecha_Vacunacion DEFAULT GETDATE(),
  lote VARCHAR(50) NOT NULL,
  observaciones VARCHAR(250),
  proxima_vacunacion DATE NOT NULL CONSTRAINT DF_ProximaVacunacion DEFAULT DATEADD(YEAR,1,GETDATE()),
  id_vacuna INT NOT NULL,
  id_veterinario INT NOT NULL,
  id_mascota INT NOT NULL,
  activo BIT NOT NULL CONSTRAINT DF_Vacunacion_Activo DEFAULT 1,
  CONSTRAINT PK_Vacunacion PRIMARY KEY (id_vacunacion),
  CONSTRAINT FK_Vacunacion_Vacuna FOREIGN KEY (id_vacuna) REFERENCES vacuna(id_vacuna),
  CONSTRAINT FK_Vacunacion_Veterinario FOREIGN KEY (id_veterinario) REFERENCES veterinario(id_veterinario),
  CONSTRAINT FK_Vacunacion_Mascota FOREIGN KEY (id_mascota) REFERENCES mascota(id_mascota)
);
