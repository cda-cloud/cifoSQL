/**************************************************************************/
/***** Ejercicio 10. Vistas, creación de tablas y variables de sesión *****/
/**************************************************************************/



/*******************************************/
/*** Usando la Base de Datos jardineria: ***/
/*******************************************/
USE jardineria;


-- 1. Crea una vista llamada pedidos_no_entregados que muestre para cada uno de
--     los pedidos de la Base de Datos de jardinería, el código del pedido, la fecha del
--     pedido, el nombre completo del cliente que lo realizó y su estado para aquellos
--     pedidos que no hayan sido entregados. Ordenala por estado.

CREATE OR REPLACE VIEW pedidos_no_entregados
  AS
  SELECT ped.pk_pedido AS 'Código del pedido',
         ped.fecha_pedido AS 'Fecha del pedido',
         cli.nombre_cliente AS 'Nombre cliente',
         CONCAT(cli.nombre_contacto, ' ', cli.apellido_contacto) AS 'Nombre contacto cliente',      -- Nombre del contacto del cliente         
         ped.estado AS 'Estado del pedido'
    FROM pedido ped
         JOIN cliente cli
              ON cli.pk_cliente = ped.fk_cliente
   WHERE ped.estado NOT IN ('Entregado')
ORDER BY ped.estado
;

SELECT *
  FROM pedidos_no_entregados
;


-- 2. Crea una vista que se llame listado_pagos_clientes que muestre un listado
--      donde aparezcan todos los clientes y los pagos que ha realizado cada uno de
--      ellos. La vista deberá tener las siguientes columnas: nombre y apellidos del cliente
--      concatenados, teléfono, ciudad, pais, fecha_pago, total del pago e id de la
--      transacción.
CREATE OR REPLACE VIEW listado_pagos_clientes
  AS
  SELECT CONCAT(cli.nombre_contacto, ' ', cli.apellido_contacto) AS 'nombre_cliente',  -- Nombre del contacto del cliente
         cli.telefono,
         cli.ciudad,
         cli.pais,
         pag.fecha_pago,
         pag.total AS 'total_pago',
         pag.id_transaccion
    FROM cliente cli
         LEFT JOIN pago pag         -- LEFT JOIN para listar también los clientes que no realizaron ningún pago
                   ON cli.pk_cliente = pag.fk_cliente
ORDER BY cli.nombre_contacto,
         cli.apellido_contacto,
         pag.id_transaccion
;

SELECT *
  FROM listado_pagos_clientes
;

-- Comprobación de los distintos clientes que no tienen pagos con los del ejercicio 9.3
--      Coinciden los 17 registros
SELECT DISTINCT nombre_cliente
  FROM listado_pagos_clientes
 WHERE fecha_pago IS NULL
;
-- Ej. 9.3:
SELECT DISTINCT nombre_cliente
  FROM (
        SELECT cli.nombre_cliente,
               CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas
          FROM cliente cli
               JOIN empleado emp
                    ON cli.fk_representante_ventas = emp.pk_empleado
               LEFT JOIN pago pag
                    ON cli.pk_cliente = pag.fk_cliente
         WHERE pag.fk_cliente IS NULL
  ) ej9_3        
;


-- 3. Crea una vista que se llame listado_pedidos_clientes que muestre un listado
--        donde aparezcan todos los clientes y los pedidos que ha realizado cada uno de
--        ellos. La vista deberá tener las siguientes columnas: código del cliente, nombre y
--        apellidos del cliente concatendados, teléfono, ciudad, pais, código del pedido,
--        fecha del pedido, fecha esperada y fecha de entrega.
CREATE OR REPLACE VIEW listado_pedidos_clientes
  AS
  SELECT cli.pk_cliente AS 'codigo_cliente',
         CONCAT(cli.nombre_contacto, ' ', cli.apellido_contacto) AS 'nombre_cliente',  -- Nombre del contacto del cliente
         cli.telefono,
         cli.ciudad,
         cli.pais,
         ped.pk_pedido AS codigo_pedido,
         ped.fecha_pedido,
         ped.fecha_esperada,
         ped.fecha_entrega
    FROM cliente cli
         LEFT JOIN pedido ped         -- LEFT JOIN para listar también los clientes que no realizaron ningún pedido
                   ON cli.pk_cliente = ped.fk_cliente
ORDER BY cli.nombre_contacto,
         cli.apellido_contacto,
         ped.pk_pedido
;

SELECT *
  FROM listado_pedidos_clientes
;


-- 4. Crea una variable de sesión denominada @ciudad. Utiliza la vista que ha creado
--      en el punto 2, para crear una consulta que muestre el listado de los clientes de la
--      ciudad de Madrid que han realizado pagos.

SELECT MAX(cli.ciudad) FROM cliente cli WHERE cli.ciudad LIKE 'Madrid';

-- Crear la variable y asignarle el valor:
SELECT MAX(cli.ciudad) INTO @ciudad FROM cliente cli WHERE cli.ciudad LIKE 'Madrid';

-- Otra forma de crear la variable:
SELECT @ciudad2 := 'Madrid';            -- NOTA: para asignar el valor a la variable "ciudad2" con SELECT se usa ':='

-- Otra forma de crear la variable:
SET @ciudad3 = 'Madrid';
SELECT @ciudad3;

SELECT DISTINCT vw_pag_cli.nombre_cliente
  FROM listado_pagos_clientes vw_pag_cli
 WHERE vw_pag_cli.ciudad = @ciudad2
   AND vw_pag_cli.fecha_pago IS NOT NULL    -- Se quiere listar los clientes que han realizado pagos
 ;


-- 5. Cambia el valor de la variable @ciudad a Miami y repite la operación anterior.

-- Intrucción para cambiar el valor de la variable
SET @ciudad = 'Miami';

SELECT DISTINCT vw_pag_cli.nombre_cliente
  FROM listado_pagos_clientes vw_pag_cli
 WHERE vw_pag_cli.ciudad = @ciudad
   AND vw_pag_cli.fecha_pago IS NOT NULL    -- Se quiere listar los clientes que han realizado pagos
 ;

-- 6. Crea ocho vistas basadas en las consultas realizadas en el Ejercicio 9 (Consultas
--      Multitabla), cuatro de ellas con los ejercicios que hayas considerado más difíciles
--      de la Base de Datos de nómina y cuatro con los ejercicios que hayas considerado
--      más difíciles de la Base de Datos de jardinería.

/* de los ejercicios de NOMINA */
USE nominas;


-- -- 14. Lista todos cargos registrados que existen en la base de datos, junto con el nombre y apellido del empleado, 
--      la edad y estado civil que tiene cada empleado. El listado deberá mostrar también aquellos cargos que no tienen empleados asociados.
CREATE OR REPLACE VIEW listado_cargos_empleados
  AS
  SELECT car.cargo,
         emp.nombre,
         emp.apellido,
         FLOOR(DATEDIFF(CURDATE(), emp.fecha_nacimiento) / 365) AS edad,
         emp.estado_civil
    FROM cargo car
         LEFT  JOIN empleado emp
                    ON car.pk_cargo = emp.fk_cargo
ORDER BY car.cargo,             -- NOTA: ordeno alfabéticamente por cargo, nombre, apellido
         emp.nombre,
         emp.apellido
  ;

SELECT *
  FROM listado_cargos_empleados
  ;

-- -- 12. Lista nombre y apellido, edad, nombre del cargo, nombre del departamento de los empleados Solteros, Divorciados o Viudos que tengan más de un hijo. 
CREATE OR REPLACE VIEW listado_empleados_hijos
  AS
  SELECT emp.nombre,
         emp.apellido,
         FLOOR(DATEDIFF(CURDATE(), emp.fecha_nacimiento) / 365) AS edad,
         car.cargo,
         dpt.departamento
    FROM empleado emp
         INNER JOIN cargo car 
                    ON emp.fk_cargo = car.pk_cargo
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.estado_civil IN ('Soltero', 'Divorciado', 'Viudo')
     AND emp.hijos >= 2
  ;

SELECT *
  FROM listado_empleados_hijos
  ;  

-- -- 11. Lista el nombre y apellido del empleado, el nombre del cargo y del departamento de aquellas personas que tienen más de 20 años en la empresa. 
--      Ordena el resultado en primer lugar por el departamento (en orden ascendente) y en segundo lugar por el tiempo trabajado (en orden descendente)
CREATE OR REPLACE VIEW listado_empleados_senior
  AS
  SELECT emp.nombre,
         emp.apellido,
         car.cargo,
         dpt.departamento,
         DATEDIFF(CURRENT_DATE(), emp.fecha_contrato)/365 AS antiguedad
    FROM empleado emp
         INNER JOIN cargo car 
                    ON emp.fk_cargo = car.pk_cargo
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE DATEDIFF(CURRENT_DATE(), emp.fecha_contrato)/365 > 20
   -- WHERE FLOOR(DATEDIFF(CURDATE(), emp.fecha_contrato) / 365) > 20     -- NOTA: con esta opción, usando FLOOR, un empleado con 20.3 años se filtraría y no aparecería en el resultado
ORDER BY dpt.departamento,
         DATEDIFF(CURRENT_DATE(), emp.fecha_contrato) DESC
  ;

SELECT *
  FROM listado_empleados_senior
  ;  

-- -- 9. Lista los empleados de los departamentos de Compras y Ventas sin utilizar el operador IN.
CREATE OR REPLACE VIEW listado_empleados_compras_ventas
  AS
  SELECT emp.nombre,
         emp.apellido
    FROM empleado emp
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE (dpt.departamento = 'Compras' OR dpt.departamento = 'Ventas')
  ;

SELECT *
  FROM listado_empleados_compras_ventas
  ;


/* de los ejercicios de JARDINERIA */
USE jardineria;

-- -- 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
CREATE OR REPLACE VIEW listado_clientes_impagos
  AS
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
 WHERE pag.fk_cliente IS NULL
;

SELECT *
  FROM listado_clientes_impagos
  ;

-- NOTA: el cliente 'Lasas S.A.' aparece 2 veces porque hay 2 pk_cliente -6 y 12- para el mismo nombre_cliente:
SELECT cli.nombre_cliente, cli.*,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
 WHERE pag.fk_cliente IS NULL
;


-- -- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
CREATE OR REPLACE VIEW listado_clientes_impagos_representantes
  AS
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas,
       ofi.ciudad AS ciudad_oficina_representante
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
       JOIN oficina ofi
            ON emp.fk_oficina = ofi.pk_oficina            
 WHERE pag.fk_cliente IS NULL
;

SELECT * 
  FROM listado_clientes_impagos_representantes
  ;

-- -- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
CREATE OR REPLACE VIEW listado_clientes_pedidos_retraso
  AS
SELECT DISTINCT cli.nombre_cliente
  FROM cliente cli
       JOIN pedido ped
            ON ped.fk_cliente = cli.pk_cliente
 WHERE ((ped.fecha_entrega IS NOT NULL AND ped.fecha_entrega > ped.fecha_esperada) OR
        (ped.fecha_entrega IS NULL AND ped.fecha_esperada < CURRENT_DATE())
       )
;

SELECT *
  FROM listado_clientes_pedidos_retraso
  ;

-- -- 20. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
CREATE OR REPLACE VIEW listado_oficinas_repre_no_frutales
  AS
SELECT ofi.*
  FROM oficina ofi
       LEFT JOIN (
                    SELECT ofi.pk_oficina -- ofi.*, ped.pk_pedido, gam.gama, emp.pk_empleado-- , emp.nombre, emp.apellido1, emp.apellido2
                       FROM cliente cli
                            JOIN pedido ped
                                 ON ped.fk_cliente = cli.pk_cliente
                            JOIN detalle_pedido det
                                 ON det.fk_pedido = ped.pk_pedido
                            JOIN producto prod
                                 ON prod.pk_producto = det.fk_producto
                            JOIN gama_producto gam
                                 ON gam.pk_gama = prod.fk_gama
                            JOIN empleado emp
                                 ON emp.pk_empleado = cli.fk_representante_ventas
                            JOIN oficina ofi
                                 ON ofi.pk_oficina = emp.fk_oficina
                      WHERE gam.gama = 'Frutales'
                 ) ofi_frutales    
                 ON ofi.pk_oficina = ofi_frutales.pk_oficina
  WHERE ofi_frutales.pk_oficina IS NULL
  ;

SELECT *
  FROM listado_oficinas_repre_no_frutales
  ;


-- 7. Elimina la vista listado_pedidos_clientes de la Base de Datos jardineria.
DROP VIEW listado_pedidos_clientes;

SELECT *
  FROM listado_pedidos_clientes
  ;
-- OK, devuelve el error --> MySQL Error (1146): Table 'jardineria.listado_pedidos_clientes' doesn't exist


-- 8. Crea una nueva tabla con el resultado de la vista que te haya resultado más sencilla del Ejercicio 9 (Consultas Multitabla).
-- -- 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
CREATE TABLE listado_clientes_repre_ventas
  AS
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
;

SELECT *
  FROM listado_clientes_repre_ventas
  ;

-- DROP VIEW listado_clientes_repre_ventas;   -- Lo había creado como VISTA