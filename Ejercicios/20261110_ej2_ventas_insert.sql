-- ventas_insert.sql
USE ventas;


-- tabla categorias
INSERT INTO CATEGORIAS (nombre_categoria, desc_categoria) VALUES ('Camisetas', 'Camisetas');
INSERT INTO CATEGORIAS (nombre_categoria, desc_categoria) VALUES ('Camisas', 'Camisas');
INSERT INTO CATEGORIAS (nombre_categoria, desc_categoria) VALUES ('Pantalones', 'Pantalones');
-- SELECT * FROM CATEGORIAS;

-- -- error pk_categoria 
-- -- -- error si se introduce NEXTVAL -- NO da error
INSERT INTO CATEGORIAS (pk_categoria, nombre_categoria, desc_categoria) VALUES (4, 'Zapatos', 'Zapatos');
-- SELECT * FROM CATEGORIAS;

-- -- -- error si se introduce valor mayor que NEXTVAL -- NO da error
INSERT INTO CATEGORIAS (pk_categoria, nombre_categoria, desc_categoria) VALUES (8, 'Zapatos2', 'Zapatos2');
-- SELECT * FROM CATEGORIAS;

-- -- -- error si se introduce valor de PK ya existente
INSERT INTO CATEGORIAS (pk_categoria, nombre_categoria, desc_categoria) VALUES (1, 'Chaquetas', 'Chaquetas'); -- error: MySQL Error (1062): Duplicate entry '1' for key 'categorias.PRIMARY'

-- -- error nombre_categoria sin informar
INSERT INTO CATEGORIAS (nombre_categoria, desc_categoria) VALUES ('', 'Gafas'); -- NO ha dado error -- '' es cadena vacía y es <> NULL
-- SELECT * FROM CATEGORIAS;
-- SELECT * FROM CATEGORIAS WHERE nombre_categoria LIKE '';
-- SELECT '' AS cadena_vacia FROM DUAL;

INSERT INTO CATEGORIAS (nombre_categoria, desc_categoria) VALUES (NULL, 'Gafas2'); -- error: MySQL Error (1048): Column 'nombre_categoria' cannot be null
INSERT INTO CATEGORIAS (desc_categoria) VALUES ('Bambas'); -- error: MySQL Error (1364): Field 'nombre_categoria' doesn't have a default value
-- ?? si tuviera default value, la primera inserción con el campo 'categoria' sin informar sí que lo permitiría ??

-- -- error nombre_categoria repetido --> NO detectará diferencias Bambas vs bambas
INSERT INTO CATEGORIAS (nombre_categoria, desc_categoria) VALUES ('Camisetas', 'Categoría repetida de camisetas'); -- error: MySQL Error (1062): Duplicate entry 'Camisetas' for key 'categorias.categoria_nombre'





-- tabla proveedores
INSERT INTO PROVEEDORES (pk_cif_nif, nombre, telefono, web, calle, numero, ciudad, codigo_postal) VALUES ('12345678A', 'Alba SA', '0034123456789', 'www.web1.com', 'Avenida Barcelona', 1, 'Barcelona', '08001');
INSERT INTO PROVEEDORES (pk_cif_nif, nombre, telefono, web, calle, numero, ciudad, codigo_postal) VALUES ('23456789B', 'Blas SA', '+34234567890', 'www.web2.com', 'Avenida Barcelona', 2, 'Barcelona', '08001');
INSERT INTO PROVEEDORES (pk_cif_nif, nombre, telefono, web, calle, numero, ciudad, codigo_postal) VALUES ('34567890C', 'Carlos SA', '0034345678901', 'www.web3.com', 'Avenida Barcelona', 3, 'Barcelona', '08001');
INSERT INTO PROVEEDORES (pk_cif_nif, nombre, telefono, web, calle, numero, ciudad, codigo_postal) VALUES ('45678901D', 'Diego SA', '0034456789012', 'www.web4.com', 'Avenida Barcelona', 4, 'Barcelona', '08001');
-- SELECT * FROM PROVEEDORES;

-- -- error pk_cif_nif
-- -- -- error si se introduce valor de PK ya existente
INSERT INTO PROVEEDORES (pk_cif_nif, nombre, telefono, web, calle, numero, ciudad, codigo_postal) VALUES ('12345678A', 'Alba2 SA', '0034567890123', 'www.web5.com', 'Avenida Barcelona', 5, 'Barcelona', '08001');
-- error: MySQL Error (1062): Duplicate entry '12345678A' for key 'proveedores.PRIMARY'

-- -- error nombre
-- -- -- error si se introduce valor del campo NOMBRE ya existente (porque es UNIQUE)
INSERT INTO PROVEEDORES (pk_cif_nif, nombre, telefono, web, calle, numero, ciudad, codigo_postal) VALUES ('67890123F', 'Alba SA', '0034123456789', 'www.web1.com', 'Avenida Barcelona', 1, 'Barcelona', '08001');
-- error: MySQL Error (1062): Duplicate entry 'Alba SA' for key 'proveedores.proveedor_nombre'

-- -- error numero
-- -- -- error si se introduce valor del campo NUMERO que es negativo
INSERT INTO PROVEEDORES (pk_cif_nif, nombre, telefono, web, calle, numero, ciudad, codigo_postal) VALUES ('78901234G', 'Gustavo SA', '0034789012345', 'www.web7.com', 'Avenida Barcelona', -1, 'Barcelona', '08001');
-- error: MySQL Error (1264): Out of range value for column 'numero' at row 1




-- tabla productos
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Camiseta manga corta', 25, 10.01, '12345678A', 1);
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Camiseta manga larga', 30, 10.0275, '12345678A', 1);
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Camisa manga larga', 35, 10.03, '12345678A', 2);
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Camisa manga corta', 40, 10.04, '12345678A', 2);
-- SELECT * FROM PRODUCTOS;

-- -- error stock
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Camisa manga corta', -1, 10.05, '12345678A', 2);
-- error: MySQL Error (1264): Out of range value for column 'stock' at row 1

-- -- error precio_actual
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Pantalón corto', 45, 123456.0575, '12345678A', 3);
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Pantalón corto2', 45, 1234567.0575, '12345678A', 3);
-- error: MySQL Error (1264): Out of range value for column 'precio_actual' at row 1
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Pantalón corto3', 45, -1, '12345678A', 3);
-- error: MySQL Error (3819): Check constraint 'prod_precio_actual' is violated.

-- SELECT * FROM PRODUCTOS;
-- DELETE FROM PRODUCTOS WHERE pk_producto = 6;

-- -- error categoria
INSERT INTO PRODUCTOS (nombre_producto, stock, precio_actual, cif_nif_proveedor, categoria_producto) VALUES ('Pantalón corto4', 45, 10.05, '12345678A', 25);
-- error: MySQL Error (1452): Cannot add or update a child row: a foreign key constraint fails (`ventas`.`productos`, CONSTRAINT `fk_categoria_producto` FOREIGN KEY (`categoria_producto`) REFERENCES `categorias` (`pk_categoria`) ON DELETE RESTRICT ON UPDATE CASCADE)



-- tabla clientes
INSERT INTO CLIENTES (pk_cif_nif, nombre, apellido1, apellido2, calle, numero, ciudad, codigo_postal) VALUES ('12345678A', 'Alicia', 'Álvarez', 'García', 'Avenida Diagonal', 1, 'Barcelona', '08009'); -- CIF_NIF es el mismo que el de 1 proveedor
INSERT INTO CLIENTES (pk_cif_nif, nombre, apellido1, apellido2, calle, numero, ciudad, codigo_postal) VALUES ('56789012E', 'Eduardo', 'García', 'García', 'Avenida Diagonal', 2, 'Barcelona', '08009');
INSERT INTO CLIENTES (pk_cif_nif, nombre, apellido1, apellido2, calle, numero, ciudad, codigo_postal) VALUES ('67890123G', 'Gabriel', 'García', '', 'Avenida Diagonal', 3, 'Barcelona', '08009');
INSERT INTO CLIENTES (pk_cif_nif, nombre, apellido1, calle, numero, ciudad, codigo_postal) VALUES ('78901234I', 'Isabel', 'Alonso', 'Avenida Diagonal', 4, 'Barcelona', '08009');
-- SELECT * FROM CLIENTES;

-- -- error apellido1
-- -- -- error si se introduce valor ''
INSERT INTO CLIENTES (pk_cif_nif, nombre, apellido1, calle, numero, ciudad, codigo_postal) VALUES ('78901234J', 'Javier', '', 'Avenida Diagonal', 5, 'Barcelona', '08009');
-- error: NO ha dado error -- '' es cadena vacía y es <> NULL

-- -- -- error si se introduce sin valor
INSERT INTO CLIENTES (pk_cif_nif, nombre, apellido1, calle, numero, ciudad, codigo_postal) VALUES ('89012345L', 'Laura', NULL, 'Avenida Diagonal', 6, 'Barcelona', '08009');
-- error: MySQL Error (1048): Column 'apellido1' cannot be null
INSERT INTO CLIENTES (pk_cif_nif, nombre, calle, numero, ciudad, codigo_postal) VALUES ('89012345L', 'Laura', 'Avenida Diagonal', 6, 'Barcelona', '08009');
-- error: MySQL Error (1364): Field 'apellido1' doesn't have a default value




-- tabla facturas
INSERT INTO FACTURAS (fecha, descuento, importe_final, cif_nif_cliente) VALUES ('2025-01-18', 2, 9.01, '12345678A');
INSERT INTO FACTURAS (fecha, descuento, importe_final, cif_nif_cliente) VALUES ('2025-02-19', 5.75, 8.01, '12345678A');
INSERT INTO FACTURAS (fecha, descuento, importe_final, cif_nif_cliente) VALUES ('2026-03-20', 2.75, 8.51, '12345678A');
INSERT INTO FACTURAS (fecha, descuento, importe_final, cif_nif_cliente) VALUES ('2026-03-21', 2.95, 8.31, '12345678A');

-- -- error descuento
INSERT INTO FACTURAS (fecha, descuento, importe_final, cif_nif_cliente) VALUES ('2025-01-18', NULL, 9.01, '12345678A');
-- error: 
INSERT INTO FACTURAS (fecha, descuento, importe_final, cif_nif_cliente) VALUES ('2025-01-18', , 9.01, '12345678A');
-- error: 


CREATE TABLE FACTURAS(
  pk_numero_factura INT AUTO_INCREMENT,
  fecha DATE NOT NULL,
  descuento DECIMAL(6,2) NOT NULL DEFAULT 0,
  importe_final DECIMAL(10,2) NOT NULL,
  cif_nif_cliente CHAR(12) NOT NULL,
  PRIMARY KEY (pk_numero_factura)
);