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
  SELECT cli.nombre_contacto AS 'Nombre del cliente',       -- Nombre del contacto del cliente
         cli.apellido_contacto AS 'Apellido del cliente',
         
  ped.pk_pedido AS 'Código del pedido',
         ped.fecha_pedido AS 'Fecha del pedido',
         CONCAT(cli.nombre_contacto, ' ', cli.apellido_contacto) AS 'Nombre completo cliente',  -- Nombre del contacto del cliente
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


3. Crea una vista que se llame listado_pedidos_clientes que muestre un listado
donde aparezcan todos los clientes y los pedidos que ha realizado cada uno de
ellos. La vista deberá tener las siguientes columnas: código del cliente, nombre y
apellidos del cliente concatendados, teléfono, ciudad, pais, código del pedido,
fecha del pedido, fecha esperada y fecha de entrega.
4. Crea una variable de sesión denominada @ciudad. Utiliza la vista que ha creado
en el punto 2, para crear una consulta que muestre el listado de los clientes de la
ciudad de Madrid que han realizado pagos.
5. Cambia el valor de la variable @ciudad a Miami y repite la operación anterior.
6. Crea ocho vistas basadas en las consultas realizadas en el Ejercicio 9 (Consultas
Multitabla), cuatro de ellas con los ejercicios que hayas considerado más difíciles
de la Base de Datos de nómina y cuatro con los ejercicios que hayas considerado
más difíciles de la Base de Datos de jardinería.
7. Elimina la vista listado_pedidos_clientes de la Base de Datos jardineria.
8. Crea una nueva tabla con el resultado de la vista que te haya resultado más
sencilla del Ejercicio 9 (Consultas Multitabla).



/**************************************************************************/



/*******************************************/
/*** Composición interna (INNER JOIN) ******/
/*******************************************/
-- 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

DESCRIBE cliente;
SHOW CREATE TABLE cliente;
SELECT * FROM cliente;


SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
;


-- 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.

SELECT * FROM pago;

SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
;

-- Comprobación:
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas,
       pag.fecha_pago,
       pag.total
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
;


-- 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
 WHERE pag.fk_cliente IS NULL
;

-- Comprobación:
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas,
       pag.fecha_pago,
       pag.total
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
 WHERE pag.fk_cliente IS NULL
;


-- 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas,
       ofi.ciudad AS ciudad_oficina_representante
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
       JOIN oficina ofi
            ON emp.fk_oficina = ofi.pk_oficina
;


-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
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

-- Comprobación:
SELECT cli.nombre_cliente,
       CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS representante_ventas,
       ofi.ciudad AS ciudad_oficina_representante,
       pag.fecha_pago,
       pag.total
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
       JOIN oficina ofi
            ON emp.fk_oficina = ofi.pk_oficina              
 WHERE pag.fk_cliente IS NULL
;


-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT DISTINCT CONCAT_WS('. ', ofi.linea_direccion1, ofi.linea_direccion2, ofi.ciudad) AS direccion_oficina
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       JOIN oficina ofi
            ON emp.fk_oficina = ofi.pk_oficina
 WHERE cli.ciudad = 'Fuenlabrada'
;

-- Comprobación:
SELECT DISTINCT cli.nombre_cliente,
       cli.ciudad AS ciudad_cliente,
       ofi.ciudad AS ciudad_oficina_representante,
       CONCAT_WS('. ', ofi.linea_direccion1, ofi.linea_direccion2, ofi.ciudad) AS direccion_oficina
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       JOIN oficina ofi
            ON emp.fk_oficina = ofi.pk_oficina
 WHERE cli.ciudad = 'Fuenlabrada'            
;


-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT cli.nombre_cliente,
       CONCAT(emp.nombre, ' ', emp.apellido1, ' ', emp.apellido2) AS representante_ventas,
       ofi.ciudad AS ciudad_oficina_representante
  FROM cliente cli
       JOIN empleado emp
            ON cli.fk_representante_ventas = emp.pk_empleado
       JOIN oficina ofi
            ON emp.fk_oficina = ofi.pk_oficina
;



/*
El ejercicio 8, permite comparar filas dentro de la misma tabla generalmente
para extraer relaciones jerárquicas, por ejemplo, emparejar empleados con sus
respectivos gerentes. Para que funcione, es obligatorio usar alias de tabla (por
ejemplo, t1 y t2) para que el sistema distinga entre las dos instancias virtuales
de la misma tabla.
La siguiente consulta muestra, para cada empleado (de una tabla hipotética),
el nombre de su gerente.

SELECT e.nombre AS empleado,
       g.nombre AS gerente
  FROM empleados e
       LEFT JOIN empleados g
                 ON e.id_gerente = g.id
  ;

Intenta realizar el siguiente ejercicio usando como base el ejemplo anterior.
*/


-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT CONCAT(emp.nombre, ' ', emp.apellido1, ' ', emp.apellido2) AS empleado,
       CONCAT(jefe.nombre, ' ', jefe.apellido1, ' ', jefe.apellido2) AS jefe
  FROM empleado emp
       JOIN empleado jefe
            ON emp.fk_jefe = jefe.pk_empleado
;


-- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
SELECT DISTINCT cli.nombre_cliente
  FROM cliente cli
       JOIN pedido ped
            ON ped.fk_cliente = cli.pk_cliente
 WHERE ((ped.fecha_entrega IS NOT NULL AND ped.fecha_entrega > ped.fecha_esperada) OR
        (ped.fecha_entrega IS NULL AND ped.fecha_esperada < CURRENT_DATE())
       )
;

SELECT * FROM pedido;

SELECT cli.nombre_cliente,
       ped.fecha_entrega,
       ped.fecha_esperada
  FROM cliente cli
       JOIN pedido ped
            ON ped.fk_cliente = cli.pk_cliente
 WHERE ((ped.fecha_entrega IS NOT NULL AND ped.fecha_entrega > ped.fecha_esperada) OR
        (ped.fecha_entrega IS NULL AND ped.fecha_esperada < CURRENT_DATE())
       )
;


-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
SELECT DISTINCT cli.nombre_cliente,
       gam.gama
  FROM cliente cli
       JOIN pedido ped
            ON ped.fk_cliente = cli.pk_cliente
       JOIN detalle_pedido det
            ON det.fk_pedido = ped.pk_pedido
       JOIN producto prod
            ON prod.pk_producto = det.fk_producto
       JOIN gama_producto gam
            ON gam.pk_gama = prod.fk_gama
ORDER BY cli.nombre_cliente,
         gam.gama            
  ;
       
       
       


/************************************************************/
/*** Composición externa ( LEFT JOIN, RIGHT JOIN ) **********/
/************************************************************/

-- 11. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT DISTINCT cli.nombre_cliente
  FROM cliente cli
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
 WHERE pag.fk_cliente IS NULL
;

-- 12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
SELECT DISTINCT cli.nombre_cliente
  FROM cliente cli
       LEFT JOIN pedido ped
            ON cli.pk_cliente = ped.fk_cliente
 WHERE ped.fk_cliente IS NULL
;


-- 13. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
SELECT DISTINCT cli.nombre_cliente
  FROM cliente cli
       LEFT JOIN pago pag
            ON cli.pk_cliente = pag.fk_cliente
       LEFT JOIN pedido ped
            ON cli.pk_cliente = ped.fk_cliente            
 WHERE pag.fk_cliente IS NULL
   AND ped.fk_cliente IS NULL
;


-- 14. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
SELECT DISTINCT CONCAT(emp.nombre, ' ', emp.apellido1, ' ', emp.apellido2) AS empleado
  FROM empleado emp
       LEFT JOIN oficina ofi
                 ON ofi.pk_oficina = emp.fk_oficina
 WHERE ofi.pk_oficina IS NULL
;                       -- NOTA: no hay ningún empleado sin oficina asignada ya que "fk_oficina" está restringido a NOT NULL

SELECT * FROM empleado WHERE fk_oficina IS NULL;
SHOW CREATE TABLE empleado;


-- 15. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
SELECT DISTINCT CONCAT(emp.nombre, ' ', emp.apellido1, ' ', emp.apellido2) AS empleado
  FROM empleado emp
       LEFT JOIN cliente cli
                 ON cli.fk_representante_ventas = emp.pk_empleado
 WHERE cli.fk_representante_ventas IS NULL
;


-- 16. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan. 
SELECT DISTINCT CONCAT(emp.nombre, ' ', emp.apellido1, ' ', emp.apellido2) AS empleado,
       ofi.*
  FROM empleado emp
       LEFT JOIN cliente cli
                 ON cli.fk_representante_ventas = emp.pk_empleado
       JOIN oficina ofi
            ON ofi.pk_oficina = emp.fk_oficina                 
 WHERE cli.fk_representante_ventas IS NULL
;


-- 17. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.
SELECT DISTINCT CONCAT(emp.nombre, ' ', emp.apellido1, ' ', emp.apellido2) AS empleado
  FROM empleado emp
       LEFT JOIN cliente cli
                 ON cli.fk_representante_ventas = emp.pk_empleado
       LEFT JOIN oficina ofi
            ON ofi.pk_oficina = emp.fk_oficina                 
 WHERE cli.fk_representante_ventas IS NULL
   AND ofi.pk_oficina IS NULL
;           -- NOTA: no hay ningún empleado sin oficina asignada ya que "fk_oficina" está restringido a NOT NULL, con lo que no hay casos de empleados sin oficina asignada y que a su vez no tengan cliente asociado


-- 18. Devuelve un listado de los productos que nunca han aparecido en un pedido.
  SELECT prod.pk_producto, prod.nombre      -- NOTA: muestro el "pk_producto" ya que hay casos de productos con el mismo nombre (p.ej. Albaricoquero) con distintos pk_producto (p.ej. FR_59, FR_61, FR_62)
    FROM pedido ped
         JOIN detalle_pedido det
              ON det.fk_pedido = ped.pk_pedido
         RIGHT JOIN producto prod
              ON prod.pk_producto = det.fk_producto
   WHERE det.fk_producto IS NULL
ORDER BY prod.pk_producto
;

       
-- 19. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.
  SELECT DISTINCT prod.nombre,
         prod.descripcion
         -- NOTA: no hay imagen del producto
    FROM pedido ped
         JOIN detalle_pedido det
              ON det.fk_pedido = ped.pk_pedido
         RIGHT JOIN producto prod
              ON prod.pk_producto = det.fk_producto
   WHERE det.fk_producto IS NULL
ORDER BY prod.nombre
;


-- 20. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
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

/*
-- +++++++++++++++++ PROBAR SI FUNCIONA ESTA QUERY --> NO ++++++++++++++++
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
        JOIN oficina ofi_frutales
             ON ofi_frutales.pk_oficina = emp.fk_oficina
        RIGHT JOIN oficina ofi
             ON ofi.pk_oficina = ofi_frutales.pk_oficina
  WHERE gam.gama = 'Frutales'
    AND ofi_frutales.pk_oficina IS NULL
  ;  
*/

-- 21. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
SELECT DISTINCT cli.nombre_cliente      -- NOTA: el DISTINCT es para no repetir los clientes que tengan varios pedidos y que todos ellos estén sin realizar el pago
  FROM cliente cli
       JOIN pedido ped
            ON ped.fk_cliente = cli.pk_cliente
       LEFT JOIN pago pag
            ON pag.fk_cliente = cli.pk_cliente
 WHERE pag.fk_cliente IS NULL
;

/*
SELECT *
  FROM pago
 WHERE fk_cliente = 36;
*/


-- 22. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
   SELECT emp.*,
          CONCAT(jefe.nombre, ' ', jefe.apellido1, ' ', jefe.apellido2) AS jefe
     FROM empleado emp
          JOIN empleado jefe
               ON jefe.pk_empleado = emp.fk_jefe
          LEFT JOIN cliente cli
                    ON cli.fk_representante_ventas = emp.pk_empleado
    WHERE cli.fk_representante_ventas IS NULL 
 ORDER BY emp.pk_empleado
;

