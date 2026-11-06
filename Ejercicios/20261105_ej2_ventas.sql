-- ventas.sql

CREATE DATABASE IF NOT EXISTS ventas;
USE ventas;

-- tabla productos
CREATE TABLE PRODUCTOS(
  pk_producto INT AUTO_INCREMENT,
  nombre_producto VARCHAR(50),
  stock INT,
  precio_actual DECIMAL(10,4),
  cif_nif_proveedor CHAR(12), -- ejemplo '00045671234A'
  categoria_producto INT UNSIGNED
);

ALTER TABLE PRODUCTOS ADD PRIMARY KEY (pk_producto);


-- tabla proveedores
CREATE TABLE PROVEEDORES(
  pk_cif_nif CHAR(12),
  nombre VARCHAR(25),
  telefono VARCHAR(13), -- ejemplo 0034699123456
  web VARCHAR(50),
  calle VARCHAR(50),
  numero SMALLINT UNSIGNED,
  ciudad VARCHAR(30),
  codigo_postal CHAR(5)
);

ALTER TABLE PROVEEDORES ADD PRIMARY KEY (pk_cif_nif);

-- tabla categorias
CREATE TABLE CATEGORIAS(
  pk_categoria INT AUTO_INCREMENT,
  nombre_categoria VARCHAR(20),
  desc_categoria VARCHAR(100)
);

ALTER TABLE CATEGORIAS ADD PRIMARY KEY (pk_categoria);


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

ALTER TABLE CLIENTES ADD PRIMARY KEY (pk_cif_nif);


-- tabla telefonos_clientes
CREATE TABLE TELEFONOS_CLIENTES(
  pk_telefono VARCHAR(13), -- ejemplo 0034699123456
  cif_nif_cliente CHAR(12) NOT NULL
);

ALTER TABLE TELEFONOS_CLIENTES ADD PRIMARY KEY (pk_telefono);


-- tabla facturas
CREATE TABLE FACTURAS(
  pk_numero_factura INT AUTO_INCREMENT,
  fecha DATE NOT NULL,
  descuento DECIMAL(6,2),
  importe_final DECIMAL(10,2),
  cif_nif_cliente CHAR(12) NOT NULL
);

ALTER TABLE FACTURAS ADD PRIMARY KEY (pk_numero_factura);


-- tabla facturas_productos
CREATE TABLE FACTURAS_PRODUCTOS(
  numero_factura INT,
  producto INT,
  cantidad INT UNSIGNED,
  precio_venta DECIMAL (10,2),
  iva DECIMAL(6,2)
);

ALTER TABLE FACTURAS_PRODUCTOS ADD PRIMARY KEY (numero_factura, producto);


-- foreign keys
ALTER TABLE PRODUCTOS 
ADD CONSTRAINT fk_cif_nif_proveedor
FOREIGN KEY (cif_nif_proveedor) REFERENCES PROVEEDORES(pk_cif_nif)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PRODUCTOS
ADD CONSTRAINT fk_categoria_producto
FOREIGN KEY (categoria_producto) REFERENCES CATEGORIAS(pk_categoria)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TELEFONOS_CLIENTES
ADD CONSTRAINT fk_cif_nif_cliente
FOREIGN KEY (cif_nif_cliente) REFERENCES CLIENTES(pk_cif_nif)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE FACTURAS
ADD CONSTRAINT fk_cif_nif_cliente -- duda si se puede llamar igual que la FK de otra tabla
FOREIGN KEY (cif_nif_cliente) REFERENCES CLIENTES(pk_cif_nif)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE FACTURAS_PRODUCTOS
ADD CONSTRAINT fk_numero_factura
FOREIGN KEY (numero_factura) REFERENCES FACTURAS(pk_numero_factura)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE FACTURAS_PRODUCTOS
ADD CONSTRAINT fk_producto
FOREIGN KEY (producto) REFERENCES PRODUCTOS(pk_producto)
ON UPDATE CASCADE ON DELETE RESTRICT;