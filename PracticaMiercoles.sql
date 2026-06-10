-- 1. CREACIÓN DE LA BASE DE DATOS
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'EmpresaSQL')
BEGIN 
    DROP DATABASE EmpresaSQL;
END
GO

CREATE DATABASE EmpresaSQL;
GO

USE EmpresaSQL;
GO

-- 2. CREACIÓN DE TABLAS MAESTRAS e INDEPENDIENTES
CREATE TABLE TDepartamento (
    nDepartamentoID INT IDENTITY(1,1) CONSTRAINT pk_nDepartamentoID PRIMARY KEY,
    cNombreDepartamento NVARCHAR(50) NOT NULL CONSTRAINT uk_cNombreDepartamento UNIQUE
);
GO

CREATE TABLE TCargo (
    nCargoID INT IDENTITY(1,1) CONSTRAINT pk_nCargoID PRIMARY KEY,
    cNombreCargo NVARCHAR(50) NOT NULL CONSTRAINT uk_cNombreCargo UNIQUE
);
GO

CREATE TABLE TProyecto (
    nProyectoID INT IDENTITY(1,1) CONSTRAINT pk_nProyectoID PRIMARY KEY,
    nombreProyecto NVARCHAR(60) NOT NULL,
    FechaInicio DATETIME NOT NULL,
    FechaFinalizacion DATETIME
);
GO

CREATE TABLE TSucursal (
    nSucursalID INT IDENTITY(1,1) CONSTRAINT pk_TSucursalID PRIMARY KEY,
    cNombreSucursal NVARCHAR(100) NOT NULL CONSTRAINT uk_cNombreSucursal UNIQUE,
    cCiudad NVARCHAR(50) NOT NULL,
    bActivo BIT CONSTRAINT df_TSucursal_bActivo DEFAULT 1
);
GO

CREATE TABLE TCliente (
    nClienteID INT IDENTITY(1,1) CONSTRAINT pk_TClienteID PRIMARY KEY,
    cNif NVARCHAR(15) NOT NULL CONSTRAINT uk_TCliente_cNif UNIQUE,
    cNombre NVARCHAR(50) NOT NULL,
    cApellido NVARCHAR(50) NOT NULL,
    cCorreo NVARCHAR(100) CONSTRAINT uk_TCliente_cCorreo UNIQUE,
    cTelefono NVARCHAR(20),
    nEdad INT CONSTRAINT ck_TCliente_nEdad CHECK(nEdad >= 18),
    dFechaRegistro DATE CONSTRAINT df_TCliente_dFechaRegistro DEFAULT GETDATE()
);
GO

-- 3. CREACIÓN DE TABLAS DEPENDIENTES (Estructura final consolidada)
CREATE TABLE TEmpleado (
    nEmpleadoID INT IDENTITY(1,1) CONSTRAINT pk_nEmpleadoID PRIMARY KEY,
    cNif NVARCHAR(15) NOT NULL CONSTRAINT uk_cNif UNIQUE,
    cNombre NVARCHAR(100),
    cApellido NVARCHAR(100),
    nDepartamentoID INT,
    nCargoID INT,
    dFechaContratacion DATETIME CONSTRAINT df_dFechaContratacion DEFAULT GETDATE(),
    nSalario INT CONSTRAINT ck_nSalario CHECK(nSalario > 300),
    cEmail NVARCHAR(60) CONSTRAINT uk_TEmpleado_cEmail UNIQUE,
    cTelefono NVARCHAR(8),
    CDireccion NVARCHAR(70),
    nEdad INT CONSTRAINT ck_TEmpleado_nEdad CHECK (nEdad BETWEEN 18 AND 65),
    cCorreo NVARCHAR(100) CONSTRAINT uk_TEmpleado_cCorreo UNIQUE,
    bActivo BIT CONSTRAINT df_TEmpleado_bActivo DEFAULT 1,
    telefono VARCHAR(20),
    cGenero CHAR(1) CONSTRAINT ck_TEmpleado_cGenero CHECK (cGenero IN ('M', 'F')),
    dFechaNacimiento DATE,

    CONSTRAINT fk_TEmpleado_TDepartamento FOREIGN KEY (nDepartamentoID) REFERENCES TDepartamento(nDepartamentoID),
    CONSTRAINT fk_TEmpleado_TCargo FOREIGN KEY (nCargoID) REFERENCES TCargo(nCargoID)
);
GO

CREATE TABLE TEmpleadoProyecto (
    nEmpleadoID INT,
    nProyectoID INT,
    CONSTRAINT pk_TEmpleadoProyecto PRIMARY KEY (nEmpleadoID, nProyectoID),
    CONSTRAINT fk_TEmpleadoProyecto_Empleado FOREIGN KEY (nEmpleadoID) REFERENCES TEmpleado(nEmpleadoID),
    CONSTRAINT fk_TEmpleadoProyecto_Proyecto FOREIGN KEY (nProyectoID) REFERENCES TProyecto(nProyectoID)
);
GO

CREATE TABLE TVenta (
    nVentaID INT IDENTITY(1,1) CONSTRAINT pk_nVentaID PRIMARY KEY,
    nClienteID INT,
    nSucursalID INT,
    dFechaVenta DATETIME CONSTRAINT df_TVenta_dFechaVenta DEFAULT GETDATE(),
    nMontoTotal INT CONSTRAINT ck_TVenta_nMontoTotal CHECK(nMontoTotal > 0),
    CONSTRAINT fk_TVenta_TCliente FOREIGN KEY (nClienteID) REFERENCES TCliente(nClienteID),
    CONSTRAINT fk_TVenta_TSucursal FOREIGN KEY (nSucursalID) REFERENCES TSucursal(nSucursalID)
);
GO


-- 4. INSERCIÓN DE DATOS INICIALES
INSERT INTO TDepartamento (cNombreDepartamento) VALUES 
('Recursos Humanos'), ('Tecnología'), ('Finanzas'), ('Operaciones'), ('Mercadeo');

INSERT INTO TCargo (cNombreCargo) VALUES 
('Gerente'), ('Analista'), ('Desarrollador'), ('Coordinador'), ('Asistente');

INSERT INTO TEmpleado (cNif, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cCorreo, cGenero, dFechaNacimiento) VALUES 
('1111', 'Carlos', 'Mendoza', 2, 3, 1200, 35, 'carlos.mendoza@empresa.com', 'M', '1991-04-12'),
('2222', 'Ana', 'Silva', 1, 1, 2500, 33, 'ana.silva@empresa.com', 'F', '1993-08-25'),
('3333', 'Jorge', 'Reyes', 3, 2, 950, 37, 'jorge.reyes@empresa.com', 'M', '1988-11-05'),
('4444', 'Elena', 'Gómez', 2, 3, 1100, 30, 'elena.gomez@empresa.com', 'F', '1995-02-14'),
('5555', 'Luis', 'Torres', 4, 4, 800, 40, 'luis.torres@empresa.com', 'M', '1985-06-30'),
('6666', 'Sofía', 'Castro', 5, 2, 900, 32, 'sofia.castro@empresa.com', 'F', '1993-10-18'),
('7777', 'Pedro', 'Martínez', 3, 1, 2300, 45, 'pedro.martinez@empresa.com', 'M', '1980-03-22'),
('8888', 'Lucía', 'Morales', 2, 5, 500, 31, 'lucia.morales@empresa.com', 'F', '1994-12-01'),
('9999', 'Diego', 'Ortiz', 4, 2, 850, 38, 'diego.ortiz@empresa.com', 'M', '1987-07-09'),
('0000', 'María', 'Espinoza', 1, 5, 450, 34, 'maria.espinoza@empresa.com', 'F', '1991-09-15');

INSERT INTO TProyecto (nombreProyecto, FechaInicio, FechaFinalizacion) VALUES 
('Migración en la Nube', '2026-01-15', '2026-06-30'),
('Reestructuración Salarial', '2026-03-01', null),
('Campaña Expansión 2026', '2026-05-01', '2026-12-31');

INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES 
(1, 1), (4, 1), (2, 2), (6, 3);

INSERT INTO TEmpleado (cNif, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cCorreo, cGenero, dFechaNacimiento) VALUES 
('1234', 'Roberto', 'Briones', 2, 3, 1300, 29, 'roberto.briones@empresa.com', 'M', '1997-01-20'),
('5678', 'Laura', 'Chávez', 5, 4, 850, 27, 'laura.chavez@empresa.com', 'F', '1998-11-12'),
('9012', 'Ricardo', 'Gutiérrez', 4, 2, 900, 42, 'ricardo.gutierrez@empresa.com', 'M', '1984-05-05');

INSERT INTO TDepartamento (cNombreDepartamento) VALUES 
('Logística'), ('Auditoría Interna'), ('Seguridad');

-- Corregido: Se cambió de -500 a 350 para cumplir el CONSTRAINT ck_nSalario (>300)
INSERT INTO TEmpleado (cNif, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cCorreo, cGenero, dFechaNacimiento) VALUES 
('0001', 'Frustrado', 'Error', 2, 3, 350, 25, 'error.salario@empresa.com', 'M', '2001-01-01');
GO

INSERT INTO TSucursal (cNombreSucursal, cCiudad) VALUES 
('Sucursal Central', 'Managua'),
('Sucursal Norte', 'Estelí'),
('Sucursal Sur', 'Rivas');

INSERT INTO TCliente (cNif, cNombre, cApellido, cCorreo, cTelefono, nEdad) VALUES
('C001', 'Juan', 'Pérez', 'juan.perez@email.com', '88881111', 25),
('C002', 'María', 'Gómez', 'maria.gomez@email.com', '88882222', 30),
('C003', 'Pedro', 'Martínez', 'pedro.m@email.com', '88883333', 45),
('C004', 'Ana', 'Rodríguez', 'ana.rod@email.com', '88884444', 22),
('C005', 'Luis', 'Sánchez', 'luis.s@email.com', '88885555', 35),
('C006', 'Laura', 'Ramírez', 'laura.r@email.com', '88886666', 28),
('C007', 'Carlos', 'Flores', 'carlos.f@email.com', '88887777', 50),
('C008', 'Elena', 'Torres', 'elena.t@email.com', '88888888', 31),
('C009', 'Jorge', 'Díaz', 'jorge.d@email.com', '88889999', 40),
('C010', 'Sofía', 'Vargas', 'sofia.v@email.com', '88880000', 27),
('C011', 'Diego', 'Castillo', 'diego.c@email.com', '77771111', 33),
('C012', 'Lucía', 'Morales', 'lucia.m@email.com', '77772222', 29),
('C013', 'Roberto', 'Ríos', 'roberto.r@email.com', '77773333', 42),
('C014', 'Carmen', 'Ortiz', 'carmen.o@email.com', '77774444', 36),
('C015', 'Manuel', 'Mendoza', 'manuel.m@email.com', '77775555', 48),
('C016', 'Adriana', 'Silva', 'adriana.s@email.com', '77776666', 24),
('C017', 'Francisco', 'Reyes', 'fran.r@email.com', '77777777', 55),
('C018', 'Gabriela', 'Espinoza', 'gaby.e@email.com', '77778888', 26),
('C019', 'Ricardo', 'Chávez', 'ricardo.c@email.com', '77779999', 38),
('C020', 'Patricia', 'Herrera', 'patty.h@email.com', '77770000', 44);

INSERT INTO TVenta (nClienteID, nSucursalID, dFechaVenta, nMontoTotal) VALUES
(1, 1, '2026-01-05', 150), (2, 1, '2026-01-06', 200), (3, 2, '2026-01-10', 350), (4, 3, '2026-01-12', 90), (5, 1, '2026-01-15', 500),
(6, 2, '2026-01-20', 120), (7, 3, '2026-01-22', 750), (8, 1, '2026-01-25', 300), (9, 2, '2026-02-02', 450), (10, 3, '2026-02-05', 180),
(11, 1, '2026-02-08', 250), (12, 2, '2026-02-12', 600), (13, 3, '2026-02-15', 95), (14, 1, '2026-02-18', 400), (15, 2, '2026-02-22', 110),
(16, 3, '2026-02-25', 80), (17, 1, '2026-03-01', 900), (18, 2, '2026-03-04', 130), (1, 3, '2026-03-07', 220), (2, 1, '2026-03-10', 310),
(3, 2, '2026-03-14', 420), (4, 3, '2026-03-18', 150), (5, 1, '2026-03-22', 620), (6, 2, '2026-03-25', 175), (7, 3, '2026-04-01', 800),
(8, 1, '2026-04-03', 210), (9, 2, '2026-04-06', 530), (10, 3, '2026-04-10', 140), (11, 1, '2026-04-14', 330), (12, 2, '2026-04-18', 710),
(13, 3, '2026-04-22', 115), (14, 1, '2026-04-25', 490), (15, 2, '2026-05-02', 260), (16, 3, '2026-05-05', 95), (17, 1, '2026-05-09', 1050),
(18, 2, '2026-05-12', 340), (1, 3, '2026-05-15', 180), (2, 1, '2026-05-19', 290), (3, 2, '2026-05-22', 510), (4, 3, '2026-05-26', 125),
(5, 1, '2026-06-01', 640), (6, 2, '2026-06-03', 215), (7, 3, '2026-06-05', 890), (8, 1, '2026-06-07', 410), (9, 2, '2026-06-08', 600),
(10, 3, '2026-06-09', 320), (11, 1, '2026-06-10', 430), (12, 2, '2026-06-10', 750), (13, 3, '2026-06-10', 200), (14, 1, '2026-06-10', 550);
GO


-- 5. OPERACIONES DE ACTUALIZACIÓN (UPDATES)
UPDATE TEmpleado SET nSalario = nSalario * 1.10;
UPDATE TEmpleado SET nSalario = nSalario * 1.20 WHERE nDepartamentoID = 2;
UPDATE TEmpleado SET cCorreo = 'carlos.m_nuevo@empresa.com' WHERE nEmpleadoID = 1;
UPDATE TEmpleado SET nCargoID = 1 WHERE nEmpleadoID = 3;
UPDATE TEmpleado SET nDepartamentoID = 3 WHERE nEmpleadoID IN (5, 6);
UPDATE TEmpleado SET bActivo = 0 WHERE nSalario < 500;
UPDATE TProyecto SET FechaFinalizacion = '2026-08-15' WHERE nProyectoID = 2;
UPDATE TVenta SET nMontoTotal = nMontoTotal * 1.10 WHERE nSucursalID = 1;
GO

INSERT INTO TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES (3, 3);
GO


-- 6. OPERACIONES DE ELIMINACIÓN (DELETES)
DELETE FROM TEmpleadoProyecto WHERE nEmpleadoID = (SELECT nEmpleadoID FROM TEmpleado WHERE cNif = '1111');
DELETE FROM TEmpleado WHERE cNif = '1111';

DELETE FROM TEmpleadoProyecto WHERE nEmpleadoID IN (SELECT nEmpleadoID FROM TEmpleado WHERE bActivo = 0);
DELETE FROM TEmpleado WHERE bActivo = 0;

DELETE FROM TEmpleadoProyecto WHERE nProyectoID = 2;
DELETE FROM TProyecto WHERE nProyectoID = 2;

DELETE FROM TEmpleadoProyecto WHERE nEmpleadoID = 4;

DELETE FROM TDepartamento WHERE nDepartamentoID NOT IN (
    SELECT DISTINCT nDepartamentoID FROM TEmpleado WHERE nDepartamentoID IS NOT NULL
);
DELETE FROM TCliente WHERE nClienteID NOT IN (SELECT DISTINCT nClienteID FROM TVenta);
GO


-- 7. CONSULTAS DE SELECCIÓN (SELECTS)
SELECT * FROM TEmpleado ORDER BY cApellido ASC;
SELECT * FROM TEmpleado WHERE nSalario > 1000;
SELECT * FROM TEmpleado WHERE bActivo = 1;
SELECT * FROM TEmpleado WHERE YEAR(dFechaContratacion) = YEAR(GETDATE());

SELECT e.*, d.cNombreDepartamento 
FROM TEmpleado e
INNER JOIN TDepartamento d ON e.nDepartamentoID = d.nDepartamentoID;

SELECT e.*, c.cNombreCargo 
FROM TEmpleado e
INNER JOIN TCargo c ON e.nCargoID = c.nCargoID;

SELECT DISTINCT e.* FROM TEmpleado e
INNER JOIN TEmpleadoProyecto ep ON e.nEmpleadoID = ep.nEmpleadoID;

SELECT d.cNombreDepartamento, COUNT(e.nEmpleadoID) AS CantidadEmpleados
FROM TDepartamento d
LEFT JOIN TEmpleado e ON d.nDepartamentoID = e.nDepartamentoID
GROUP BY d.cNombreDepartamento;

SELECT d.cNombreDepartamento, AVG(e.nSalario) AS SalarioPromedio
FROM TDepartamento d
INNER JOIN TEmpleado e ON d.nDepartamentoID = e.nDepartamentoID
GROUP BY d.cNombreDepartamento;

SELECT d.cNombreDepartamento, MAX(e.nSalario) AS SalarioMaximo, MIN(e.nSalario) AS SalarioMinimo
FROM TDepartamento d
INNER JOIN TEmpleado e ON d.nDepartamentoID = e.nDepartamentoID
GROUP BY d.cNombreDepartamento;

SELECT p.nombreProyecto, COUNT(ep.nEmpleadoID) AS CantidadEmpleados
FROM TProyecto p
INNER JOIN TEmpleadoProyecto ep ON p.nProyectoID = ep.nProyectoID
GROUP BY p.nombreProyecto
HAVING COUNT(ep.nEmpleadoID) > 2;

SELECT * FROM TEmpleado WHERE cApellido LIKE 'G%';
SELECT * FROM TEmpleado ORDER BY nSalario DESC;
SELECT TOP 3 * FROM TEmpleado ORDER BY nSalario DESC;
SELECT * FROM TEmpleado WHERE nEdad BETWEEN 25 AND 40;
SELECT COUNT(*) AS TotalActivos FROM TEmpleado WHERE bActivo = 1;
SELECT COUNT(*) AS TotalProyectos FROM TProyecto;

SELECT TOP 5 c.nClienteID, c.cNombre, c.cApellido, SUM(v.nMontoTotal) AS TotalComprado
FROM TCliente c
INNER JOIN TVenta v ON c.nClienteID = v.nClienteID
GROUP BY c.nClienteID, c.cNombre, c.cApellido
ORDER BY TotalComprado DESC;

SELECT YEAR(dFechaVenta) AS Anio, MONTH(dFechaVenta) AS Mes, SUM(nMontoTotal) AS TotalVentas, COUNT(nVentaID) AS CantidadVentas
FROM TVenta
GROUP BY YEAR(dFechaVenta), MONTH(dFechaVenta)
ORDER BY Anio DESC, Mes DESC;

SELECT c.nClienteID, c.cNombre, c.cApellido, AVG(v.nMontoTotal) AS PromedioVenta
FROM TCliente c
INNER JOIN TVenta v ON c.nClienteID = v.nClienteID
GROUP BY c.nClienteID, c.cNombre, c.cApellido;

SELECT v.nVentaID, v.dFechaVenta, v.nMontoTotal, c.cNombre + ' ' + c.cApellido AS Cliente, s.cNombreSucursal AS Sucursal
FROM TVenta v
INNER JOIN TCliente c ON v.nClienteID = c.nClienteID
INNER JOIN TSucursal s ON v.nSucursalID = s.nSucursalID;
GO

--admin
ALTER TABLE TEmpleado 
DROP CONSTRAINT ck_TEmpleado_nEdad;
GO

ALTER TABLE TEmpleado 
DROP CONSTRAINT uk_TEmpleado_cCorreo;
GO

ALTER TABLE TEmpleado 
ADD CONSTRAINT ck_TEmpleado_nEdad CHECK (nEdad BETWEEN 18 AND 65);

ALTER TABLE TEmpleado 
ADD CONSTRAINT uk_TEmpleado_cCorreo UNIQUE (cCorreo);
GO



DROP TABLE TEmpleadoProyecto;
GO

DROP TABLE TProyecto;
GO

DROP TABLE TEmpleado;
GO

DROP TABLE TCargo;
GO

DROP TABLE TDepartamento;
GO

DROP TABLE TSucursal;
GO

--desafios

CREATE TABLE TCliente(
    nClienteID INT IDENTITY(1,1) CONSTRAINT pk_TClienteID PRIMARY KEY,
    cNif NVARCHAR(15) NOT NULL CONSTRAINT uk_TCliente_cNif UNIQUE,
    cNombre NVARCHAR(50) NOT NULL,
    cApellido NVARCHAR(50) NOT NULL,
    cCorreo NVARCHAR(100) CONSTRAINT uk_TCliente_cCorreo UNIQUE,
    cTelefono NVARCHAR(20),
    nEdad INT CONSTRAINT ck_TCliente_nEdad CHECK(nEdad >= 18),
    dFechaRegistro DATE CONSTRAINT df_TCliente_dFechaRegistro DEFAULT GETDATE()
);
GO

CREATE TABLE TVenta(
    nVentaID INT IDENTITY(1,1) CONSTRAINT pk_nVentaID PRIMARY KEY,
    nClienteID INT,
    nSucursalID INT,
    dFechaVenta DATETIME CONSTRAINT df_TVenta_dFechaVenta DEFAULT GETDATE(),
    nMontoTotal INT CONSTRAINT ck_TVenta_nMontoTotal CHECK(nMontoTotal > 0),
    CONSTRAINT fk_TVenta_TCliente FOREIGN KEY (nClienteID) REFERENCES TCliente(nClienteID),
    CONSTRAINT fk_TVenta_TSucursal FOREIGN KEY (nSucursalID) REFERENCES TSucursal(nSucursalID)
);
GO

INSERT INTO TCliente (cNif, cNombre, cApellido, cCorreo, cTelefono, nEdad) VALUES
('C001', 'Juan', 'Pérez', 'juan.perez@email.com', '88881111', 25),
('C002', 'María', 'Gómez', 'maria.gomez@email.com', '88882222', 30),
('C003', 'Pedro', 'Martínez', 'pedro.m@email.com', '88883333', 45),
('C004', 'Ana', 'Rodríguez', 'ana.rod@email.com', '88884444', 22),
('C005', 'Luis', 'Sánchez', 'luis.s@email.com', '88885555', 35),
('C006', 'Laura', 'Ramírez', 'laura.r@email.com', '88886666', 28),
('C007', 'Carlos', 'Flores', 'carlos.f@email.com', '88887777', 50),
('C008', 'Elena', 'Torres', 'elena.t@email.com', '88888888', 31),
('C009', 'Jorge', 'Díaz', 'jorge.d@email.com', '88889999', 40),
('C010', 'Sofía', 'Vargas', 'sofia.v@email.com', '88880000', 27),
('C011', 'Diego', 'Castillo', 'diego.c@email.com', '77771111', 33),
('C012', 'Lucía', 'Morales', 'lucia.m@email.com', '77772222', 29),
('C013', 'Roberto', 'Ríos', 'roberto.r@email.com', '77773333', 42),
('C014', 'Carmen', 'Ortiz', 'carmen.o@email.com', '77774444', 36),
('C015', 'Manuel', 'Mendoza', 'manuel.m@email.com', '77775555', 48),
('C016', 'Adriana', 'Silva', 'adriana.s@email.com', '77776666', 24),
('C017', 'Francisco', 'Reyes', 'fran.r@email.com', '77777777', 55),
('C018', 'Gabriela', 'Espinoza', 'gaby.e@email.com', '77778888', 26),
('C019', 'Ricardo', 'Chávez', 'ricardo.c@email.com', '77779999', 38),
('C020', 'Patricia', 'Herrera', 'patty.h@email.com', '77770000', 44);
GO

INSERT INTO TVenta (nClienteID, nSucursalID, dFechaVenta, nMontoTotal) VALUES
(1, 1, '2026-01-05', 150), (2, 1, '2026-01-06', 200), (3, 2, '2026-01-10', 350), (4, 3, '2026-01-12', 90), (5, 1, '2026-01-15', 500),
(6, 2, '2026-01-20', 120), (7, 3, '2026-01-22', 750), (8, 1, '2026-01-25', 300), (9, 2, '2026-02-02', 450), (10, 3, '2026-02-05', 180),
(11, 1, '2026-02-08', 250), (12, 2, '2026-02-12', 600), (13, 3, '2026-02-15', 95), (14, 1, '2026-02-18', 400), (15, 2, '2026-02-22', 110),
(16, 3, '2026-02-25', 80), (17, 1, '2026-03-01', 900), (18, 2, '2026-03-04', 130), (1, 3, '2026-03-07', 220), (2, 1, '2026-03-10', 310),
(3, 2, '2026-03-14', 420), (4, 3, '2026-03-18', 150), (5, 1, '2026-03-22', 620), (6, 2, '2026-03-25', 175), (7, 3, '2026-04-01', 800),
(8, 1, '2026-04-03', 210), (9, 2, '2026-04-06', 530), (10, 3, '2026-04-10', 140), (11, 1, '2026-04-14', 330), (12, 2, '2026-04-18', 710),
(13, 3, '2026-04-22', 115), (14, 1, '2026-04-25', 490), (15, 2, '2026-05-02', 260), (16, 3, '2026-05-05', 95), (17, 1, '2026-05-09', 1050),
(18, 2, '2026-05-12', 340), (1, 3, '2026-05-15', 180), (2, 1, '2026-05-19', 290), (3, 2, '2026-05-22', 510), (4, 3, '2026-05-26', 125),
(5, 1, '2026-06-01', 640), (6, 2, '2026-06-03', 215), (7, 3, '2026-06-05', 890), (8, 1, '2026-06-07', 410), (9, 2, '2026-06-08', 600),
(10, 3, '2026-06-09', 320), (11, 1, '2026-06-10', 430), (12, 2, '2026-06-10', 750), (13, 3, '2026-06-10', 200), (14, 1, '2026-06-10', 550);
GO

UPDATE TVenta
SET nMontoTotal = nMontoTotal * 1.10
WHERE nSucursalID = 1;
GO

DELETE FROM TCliente
WHERE nClienteID NOT IN (SELECT DISTINCT nClienteID FROM TVenta);
GO

SELECT TOP 5 c.nClienteID, c.cNombre, c.cApellido, SUM(v.nMontoTotal) AS TotalComprado
FROM TCliente c
INNER JOIN TVenta v ON c.nClienteID = v.nClienteID
GROUP BY c.nClienteID, c.cNombre, c.cApellido
ORDER BY TotalComprado DESC;
GO

SELECT YEAR(dFechaVenta) AS Anio, MONTH(dFechaVenta) AS Mes, SUM(nMontoTotal) AS TotalVentas, COUNT(nVentaID) AS CantidadVentas
FROM TVenta
GROUP BY YEAR(dFechaVenta), MONTH(dFechaVenta)
ORDER BY Anio DESC, Mes DESC;
GO

SELECT c.nClienteID, c.cNombre, c.cApellido, AVG(v.nMontoTotal) AS PromedioVenta
FROM TCliente c
INNER JOIN TVenta v ON c.nClienteID = v.nClienteID
GROUP BY c.nClienteID, c.cNombre, c.cApellido;
GO

SELECT v.nVentaID, v.dFechaVenta, v.nMontoTotal, c.cNombre + ' ' + c.cApellido AS Cliente, s.cNombreSucursal AS Sucursal
FROM TVenta v
INNER JOIN TCliente c ON v.nClienteID = c.nClienteID
INNER JOIN TSucursal s ON v.nSucursalID = s.nSucursalID;
GO
