use master
go

if exists (select name from sys.databases where name = 'EmpresaSQL')
begin 
    drop database EmpresaSQL
end
go

create database EmpresaSQL
go

use EmpresaSQL
go

create table TDepartamento (
    nDepartamentoID int identity(1,1) constraint pk_nDepartamentoID primary key,
    cNombreDepartamento nvarchar(50) not null constraint uk_cNombreDepartamento unique
);
go

create table TCargo (
    nCargoID int identity(1,1) constraint pk_nCargoID primary key,
    cNombreCargo nvarchar(50) not null constraint uk_cNombreCargo unique
);
go

create table TProyecto (
    nProyectoID int identity(1,1) constraint pk_nProyectoID primary key,
    nombreProyecto nvarchar(60) not null,
    FechaInicio datetime not null,
    FechaFinalizacion datetime
);
go

create table TSucursal (
    nSucursalID int identity(1,1) constraint pk_TSucursalID primary key,
    cNombreSucursal nvarchar(100) not null constraint uk_cNombreSucursal unique,
    cCiudad nvarchar(50) not null,
    bActivo bit constraint df_TSucursal_bActivo default 1
);
go

create table TCliente (
    nClienteID int identity(1,1) constraint pk_TClienteID primary key,
    cNif nvarchar(15) not null constraint uk_TCliente_cNif unique,
    cNombre nvarchar(50) not null,
    cApellido nvarchar(50) not null,
    cCorreo nvarchar(100) constraint uk_TCliente_cCorreo unique,
    cTelefono nvarchar(20),
    nEdad int constraint ck_TCliente_nEdad check(nEdad >= 18),
    dFechaRegistro date constraint df_TCliente_dFechaRegistro default getdate()
);
go

create table TEmpleado (
    nEmpleadoID int identity(1,1) constraint pk_nEmpleadoID primary key,
    cNif nvarchar(15) not null constraint uk_cNif unique,
    cNombre nvarchar(100),
    cApellido nvarchar(100),
    nDepartamentoID int,
    nCargoID int,
    dFechaContratacion datetime constraint df_dFechaContratacion default getdate(),
    nSalario int constraint ck_nSalario check(nSalario > 300),
    cEmail nvarchar(60) null,
    cTelefono nvarchar(8),
    CDireccion nvarchar(70),
    nEdad int constraint ck_TEmpleado_nEdad check (nEdad between 18 and 65),
    cCorreo nvarchar(100) null,
    bActivo bit constraint df_TEmpleado_bActivo default 1,
    telefono varchar(20),
    cGenero char(1) constraint ck_TEmpleado_cGenero check (cGenero in ('M', 'F')),
    dFechaNacimiento date,

    constraint fk_TEmpleado_TDepartamento foreign key (nDepartamentoID) references TDepartamento(nDepartamentoID),
    constraint fk_TEmpleado_TCargo foreign key (nCargoID) references TCargo(nCargoID)
);
go

create table TEmpleadoProyecto (
    nEmpleadoID int,
    nProyectoID int,
    constraint pk_TEmpleadoProyecto primary key (nEmpleadoID, nProyectoID),
    constraint fk_TEmpleadoProyecto_Empleado foreign key (nEmpleadoID) references TEmpleado(nEmpleadoID),
    constraint fk_TEmpleadoProyecto_Proyecto foreign key (nProyectoID) references TProyecto(nProyectoID)
);
go

create table TVenta (
    nVentaID int identity(1,1) constraint pk_nVentaID primary key,
    nClienteID int,
    nSucursalID int,
    dFechaVenta datetime constraint df_TVenta_dFechaVenta default getdate(),
    nMontoTotal int constraint ck_TVenta_nMontoTotal check(nMontoTotal > 0),
    constraint fk_TVenta_TCliente foreign key (nClienteID) references TCliente(nClienteID),
    constraint fk_TVenta_TSucursal foreign key (nSucursalID) references TSucursal(nSucursalID)
);
go

insert into TDepartamento (cNombreDepartamento) values 
('Recursos Humanos'), ('Tecnología'), ('Finanzas'), ('Operaciones'), ('Mercadeo');

insert into TCargo (cNombreCargo) values 
('Gerente'), ('Analista'), ('Desarrollador'), ('Coordinador'), ('Asistente');

insert into TEmpleado (cNif, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cCorreo, cGenero, dFechaNacimiento) values 
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

insert into TProyecto (nombreProyecto, FechaInicio, FechaFinalizacion) values 
('Migración en la Nube', '2026-01-15', '2026-06-30'),
('Reestructuración Salarial', '2026-03-01', null),
('Campaña Expansión 2026', '2026-05-01', '2026-12-31');

insert into TEmpleadoProyecto (nEmpleadoID, nProyectoID) values 
(1, 1), (4, 1), (2, 2), (6, 3);

insert into TEmpleado (cNif, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cCorreo, cGenero, dFechaNacimiento) values 
('1234', 'Roberto', 'Briones', 2, 3, 1300, 29, 'roberto.briones@empresa.com', 'M', '1997-01-20'),
('5678', 'Laura', 'Chávez', 5, 4, 850, 27, 'laura.chavez@empresa.com', 'F', '1998-11-12'),
('9012', 'Ricardo', 'Gutiérrez', 4, 2, 900, 42, 'ricardo.gutierrez@empresa.com', 'M', '1984-05-05');

insert into TDepartamento (cNombreDepartamento) values 
('Logística'), ('Auditoría Interna'), ('Seguridad');

insert into TEmpleado (cNif, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cCorreo, cGenero, dFechaNacimiento) values 
('0001', 'Frustrado', 'Error', 2, 3, 350, 25, 'error.salario@empresa.com', 'M', '2001-01-01');
go

insert into TSucursal (cNombreSucursal, cCiudad) values 
('Sucursal Central', 'Managua'),
('Sucursal Norte', 'Estelí'),
('Sucursal Sur', 'Rivas');

insert into TCliente (cNif, cNombre, cApellido, cCorreo, cTelefono, nEdad) values
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

insert into TVenta (nClienteID, nSucursalID, dFechaVenta, nMontoTotal) values
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
go

update TEmpleado set nSalario = nSalario * 1.10;
update TEmpleado set nSalario = nSalario * 1.20 where nDepartamentoID = 2;
update TEmpleado set cCorreo = 'carlos.m_nuevo@empresa.com' where nEmpleadoID = 1;
update TEmpleado set nCargoID = 1 where nEmpleadoID = 3;
update TEmpleado set nDepartamentoID = 3 where nEmpleadoID in (5, 6);
update TEmpleado set bActivo = 0 where nSalario < 500;
update TProyecto set FechaFinalizacion = '2026-08-15' where nProyectoID = 2;
update TVenta set nMontoTotal = nMontoTotal * 1.10 where nSucursalID = 1;
go

insert into TEmpleadoProyecto (nEmpleadoID, nProyectoID) values (3, 3);
go

delete from TEmpleadoProyecto where nEmpleadoID = (select nEmpleadoID from TEmpleado where cNif = '1111');
delete from TEmpleado where cNif = '1111';

delete from TEmpleadoProyecto where nEmpleadoID in (select nEmpleadoID from TEmpleado where bActivo = 0);
delete from TEmpleado where bActivo = 0;

delete from TEmpleadoProyecto where nProyectoID = 2;
delete from TProyecto where nProyectoID = 2;

delete from TEmpleadoProyecto where nEmpleadoID = 4;

delete from TDepartamento where nDepartamentoID not in (
    select distinct nDepartamentoID from TEmpleado where nDepartamentoID is not null
);
delete from TCliente where nClienteID not in (select distinct nClienteID from TVenta);
go

select * from TEmpleado order by cApellido asc;
select * from TEmpleado where nSalario > 1000;
select * from TEmpleado where bActivo = 1;
select * from TEmpleado where year(dFechaContratacion) = year(getdate());

select e.*, d.cNombreDepartamento 
from TEmpleado e
inner join TDepartamento d on e.nDepartamentoID = d.nDepartamentoID;

select e.*, c.cNombreCargo 
from TEmpleado e
inner join TCargo c on e.nCargoID = c.nCargoID;

select distinct e.* from TEmpleado e
inner join TEmpleadoProyecto ep on e.nEmpleadoID = ep.nEmpleadoID;

select d.cNombreDepartamento, count(e.nEmpleadoID) as CantidadEmpleados
from TDepartamento d
left join TEmpleado e on d.nDepartamentoID = e.nDepartamentoID
group by d.cNombreDepartamento;

select d.cNombreDepartamento, avg(e.nSalario) as SalarioPromedio
from TDepartamento d
inner join TEmpleado e on d.nDepartamentoID = e.nDepartamentoID
group by d.cNombreDepartamento;

select d.cNombreDepartamento, max(e.nSalario) as SalarioMaximo, min(e.nSalario) as SalarioMinimo
from TDepartamento d
inner join TEmpleado e on d.nDepartamentoID = e.nDepartamentoID
group by d.cNombreDepartamento;

select p.nombreProyecto, count(ep.nEmpleadoID) as CantidadEmpleados
from TProyecto p
inner join TEmpleadoProyecto ep on p.nProyectoID = ep.nProyectoID
group by p.nombreProyecto
having count(ep.nEmpleadoID) > 2;

select * from TEmpleado where cApellido like 'G%';
select * from TEmpleado order by nSalario desc;
select top 3 * from TEmpleado order by nSalario desc;
select * from TEmpleado where nEdad between 25 and 40;
select count(*) as TotalActivos from TEmpleado where bActivo = 1;
select count(*) as TotalProyectos from TProyecto;

select top 5 c.nClienteID, c.cNombre, c.cApellido, sum(v.nMontoTotal) as TotalComprado
from TCliente c
inner join TVenta v on c.nClienteID = v.nClienteID
group by c.nClienteID, c.cNombre, c.cApellido
order by TotalComprado desc;

select year(dFechaVenta) as Anio, month(dFechaVenta) as Mes, sum(nMontoTotal) as TotalVentas, count(nVentaID) as CantidadVentas
from TVenta
group by year(dFechaVenta), month(dFechaVenta)
order by Anio desc, Mes desc;

select c.nClienteID, c.cNombre, c.cApellido, avg(v.nMontoTotal) as PromedioVenta
from TCliente c
inner join TVenta v on c.nClienteID = v.nClienteID
group by c.nClienteID, c.cNombre, c.cApellido;

select v.nVentaID, v.dFechaVenta, v.nMontoTotal, c.cNombre + ' ' + c.cApellido as Cliente, s.cNombreSucursal as Sucursal
from TVenta v
inner join TCliente c on v.nClienteID = c.nClienteID
inner join TSucursal s on v.nSucursalID = s.nSucursalID;
go

alter table TEmpleado 
drop constraint ck_TEmpleado_nEdad;
go

alter table TEmpleado 
drop constraint uk_TEmpleado_cCorreo;
go

alter table TEmpleado 
add constraint ck_TEmpleado_nEdad check (nEdad between 18 and 65);

alter table TEmpleado 
add constraint uk_TEmpleado_cCorreo unique (cCorreo);
go

drop table TEmpleadoProyecto;
go

drop table TProyecto;
go

drop table TEmpleado;
go

drop table TCargo;
go

drop table TDepartamento;
go

drop table TSucursal;
go

create table TCliente(
    nClienteID int identity(1,1) constraint pk_TClienteID primary key,
    cNif nvarchar(15) not null constraint uk_TCliente_cNif unique,
    cNombre nvarchar(50) not null,
    cApellido nvarchar(50) not null,
    cCorreo nvarchar(100) constraint uk_TCliente_cCorreo unique,
    cTelefono nvarchar(20),
    nEdad int constraint ck_TCliente_nEdad check(nEdad >= 18),
    dFechaRegistro date constraint df_TCliente_dFechaRegistro default getdate()
);
go

create table TVenta(
    nVentaID int identity(1,1) constraint pk_nVentaID primary key,
    nClienteID int,
    nSucursalID int,
    dFechaVenta datetime constraint df_TVenta_dFechaVenta default getdate(),
    nMontoTotal int constraint ck_TVenta_nMontoTotal check(nMontoTotal > 0),
    constraint fk_TVenta_TCliente foreign key (nClienteID) references TCliente(nClienteID),
    constraint fk_TVenta_TSucursal foreign key (nSucursalID) references TSucursal(nSucursalID)
);
go

insert into TCliente (cNif, cNombre, cApellido, cCorreo, cTelefono, nEdad) values
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
go

insert into TVenta (nClienteID, nSucursalID, dFechaVenta, nMontoTotal) values
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
go

update TVenta
set nMontoTotal = nMontoTotal * 1.10
where nSucursalID = 1;
go

delete from TCliente
where nClienteID not in (select distinct nClienteID from TVenta);
go

select top 5 c.nClienteID, c.cNombre, c.cApellido, sum(v.nMontoTotal) as TotalComprado
from TCliente c
inner join TVenta v on c.nClienteID = v.nClienteID
group by c.nClienteID, c.cNombre, c.cApellido
order by TotalComprado desc;
go

select year(dFechaVenta) as Anio, month(dFechaVenta) as Mes, sum(nMontoTotal) as TotalVentas, count(nVentaID) as CantidadVentas
from TVenta
group by year(dFechaVenta), month(dFechaVenta)
order by Anio desc, Mes desc;
go

select c.nClienteID, c.cNombre, c.cApellido, avg(v.nMontoTotal) as PromedioVenta
from TCliente c
inner join TVenta v on c.nClienteID = v.nClienteID
group by c.nClienteID, c.cNombre, c.cApellido;
go

select v.nVentaID, v.dFechaVenta, v.nMontoTotal, c.cNombre + ' ' + c.cApellido as Cliente, s.cNombreSucursal as Sucursal
from TVenta v
inner join TCliente c on v.nClienteID = c.nClienteID
inner join TSucursal s on v.nSucursalID = s.nSucursalID;
go
