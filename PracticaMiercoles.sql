if exists(select name from sys.databases where name = 'HospitalDB')
	begin 
	drop database HospitalDB
	end
go

create database HospitalDB
go

select * from sys.databases

use HospitalDB
go

create table Especialidades(
	Idespecialidad int identity(1,1) constraint pk_Idespecialidad primary key,
	nombre nvarchar(70) constraint ck_nombre check (nombre IN (
    'Neurocirugía', 'Cardiología', 'Urología', 'Oftalmología', 
    'Pediatría', 'Dermatología', 'Ginecología', 'Obstetricia', 
    'Oncología', 'Psiquiatría', 'Traumatología', 'Ortopedia', 
    'Gastenterología', 'Neumología', 'Nefrología', 'Neurología', 
    'Endocrinología', 'Infectología', 'Hematología', 'Reumatología', 
    'Anestesiología', 'Radiología', 'Patología', 'Otorrinolaringología', 
    'Fisiatría', 'Geriatría', 'Medicina Interna', 'Medicina General', 
    'Cirugía General', 'Cirugía Plástica', 'Inmunología', 'Alergología')
	),
	is_active bit constraint df_Especialidades_is_active default 1,
	created_at datetime constraint df_Especialidades_created_at default getdate(),
	updated_at datetime null,
	deleted_at datetime null
	);

create table Habitaciones(
	Idhabitacion int identity(1,1) constraint pk_Idhabitacion primary key,
	is_active bit constraint df_Habitaciones_is_active default 1,
	created_at datetime constraint df_Habitaciones_created_at default getdate(),
	updated_at datetime null,
	deleted_at datetime null
	);

create table Medicamentos(
	Idmedicamento int identity (1,1) constraint pk_Idmedicamento primary key,
	nombre nvarchar(40) not null,
	descripcion nvarchar(max) not null,
	vencimiento datetime not null,
	is_active bit constraint df_Medicamentos_is_active default 1,
	created_at datetime constraint df_Medicamentos_created_at default getdate(),
	updated_at datetime null,
	deleted_at datetime null
	);

create table Tratamientos(
	Idtratamiento int identity (1,1) constraint pk_Idtratamiento primary key,
	Inicio_tratamiento datetime not null,
	fin_tratamiento datetime not null,
	Idmedicamento int,
	constraint fk_Idmedicamento foreign key (Idmedicamento) references Medicamentos(Idmedicamento),
	is_active bit constraint df_Tratamientos_is_active default 1,
	created_at datetime constraint df_Tratamientos_created_at default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	);


create table Pacientes(
	Idpaciente int identity (1,1) constraint pk_Idpaciente primary key,
	nombre nvarchar(40) not null,
	apellido nvarchar(40) not null,
	cedula nvarchar (14) constraint ck_cedula check (len(cedula) = 14),
	fechaNacimiento datetime not null,
	edad int not null constraint ck_edad check (edad > 0),
	ciudad nvarchar(50) not null,
	direccion nvarchar(max) not null,
	correo nvarchar(40) constraint uk_correo unique,
	Idhabitacion int constraint fk_IdHabitacion foreign key (IdHabitacion) references Habitaciones(IdHabitacion),
	Idtratamiento int constraint fk_Idtratamiento foreign key(Idtratamiento) references Tratamientos(Idtratamiento),
	is_active bit constraint df_Pacientes_is_active default 1,
	created_at datetime constraint df_Pacientes_created_at default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	);

create table Medicos(
	Idmedico int identity (1,1) constraint pk_Idmedico primary key,
	nombre nvarchar(40) not null,
	apellido nvarchar(40) not null,
	cedula nvarchar (14) constraint ck_cedula check (len(cedula) = 14),
	fechaNacimiento datetime not null,
	edad int not null constraint ck_edad check (edad > 0),
	ciudad nvarchar(50) not null,
	direccion nvarchar(max) not null,
	correo nvarchar(40) constraint uk_correo unique,
	Idespecialidad int constraint fk_Idespecialidad foreign key (Idespecialidad) references Especialidades(Idespecialidad),
	salario int not null constraint ck_salario check(salario > 0),
	is_active bit constraint df_Medicos_is_active default 1,
	created_at datetime constraint df_Medicos_created_at default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	);

create table Citas(
	Idcita int identity (1,1) constraint pk_Idcita primary key,
	fecha datetime not null,
	Idpaciente int,
	IdMedico int,
	constraint fk_Idpaciente foreign key (Idpaciente) references Pacientes(Idpaciente),
	constraint fk_Idmedico foreign key (Idmedico) references Medicos(Idmedico),
	is_active bit constraint df_Citas_is_active default 1,
	created_at datetime constraint df_Citas_created_at default getdate(),
	updated_at datetime null,
	deleted_at datetime null,
	);


alter table Pacientes add telefono nvarchar(20) null;
go


alter table Pacientes add direccion_secundaria nvarchar(max) null;
go

alter table Pacientes add genero varchar(10) null;
go

alter table Pacientes add tipo_sangre varchar(5) null;
go

alter table Pacientes add fecha_registro_nacimiento date null;
go

alter table Pacientes alter column nombre nvarchar(60) not null;
go

alter table Pacientes alter column direccion nvarchar(max) not null;
go

alter table Medicos add experiencia_anios int null;
go

alter table Medicos add turno varchar(20) null;
go

alter table Citas add observaciones nvarchar(max) null;
go

alter table Citas drop column observaciones;
go

alter table Citas add estado varchar(20) null;
go

alter table Citas add costo_consulta int null;
go

alter table Citas alter column costo_consulta decimal(10,2) null;
go

alter table Habitaciones add disponibilidad bit constraint df_Habitaciones_disponibilidad default 1;
go

--drops

if object_id('tempdb..#tabla_temporal') is not null
begin
    drop table #tabla_temporal;
end
go

alter table Pacientes drop constraint ck_Pacientes_edad;
go

alter table Pacientes drop constraint uk_Pacientes_correo;
go

alter table Pacientes drop column ciudad;
go

if exists (select * from sys.objects where object_id = object_id('tablaprebas') and type = 'u')
begin
    drop table tablaprebas;
end
go

create table Auditoria(
    Idauditoria int identity(1,1) constraint pk_Auditoria primary key,
    tabla_afectada varchar(50),
    accion varchar(20),
    fecha datetime default getdate()
);
go

drop table Auditoria;
go

create table Logs(
    Idlog int identity(1,1) constraint pk_Logs primary key,
    descripcion nvarchar(max),
    fecha_log datetime default getdate()
);
go

drop table Logs;
go

alter table Pacientes drop constraint fk_Pacientes_Habitacion;
go

create table MedicamentosPrueba(
    Idmedicamento int primary key,
    nombre varchar(50)
);
go

drop table MedicamentosPrueba;
go

use master;
go

if exists(select name from sys.databases where name = 'hospitaldb_pruebas')
begin
    drop database hospitaldb_pruebas;
end
go

use HospitalDB;
go

--inserts
insert into Especialidades (nombre) values 
('Cardiología'),('Pediatría'),('Dermatología'),('Neurología'),('Ginecología');
go

insert into Habitaciones (is_active) values 
(1), (1), (1), (1), (1), (1), (1), (1), (1), (1);
go

insert into Medicamentos (nombre, descripcion, vencimiento) values 
('Paracetamol', 'Analgésico y antipirético', '2028-12-31'),
('Ibuprofeno', 'Antiinflamatorio no esteroideo', '2028-06-30'),
('Amoxicilina', 'Antibiótico de amplio espectro', '2027-05-15'),
('Omeprazol', 'Protector gástrico', '2029-01-20'),
('Losartán', 'Antihipertensivo', '2028-09-10'),
('Metformina', 'Antidiabético oral', '2028-11-25'),
('Atorvastatina', 'Para regular el colesterol', '2027-08-14'),
('Aspirina', 'Antiagregante plaquetario', '2029-03-05'),
('Salbutamol', 'Broncodilatador en aerosol', '2027-10-22'),
('Loratadina', 'Antihistamínico para alergias', '2028-04-18'),
('Clonazepam', 'Ansiolítico y anticonvulsivante', '2027-12-01'),
('Enalapril', 'Inhibidor de la ECA para presión', '2028-07-19'),
('Diclofenaco', 'Analgésico y antiinflamatorio', '2027-03-11'),
('Sertralina', 'Antidepresivo', '2029-05-30'),
('Azitromicina', 'Antibiótico macrólido', '2027-06-24'),
('Tramadol', 'Analgésico opioide', '2028-02-15'),
('Ranitidina', 'Antagonista H2 para la acidez', '2027-09-09'),
('Fluoxetina', 'Antidepresivo ISRS', '2028-10-05'),
('Pantoprazol', 'Inhibidor de la bomba de protones', '2029-02-28'),
('Simvastatina', 'Hipolipemiante', '2027-11-12');
go

insert into Tratamientos (Inicio_tratamiento, fin_tratamiento, Idmedicamento) values 
('2026-05-01', '2026-06-15', 1),
('2026-05-20', '2026-07-20', 2),
('2026-06-01', '2026-06-07', 3),
('2026-06-02', '2026-08-02', 4),
('2026-05-15', '2026-11-15', 5),
('2025-01-10', '2025-02-10', 6),
('2025-03-15', '2025-04-15', 7),
('2025-06-01', '2025-06-10', 8),
('2025-09-20', '2025-10-20', 9),
('2025-12-01', '2025-12-15', 10);
go

insert into Pacientes (nombre, apellido, cedula, fechaNacimiento, edad, ciudad, direccion, correo, Idhabitacion, Idtratamiento) values 
('Juan', 'Pérez', '001-010190-000A', '1990-05-12', 36, 'Managua', 'De los semáforos 2c al norte', 'juan.perez@email.com', 1, 1),
('María', 'López', '001-150885-000B', '1985-08-15', 40, 'Managua', 'Colonia Centroamérica casa M4', 'maria.lopez@email.com', 2, 2),
('Carlos', 'García', '002-231195-000C', '1995-11-23', 30, 'León', 'Barrio El Laborío', 'carlos.garcia@email.com', 3, 3),
('Ana', 'Martínez', '003-040288-000D', '1988-02-04', 38, 'Granada', 'Calle El Caimito', 'ana.martinez@email.com', 4, 4),
('Luis', 'Rodríguez', '001-121275-000E', '1975-12-12', 50, 'Managua', 'Bello Horizonte E-II', 'luis.rodriguez@email.com', 5, 5),
('Elena', 'Gómez', '201-300492-000F', '1992-04-30', 34, 'Estelí', 'Barrio El Rosario', 'elena.gomez@email.com', 6, 6),
('Pedro', 'Sánchez', '001-250780-000G', '1980-07-25', 45, 'Managua', 'Altamira d`este N-12', 'pedro.sanchez@email.com', 7, 7),
('Sofía', 'Díaz', '161-140298-000H', '1998-02-14', 28, 'Matagalpa', 'Barrio Guanuca', 'sofia.diaz@email.com', 8, 8),
('Diego', 'Torres', '001-090965-000I', '1965-09-09', 60, 'Managua', 'Ciudad Jardín Q-8', 'diego.torres@email.com', 9, 9),
('Lucía', 'Ramírez', '041-180693-000J', '1993-06-18', 32, 'Chinandega', 'Barrio Santa Ana', 'lucia.ramirez@email.com', 10, 10),
('Jorge', 'Vargas', '001-221082-000K', '1982-10-22', 43, 'Managua', 'Linda Vista Sur casa 45', 'jorge.vargas@email.com', 1, 1),
('Laura', 'Castro', '002-050591-000L', '1991-05-05', 35, 'León', 'Barrio Sutiaba', 'laura.castro@email.com', 2, 2),
('Andrés', 'Morales', '003-191187-000M', '1987-11-19', 38, 'Granada', 'Calle Real Xalteva', 'andres.morales@email.com', 3, 3),
('Claudia', 'Ortiz', '001-110179-000N', '1979-01-11', 47, 'Managua', 'Bolonia frente al canal', 'claudia.ortiz@email.com', 4, 4),
('Ricardo', 'Mendoza', '321-270396-000O', '1996-03-27', 30, 'Masaya', 'Barrio Monimbó', 'ricardo.mendoza@email.com', 5, 5),
('Natalia', 'Silva', '001-080884-000P', '1984-08-08', 41, 'Managua', 'Reparto Schick', 'natalia.silva@email.com', 6, 6),
('Gabriel', 'Reyes', '041-151289-000Q', '1989-12-15', 36, 'Chinandega', 'Barrio El Calvario', 'gabriel.reyes@email.com', 7, 7),
('Valentina', 'Espinoza', '161-210794-000R', '1994-07-21', 31, 'Matagalpa', 'Barrio Apante', 'valentina.espinoza@email.com', 8, 8),
('Mateo', 'Jiménez', '001-030370-000S', '1970-03-03', 56, 'Managua', 'Monseñor Lezcano', 'mateo.jimenez@email.com', 9, 9),
('Camila', 'Herrera', '201-121297-000T', '1997-12-12', 28, 'Estelí', 'Barrio Central', 'camila.herrera@email.com', 10, 10);
go

insert into Medicos (nombre, apellido, cedula, fechaNacimiento, edad, ciudad, direccion, correo, Idespecialidad, salario) values 
('Roberto', 'Briones', '001-120478-000A', '1978-04-12', 48, 'Managua', 'Los Robles R-5', 'roberto.briones@email.com', 1, 85000),
('Alejandra', 'Solís', '001-240981-000B', '1981-09-24', 44, 'Managua', 'Carretera a Masaya km 10', 'alejandra.solis@email.com', 2, 75000),
('Fernando', 'Meléndez', '002-150672-000C', '1972-06-15', 53, 'León', 'Frente a la iglesia La Recolección', 'fernando.melendez@email.com', 3, 80000),
('Adriana', 'Gutiérrez', '001-030385-000D', '1985-03-03', 41, 'Managua', 'Villa Fontana Sur', 'adriana.gutierrez@email.com', 4, 90000),
('Manuel', 'Duarte', '003-181176-000E', '1976-11-18', 49, 'Granada', 'Calle La Calzada', 'manuel.duarte@email.com', 5, 78000),
('Patricia', 'Salinas', '001-090983-000F', '1983-09-09', 42, 'Managua', 'Las Colinas Pasaje 3', 'patricia.salinas@email.com', 1, 87000),
('Francisco', 'Rizo', '161-220270-000G', '1970-02-22', 56, 'Matagalpa', 'Frente al parque central', 'francisco.rizo@email.com', 2, 76000),
('Diana', 'Montenegro', '001-140787-000H', '1987-07-14', 38, 'Managua', 'Bello Horizonte F-IV', 'diana.montenegro@email.com', 3, 81000),
('Héctor', 'Palacios', '201-050574-000I', '1974-05-05', 52, 'Estelí', 'Salida sur 1c al oeste', 'hector.palacios@email.com', 4, 93000),
('Gabriela', 'Blanco', '041-301180-000J', '1980-11-30', 45, 'Chinandega', 'Reparto Los Encuentros', 'gabriela.blanco@email.com', 5, 79000);
go

insert into Citas (fecha, Idpaciente, IdMedico) values 
('2026-06-03 08:30:00', 1, 1),
('2026-06-03 10:00:00', 2, 2),
('2026-06-03 11:30:00', 3, 3),
('2026-06-03 14:00:00', 4, 4),
('2026-06-03 15:30:00', 5, 5),
('2026-07-10 09:00:00', 6, 6),
('2026-07-15 10:30:00', 7, 7),
('2026-08-20 08:00:00', 8, 8),
('2026-08-22 13:00:00', 9, 9),
('2026-09-05 15:00:00', 10, 10),
('2026-10-01 11:00:00', 11, 1),
('2026-10-12 14:30:00', 12, 2),
('2026-11-04 09:30:00', 13, 3),
('2026-11-20 10:00:00', 14, 4),
('2026-12-01 16:00:00', 15, 5);
go

update Habitaciones set is_active = 0 where Idhabitacion in (1, 2, 3, 4, 5);
update Habitaciones set is_active = 1 where Idhabitacion in (6, 7, 8, 9, 10);
go

update Pacientes 
set telefono = '+505 8888-8888' 
where Idpaciente = 1;
go

update Pacientes 
set direccion = 'Altamira, de la Vicky 2c al sur' 
where Idpaciente = 1;
go

update Medicos 
set salario = 95000 
where Idmedico = 1;
go

update Medicos 
set turno = 'Nocturno' 
where Idmedico = 1;
go

update Citas 
set estado = 'Completada' 
where Idcita = 1;
go

update Citas 
set costo_consulta = 1500.00 
where Idcita = 1;
go

update Especialidades 
set nombre = 'Neurocirugía' 
where Idespecialidad = 1;
go

update Habitaciones 
set disponibilidad = 0 
where Idhabitacion = 1;
go

-- 9
update Tratamientos 
set fin_tratamiento = '2026-08-30' 
where Idtratamiento = 1;
go

update Medicamentos 
set descripcion = 'Analgésico y antipirético de 500mg' 
where Idmedicamento = 1;
go

update Pacientes 
set correo = 'juan.nuevo_correo@email.com' 
where Idpaciente = 1;
go

update Medicos 
set correo = 'roberto.nuevo_medico@email.com' 
where Idmedico = 1;
go

update Citas 
set fecha = '2026-06-15 09:00:00' 
where Idcita = 1;
go

update Medicos 
set experiencia_anios = 15 
where Idmedico = 1;
go

update Pacientes 
set tipo_sangre = 'O+' 
where Idpaciente = 1;
go

--delete

delete from Pacientes 
where Idpaciente = 20;
go

delete from Citas 
where Idcita = 15;
go

update Tratamientos set Idmedicamento = null where Idmedicamento = 20;
delete from Medicamentos 
where Idmedicamento = 20;
go

update Pacientes set Idhabitacion = null where Idhabitacion = 10;
delete from Habitaciones 
where Idhabitacion = 10;
go

update Pacientes set Idtratamiento = null where Idtratamiento = 10;
delete from Tratamientos 
where Idtratamiento = 10;
go

delete from Citas 
where is_active = 0;
go

delete from Pacientes 
where Idpaciente not in (
    select distinct Idpaciente 
    from Citas 
    where Idpaciente is not null
);
go

delete from Habitaciones 
where is_active = 1 
and Idhabitacion not in (
    select distinct Idhabitacion 
    from Pacientes 
    where Idhabitacion is not null
);
go

delete from Medicamentos 
where vencimiento < getdate();
go

delete from Citas where deleted_at is not null;
delete from Pacientes where deleted_at is not null;
delete from Medicos where deleted_at is not null;
delete from Tratamientos where deleted_at is not null;
delete from Medicamentos where deleted_at is not null;
delete from Habitaciones where deleted_at is not null;
delete from Especialidades where deleted_at is not null;
go
