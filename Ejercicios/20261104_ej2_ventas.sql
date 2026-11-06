-- ventas.sql

CREATE DATABASE IF NOT EXISTS ventas;
USE ventas;

-- tabla productos
CREATE TABLE PRODUCTOS(
  pk_producto INT AUTO_INCREMENT,
  nombre_producto VARCHAR(50),
  stock INT,
  precio_actual DECIMAL(10,4),
  cif_nif_proveedor CHAR(9),
  categoria_producto UNSIGNED INT UNSIGNED
);

-- tabla proveedores
CREATE TABLE PROVEEDORES(
  pk_cif_nif_proveedor CHAR(9),
  nombre VARCHAR(25),
  telefono VARCHAR(13), -- ejemplo 0034699123456
  web VARCHAR(50),
  calle VARCHAR(50),
  numero SMALLINT UNSIGNED,
  ciudad VARCHAR(30),
  codigo_postal CHAR(5)
);

-- tabla categorias
CREATE TABLE CATEGORIAS(
  pk_categoria INT AUTO_INCREMENT,
  nombre_categoria VARCHAR(20),
  desc_categoria VARCHAR(100)
);

-- tabla clientes
CREATE TABLE CLIENTES(
  pk_cif_nif CHAR(12),
  nombre VARCHAR(25),
  apellido1 VARCHAR(25),
  apellido2 VARCHAR(25),
  calle VARCHAR(50),
  numero SMALLINT UNSIGNED,
  ciudad VARCHAR(30),
  codigo_postal CHAR(5)
);

-- tabla telefonos_clientes
CREATE TABLE TELEFONOS_CLIENTES(
  pk_telefono VARCHAR(13), -- ejemplo 0034699123456
  cif_nif_cliente CHAR(12) NOT NULL
);

-- tabla facturas
CREATE TABLE FACTURAS(
  pk_numero_factura CHAR(12),
  nombre VARCHAR(25),
  apellido1 VARCHAR(25),
  apellido2 VARCHAR(25),
  calle VARCHAR(50),
  numero SMALLINT UNSIGNED,
  ciudad VARCHAR(30),
  codigo_postal CHAR(5)
);


 -- tabla empleado
 CREATE TABLE empleado (
  pk_empleado int AUTO_INCREMENT primary key,
  apellido varchar(25) not null,
  nombre varchar(25) not null,
  sexo enum('Hombre', 'Mujer') not null,
  fecha_nacimiento date not null comment 'con esto se calculará la edad',
  estado_civil enum('Soltero', 'Casado', 'Divorciado', 'Viudo', 'Otro') not null,
  hijos int UNSIGNED default 0 ,
  fk_cargo integer,
  fk_departamento integer,
  fecha_contrato date not null,
  sueldo decimal(10,2) not null CHECK (sueldo > 700*12),
  retencion_sso decimal(10,2) GENERATED ALWAYS AS (sueldo * 0.047) STORED
);

-- foreign keys

ALTER TABLE empleado 
ADD CONSTRAINT cargos_empleados
FOREIGN KEY (fk_cargo) REFERENCES cargo(pk_cargo)
ON UPDATE CASCADE -- si un padre se cambia se cambian sus hijos en la tabla empleado
ON DELETE RESTRICT; -- si un padre se intenta borrar y tiene hijos, no se permite la operación

ALTER TABLE empleado 
ADD CONSTRAINT departamentos_empleados
FOREIGN KEY (fk_departamento) REFERENCES departamento(pk_departamento)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE empleados ADD COLUMN num_sso varchar(15);

ALTER TABLE empleados
ADD CONSTRAINT sso_empleado UNIQUE(num_sso);
