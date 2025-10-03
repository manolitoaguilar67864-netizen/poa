
IF DB_ID('Universidad') IS NOT NULL
BEGIN
    ALTER DATABASE Universidad SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Universidad;
END
GO

CREATE DATABASE Universidad;
GO
USE Universidad;
GO
PRINT '🔹 Creando tablas...';

CREATE TABLE Carreras (
    IdCarrera INT IDENTITY PRIMARY KEY,
    Nombre NVARCHAR(100),
    Facultad NVARCHAR(100),
    DuracionAnios INT
);

CREATE TABLE Estudiantes (
    IdEstudiante INT IDENTITY PRIMARY KEY,
    Nombre NVARCHAR(100),
    CI NVARCHAR(20),
    FechaNacimiento DATE,
    Direccion NVARCHAR(200),
    Correo NVARCHAR(100),
    Telefono NVARCHAR(20),
    EstadoAcademico NVARCHAR(20),
    IdCarrera INT FOREIGN KEY REFERENCES Carreras(IdCarrera)
);

CREATE TABLE Docentes (
    IdDocente INT IDENTITY PRIMARY KEY,
    Nombre NVARCHAR(100),
    CI NVARCHAR(20),
    FormacionAcademica NVARCHAR(100),
    Especialidad NVARCHAR(100),
    Correo NVARCHAR(100),
    Telefono NVARCHAR(20)
);

CREATE TABLE Materias (
    IdMateria INT IDENTITY PRIMARY KEY,
    Nombre NVARCHAR(100),
    Creditos INT,
    IdCarrera INT FOREIGN KEY REFERENCES Carreras(IdCarrera)
);

CREATE TABLE Grupos (
    IdGrupo INT IDENTITY PRIMARY KEY,
    IdMateria INT FOREIGN KEY REFERENCES Materias(IdMateria),
    IdDocente INT FOREIGN KEY REFERENCES Docentes(IdDocente),
    Semestre NVARCHAR(10),
    Gestion INT
);

CREATE TABLE Inscripciones (
    IdInscripcion INT IDENTITY PRIMARY KEY,
    IdEstudiante INT FOREIGN KEY REFERENCES Estudiantes(IdEstudiante),
    IdGrupo INT FOREIGN KEY REFERENCES Grupos(IdGrupo),
    Estado NVARCHAR(20)
);

CREATE TABLE Asistencias (
    IdAsistencia INT IDENTITY PRIMARY KEY,
    IdInscripcion INT FOREIGN KEY REFERENCES Inscripciones(IdInscripcion),
    Fecha DATE,
    Estado NVARCHAR(20)
);

CREATE TABLE Calificaciones (
    IdCalificacion INT IDENTITY PRIMARY KEY,
    IdInscripcion INT FOREIGN KEY REFERENCES Inscripciones(IdInscripcion),
    TipoEvaluacion NVARCHAR(50),
    Nota DECIMAL(5,2),
    Estado NVARCHAR(20)
);

CREATE TABLE Becas (
    IdBeca INT IDENTITY PRIMARY KEY,
    Tipo NVARCHAR(50),
    Monto DECIMAL(10,2),
    Requisitos NVARCHAR(200)
);

CREATE TABLE BecasEstudiantes (
    IdBecaEstudiante INT IDENTITY PRIMARY KEY,
    IdBeca INT FOREIGN KEY REFERENCES Becas(IdBeca),
    IdEstudiante INT FOREIGN KEY REFERENCES Estudiantes(IdEstudiante),
    FechaAsignacion DATE
);


PRINT '🔹 Insertando datos iniciales...';

INSERT INTO Docentes (Nombre, CI, FormacionAcademica, Especialidad, Correo, Telefono)
VALUES 
('Juan Pérez', '12345678', 'Ing. de Sistemas', 'Bases de Datos', 'juan.perez@email.com', '70000001'),
('Laura Torres', '87654321', 'Lic. en Administración', 'Administración General', 'laura.torres@email.com', '70000002');

-- =========================================================
-- 03b DATOS EXTRA
-- =========================================================
PRINT '🔹 Insertando datos extra...';

INSERT INTO Carreras (Nombre, Facultad, DuracionAnios)
VALUES 
('Ingeniería de Sistemas', 'Facultad de Ingeniería', 5),
('Administración de Empresas', 'Facultad de Ciencias Económicas', 4);

INSERT INTO Materias (Nombre, Creditos, IdCarrera)
VALUES 
('Programación I', 5, 1),
('Base de Datos', 4, 1),
('Contabilidad General', 4, 2),
('Administración I', 3, 2);

INSERT INTO Grupos (IdMateria, IdDocente, Semestre, Gestion)
VALUES 
(1, 1, '1-2025', 2025),
(2, 1, '1-2025', 2025),
(3, 2, '1-2025', 2025),
(4, 2, '1-2025', 2025);

INSERT INTO Estudiantes (Nombre, CI, FechaNacimiento, Direccion, Correo, Telefono, EstadoAcademico, IdCarrera)
VALUES
('Carlos López', '11122233', '2001-03-10', 'Av. Sucre 101', 'carlos.lopez@email.com', '70011122', 'Activo', 1),
('María Gómez', '44455566', '2000-07-15', 'Av. Bolívar 202', 'maria.gomez@email.com', '70033344', 'Activo', 2);

INSERT INTO Inscripciones (IdEstudiante, IdGrupo, Estado)
VALUES 
(1, 1, 'Inscrito'),
(1, 2, 'Inscrito'),
(2, 3, 'Inscrito'),
(2, 4, 'Inscrito');

INSERT INTO Asistencias (IdInscripcion, Fecha, Estado)
VALUES
(1, '2025-08-01', 'Presente'),
(1, '2025-08-02', 'Ausente'),
(2, '2025-08-01', 'Presente'),
(3, '2025-08-01', 'Presente'),
(4, '2025-08-01', 'Presente');

INSERT INTO Calificaciones (IdInscripcion, TipoEvaluacion, Nota, Estado)
VALUES
(1, 'Parcial 1', 80, 'Aprobado'),
(1, 'Parcial 2', 70, 'Aprobado'),
(2, 'Parcial 1', 60, 'Aprobado'),
(3, 'Parcial 1', 45, 'Reprobado'),
(4, 'Parcial 1', 90, 'Aprobado');

INSERT INTO Becas (Tipo, Monto, Requisitos)
VALUES
('Excelencia Académica', 1000.00, 'Promedio mayor a 80'),
('Apoyo Económico', 500.00, 'Situación socioeconómica vulnerable');

INSERT INTO BecasEstudiantes (IdBeca, IdEstudiante, FechaAsignacion)
VALUES
(1, 1, '2025-08-05'),
(2, 2, '2025-08-05');

-- =========================================================
-- 04 PROCEDIMIENTOS
-- =========================================================
PRINT '🔹 Creando procedimientos...';

CREATE PROCEDURE sp_InsertarEstudiante
    @Nombre NVARCHAR(100),
    @CI NVARCHAR(20),
    @FechaNacimiento DATE,
    @Direccion NVARCHAR(200),
    @Correo NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @EstadoAcademico NVARCHAR(20),
    @IdCarrera INT
AS
BEGIN
    INSERT INTO Estudiantes (Nombre, CI, FechaNacimiento, Direccion, Correo, Telefono, EstadoAcademico, IdCarrera)
    VALUES (@Nombre, @CI, @FechaNacimiento, @Direccion, @Correo, @Telefono, @EstadoAcademico, @IdCarrera);
END;
GO

CREATE PROCEDURE sp_InsertarDocente
    @Nombre NVARCHAR(100),
    @CI NVARCHAR(20),
    @FormacionAcademica NVARCHAR(100),
    @Especialidad NVARCHAR(100),
    @Correo NVARCHAR(100),
    @Telefono NVARCHAR(20)
AS
BEGIN
    INSERT INTO Docentes (Nombre, CI, FormacionAcademica, Especialidad, Correo, Telefono)
    VALUES (@Nombre, @CI, @FormacionAcademica, @Especialidad, @Correo, @Telefono);
END;
GO

CREATE PROCEDURE sp_ActualizarEstudiante
    @IdEstudiante INT,
    @Direccion NVARCHAR(200),
    @Correo NVARCHAR(100),
    @Telefono NVARCHAR(20),
    @EstadoAcademico NVARCHAR(20)
AS
BEGIN
    UPDATE Estudiantes
    SET Direccion = @Direccion,
        Correo = @Correo,
        Telefono = @Telefono,
        EstadoAcademico = @EstadoAcademico
    WHERE IdEstudiante = @IdEstudiante;
END;
GO

CREATE PROCEDURE sp_EliminarEstudiante
    @IdEstudiante INT
AS
BEGIN
    DELETE FROM Estudiantes WHERE IdEstudiante = @IdEstudiante;
END;
GO

-- =========================================================
-- 05 FUNCIONES
-- =========================================================
PRINT '🔹 Creando funciones...';

CREATE FUNCTION fn_PromedioEstudiante (@IdEstudiante INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Promedio DECIMAL(5,2);
    SELECT @Promedio = AVG(Nota)
    FROM Calificaciones c
    INNER JOIN Inscripciones i ON c.IdInscripcion = i.IdInscripcion
    WHERE i.IdEstudiante = @IdEstudiante;
    RETURN @Promedio;
END;
GO

CREATE FUNCTION fn_CantidadMateriasPorCarrera (@IdCarrera INT)
RETURNS INT
AS
BEGIN
    DECLARE @Cantidad INT;
    SELECT @Cantidad = COUNT(*) FROM Materias WHERE IdCarrera = @IdCarrera;
    RETURN @Cantidad;
END;
GO

-- =========================================================
-- 06 TRIGGERS
-- =========================================================
PRINT '🔹 Creando triggers...';

CREATE TRIGGER trg_NoDuplicarInscripcion
ON Inscripciones
FOR INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Inscripciones i
        JOIN inserted ins ON i.IdEstudiante = ins.IdEstudiante AND i.IdGrupo = ins.IdGrupo
    )
    BEGIN
        RAISERROR('No se permite inscripción duplicada.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_ValidarNota
ON Calificaciones
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE Nota < 0 OR Nota > 100)
    BEGIN
        RAISERROR('La nota debe estar entre 0 y 100.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- =========================================================
-- 07 VISTAS
-- =========================================================
PRINT '🔹 Creando vistas...';

CREATE VIEW vw_EstudiantesCarrera AS
SELECT e.IdEstudiante, e.Nombre AS Estudiante, c.Nombre AS Carrera, c.Facultad
FROM Estudiantes e
JOIN Carreras c ON e.IdCarrera = c.IdCarrera;
GO

CREATE VIEW vw_AsistenciaEstudiantes AS
SELECT e.Nombre AS Estudiante, m.Nombre AS Materia, a.Fecha, a.Estado
FROM Asistencias a
JOIN Inscripciones i ON a.IdInscripcion = i.IdInscripcion
JOIN Estudiantes e ON i.IdEstudiante = e.IdEstudiante
JOIN Grupos g ON i.IdGrupo = g.IdGrupo
JOIN Materias m ON g.IdMateria = m.IdMateria;
GO

CREATE VIEW vw_CalificacionesEstudiantes AS
SELECT e.Nombre AS Estudiante, m.Nombre AS Materia, c.TipoEvaluacion, c.Nota, c.Estado
FROM Calificaciones c
JOIN Inscripciones i ON c.IdInscripcion = i.IdInscripcion
JOIN Estudiantes e ON i.IdEstudiante = e.IdEstudiante
JOIN Grupos g ON i.IdGrupo = g.IdGrupo
JOIN Materias m ON g.IdMateria = m.IdMateria;
GO

CREATE VIEW vw_BecasEstudiantes AS
SELECT e.Nombre AS Estudiante, b.Tipo AS Beca, b.Monto, be.FechaAsignacion
FROM BecasEstudiantes be
JOIN Estudiantes e ON be.IdEstudiante = e.IdEstudiante
JOIN Becas b ON be.IdBeca = b.IdBeca;
GO

-- =========================================================
-- 08 PRUEBAS
-- =========================================================
PRINT '========================================';
PRINT '   🔹 PRUEBAS DE CONSULTAS BÁSICAS';
PRINT '========================================';

SELECT * FROM Estudiantes;
SELECT * FROM Carreras;
SELECT * FROM Docentes;

SELECT e.Nombre AS Estudiante, c.Nombre AS Carrera
FROM Estudiantes e
JOIN Carreras c ON e.IdCarrera = c.IdCarrera;

PRINT '========================================';
PRINT '   🔹 PRUEBAS DE PROCEDIMIENTOS';
PRINT '========================================';

EXEC sp_InsertarEstudiante 
    @Nombre = 'Pedro Salinas',
    @CI = '33445566',
    @FechaNacimiento = '2002-01-15',
    @Direccion = 'Av. Libertad 100',
    @Correo = 'pedro.salinas@email.com',
    @Telefono = '78945612',
    @EstadoAcademico = 'Activo',
    @IdCarrera = 1;

EXEC sp_InsertarDocente 
    @Nombre = 'Ana Castillo',
    @CI = '99887766',
    @FormacionAcademica = 'Lic. en Física',
    @Especialidad = 'Física General',
    @Correo = 'ana.castillo@email.com',
    @Telefono = '71234567';

EXEC sp_ActualizarEstudiante 
    @IdEstudiante = 1,
    @Direccion = 'Nueva Dirección 123',
    @Correo = 'nuevo_correo@email.com',
    @Telefono = '70000000',
    @EstadoAcademico = 'Activo';

PRINT '========================================';
PRINT '   🔹 PRUEBAS DE FUNCIONES';
PRINT '========================================';

SELECT dbo.fn_PromedioEstudiante(1) AS Promedio_Estudiante1;
SELECT dbo.fn_CantidadMateriasPorCarrera(1) AS Materias_Sistemas;

PRINT '========================================';
PRINT '   🔹 PRUEBAS DE TRIGGERS';
PRINT '========================================';

BEGIN TRY
    INSERT INTO Inscripciones (IdEstudiante, IdGrupo, Estado)
    VALUES (1, 1, 'Inscrito');
    
    INSERT INTO Inscripciones (IdEstudiante, IdGrupo, Estado)
    VALUES (1, 1, 'Inscrito'); 
END TRY
BEGIN CATCH
    PRINT '⚠️ Trigger trg_NoDuplicarInscripcion evitó duplicado';
END CATCH;

BEGIN TRY
    INSERT INTO Calificaciones (IdInscripcion, TipoEvaluacion, Nota, Estado)
    VALUES (1, 'Parcial', 150, 'Aprobado');
END TRY
BEGIN CATCH
    PRINT '⚠️ Trigger trg_ValidarNota bloqueó nota inválida';
END CATCH;

PRINT '========================================';
PRINT '   🔹 PRUEBAS DE VISTAS';
PRINT '========================================';

SELECT * FROM vw_EstudiantesCarrera;
SELECT * FROM vw_AsistenciaEstudiantes;
SELECT * FROM vw_CalificacionesEstudiantes;
SELECT * FROM vw_BecasEstudiantes;
