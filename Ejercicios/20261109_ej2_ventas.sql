-- ventas.sql

CREATE DATABASE IF NOT EXISTS ventas;
USE ventas;

-- DROP TABLE FACTURAS_PRODUCTOS;
-- DROP TABLE TELEFONOS_CLIENTES;
-- DROP TABLE FACTURAS;
-- DROP TABLE CLIENTES;
-- DROP TABLE PRODUCTOS;
-- DROP TABLE PROVEEDORES;
-- DROP TABLE CATEGORIAS;

-- tabla productos
CREATE TABLE PRODUCTOS(
  pk_producto INT AUTO_INCREMENT,
  nombre_producto VARCHAR(50) NOT NULL,
  stock INT UNSIGNED,
  precio_actual DECIMAL(10,4),
  cif_nif_proveedor CHAR(12), -- ejemplo '00045671234A'
  categoria_producto INT,
  PRIMARY KEY (pk_producto)
);

-- ALTER TABLE PRODUCTOS ADD PRIMARY KEY (pk_producto);


-- tabla proveedores
CREATE TABLE PROVEEDORES(
  pk_cif_nif CHAR(12),
  nombre VARCHAR(50) NOT NULL,
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
  nombre_categoria VARCHAR(50) NOT NULL,
  desc_categoria VARCHAR(100),
  PRIMARY KEY (pk_categoria)
);

-- ALTER TABLE CATEGORIAS ADD PRIMARY KEY (pk_categoria);


-- tabla clientes
CREATE TABLE CLIENTES(
  pk_cif_nif CHAR(12),
  nombre VARCHAR(25) NOT NULL,
  apellido1 VARCHAR(25) NOT NULL,
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
  descuento DECIMAL(6,2) NOT NULL DEFAULT 0,
  importe_final DECIMAL(10,2) NOT NULL,
  cif_nif_cliente CHAR(12) NOT NULL,
  PRIMARY KEY (pk_numero_factura)
);

-- ALTER TABLE FACTURAS ADD PRIMARY KEY (pk_numero_factura);


-- tabla facturas_productos
CREATE TABLE FACTURAS_PRODUCTOS(
  numero_factura INT, -- NOT NULL -- duda si hace falta al ser parte de la PK
  producto INT,                   -- duda si hace falta al ser parte de la PK
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

-- ALTER TABLE PRODUCTOS MODIFY categoria_producto INT; -- antes tenia puesto tipo INT UNSIGNED y daba error
ALTER TABLE PRODUCTOS
ADD CONSTRAINT prod_nombre UNIQUE (nombre_producto);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT prod_stock
CHECK (stock >= 0);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT prod_precio_actual
CHECK (precio_actual >= 0);

ALTER TABLE PRODUCTOS
ADD CONSTRAINT fk_categoria_producto
FOREIGN KEY (categoria_producto) REFERENCES CATEGORIAS(pk_categoria)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PROVEEDORES
ADD CONSTRAINT proveedor_nombre UNIQUE (nombre);

ALTER TABLE CATEGORIAS
ADD CONSTRAINT categoria_nombre UNIQUE (nombre_categoria);

ALTER TABLE TELEFONOS_CLIENTES
ADD CONSTRAINT fk_cif_nif_cliente
FOREIGN KEY (cif_nif_cliente) REFERENCES CLIENTES(pk_cif_nif)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE FACTURAS
ADD CONSTRAINT fk_fac_cif_nif_cliente -- fk_cif_nif_cliente -- duda si se puede llamar igual que la FK de otra tabla
FOREIGN KEY (cif_nif_cliente) REFERENCES CLIENTES(pk_cif_nif)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE FACTURAS
ADD CONSTRAINT fact_descuento
CHECK (descuento >= 0);

ALTER TABLE FACTURAS
ADD CONSTRAINT fact_importe_final
CHECK (importe_final >= 0);

ALTER TABLE FACTURAS_PRODUCTOS
ADD CONSTRAINT fk_numero_factura
FOREIGN KEY (numero_factura) REFERENCES FACTURAS(pk_numero_factura)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE FACTURAS_PRODUCTOS
ADD CONSTRAINT fk_producto
FOREIGN KEY (producto) REFERENCES PRODUCTOS(pk_producto)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE FACTURAS_PRODUCTOS
ADD CONSTRAINT factprod_precio_venta
CHECK (precio_venta >= 0);

ALTER TABLE FACTURAS_PRODUCTOS
ADD CONSTRAINT factprod_iva
CHECK (iva >= 0);

-- ALTER TABLE FACTURAS_PRODUCTOS DROP FOREIGN KEY fk_fac_proc_producto;