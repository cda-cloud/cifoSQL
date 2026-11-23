/*************************************************************/
/***** Ejercicio 9. Consultas Multitabla *********************/
/*************************************************************/

/*** Utilizando la Base de Datos Nómina: ***/
USE nominas;

DESCRIBE empleado;

DESCRIBE departamento;

DESCRIBE cargo;

/*******************************************/
/*** Composición interna (INNER JOIN) ******/
/*******************************************/

-- 1. Lista el nombre y apellido de los empleados, su sueldo y el nombre del departamento donde trabaja.
SELECT emp.nombre,
       emp.apellido,
       emp.sueldo,
       dpt.departamento
  FROM empleado emp
       INNER JOIN departamento dpt ON emp.fk_departamento = dpt.pk_departamento
;


-- 2. Lista el nombre y apellido de los empleados, su fecha de contrato y el nombre del cargo.
SELECT emp.nombre,
       emp.apellido,
       emp.fecha_contrato,
       car.cargo
  FROM empleado emp
       INNER JOIN cargo car ON emp.fk_cargo = car.pk_cargo
;


-- 3. Ordena el resultado por la fecha de contrato.
  SELECT emp.nombre,
         emp.apellido,
         emp.fecha_contrato,
         car.cargo
    FROM empleado emp
         INNER JOIN cargo car ON emp.fk_cargo = car.pk_cargo
ORDER BY emp.fecha_contrato
;


-- 4. Lista el código del empleado, su nombre y apellido, el código del departameto y el nombre del departamento de los empleados que ganen más de 2000€.
  SELECT emp.pk_empleado,
         emp.nombre,
         emp.apellido,
         dpt.pk_departamento,
         dpt.departamento
    FROM empleado emp
         INNER JOIN departamento dpt ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.sueldo > 20000     -- NOTA: filtramos por 20000 porque entiendo que es un gazapo de escritura (todos cobran más de 2000 de sueldo)
  ;

-- Comprobación:
  SELECT emp.pk_empleado,
         emp.nombre,
         emp.apellido,
         dpt.pk_departamento,
         dpt.departamento,
         emp.sueldo
    FROM empleado emp
         INNER JOIN departamento dpt ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.sueldo > 20000     -- NOTA: filtramos por 20000 porque entiendo que es un gazapo de escritura (todos cobran más de 2000 de sueldo)
ORDER BY emp.sueldo
  ;


-- 5. Indica el nombre, apellido y nombre del cargo del empleado más joven.
  SELECT emp.nombre,
         emp.apellido,
         car.cargo
    FROM empleado emp
         INNER JOIN cargo car ON emp.fk_cargo = car.pk_cargo
ORDER BY emp.fecha_nacimiento DESC          -- El empleado más joven es el que tenga la fecha de nacimiento más reciente
   LIMIT 1
  ;

-- Comprobación:
  SELECT emp.nombre,
         emp.apellido,
         car.cargo,
         emp.fecha_nacimiento
    FROM empleado emp
         INNER JOIN cargo car ON emp.fk_cargo = car.pk_cargo
ORDER BY emp.fecha_nacimiento DESC   
  ;


-- 6. Indica el nombre, apellido y nombre del departamento de los empleados que tengan hijos.
  SELECT emp.nombre,
         emp.apellido,
         dpt.departamento
    FROM empleado emp
         INNER JOIN departamento dpt ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.hijos >= 1
  ;

-- Comprobación:
  SELECT emp.nombre,
         emp.apellido,
         dpt.departamento,
         emp.hijos
    FROM empleado emp
         INNER JOIN departamento dpt ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.hijos >= 1
  ;


-- 7. Lista todos los datos de los empleados de Contabilidad.
  SELECT emp.*
    FROM empleado emp
         INNER JOIN departamento dpt ON emp.fk_departamento = dpt.pk_departamento
   WHERE dpt.departamento = 'Contabilidad'
  ;

-- Comprobación:
  SELECT emp.*,
         dpt.departamento
    FROM empleado emp
         INNER JOIN departamento dpt ON emp.fk_departamento = dpt.pk_departamento
   WHERE (dpt.departamento = 'Contabilidad' OR emp.fk_departamento = 3)
  ;


-- 8. Lista el nombre y apellido del empleado, el nombre del cargo y el del departamento de los empleados solteros sin hijos
  SELECT emp.nombre,
         emp.apellido,
         car.cargo,
         dpt.departamento
    FROM empleado emp
         INNER JOIN cargo car 
                    ON emp.fk_cargo = car.pk_cargo
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.estado_civil = 'Soltero'
     AND emp.hijos = 0
  ;

-- Comprobación:
  SELECT emp.nombre,
         emp.apellido,
         car.cargo,
         dpt.departamento,
         emp.estado_civil,
         emp.hijos
    FROM empleado emp
         INNER JOIN cargo car 
                    ON emp.fk_cargo = car.pk_cargo
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.estado_civil = 'Soltero'
     AND emp.hijos = 0
  ;


-- 9. Lista los empleados de los departamentos de Compras y Ventas sin utilizar el operador IN.
  SELECT emp.nombre,
         emp.apellido
    FROM empleado emp
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE (dpt.departamento = 'Compras' OR dpt.departamento = 'Ventas')
  ;

-- Comprobación:
  SELECT emp.nombre,
         emp.apellido,
         dpt.departamento
    FROM empleado emp
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE (dpt.departamento = 'Compras' OR dpt.departamento = 'Ventas')
  ;


-- 10. Lista los empleados de los departamentos de Compras y Ventas utilizando el operador IN.
  SELECT emp.nombre,
         emp.apellido
    FROM empleado emp
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE dpt.departamento IN ('Compras', 'Ventas')
  ;

-- Comprobación:
  SELECT emp.nombre,
         emp.apellido,
         dpt.departamento
    FROM empleado emp
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE dpt.departamento IN ('Compras', 'Ventas')
  ;


-- 11. Lista el nombre y apellido del empleado, el nombre del cargo y del departamento de aquellas personas que tienen más de 20 años en la empresa. 
--      Ordena el resultado en primer lugar por el departamento (en orden ascendente) y en segundo lugar por el tiempo trabajado (en orden descendente)
  SELECT emp.nombre,
         emp.apellido,
         car.cargo,
         dpt.departamento
    FROM empleado emp
         INNER JOIN cargo car 
                    ON emp.fk_cargo = car.pk_cargo
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE DATEDIFF(CURRENT_DATE(), emp.fecha_contrato)/365 > 20          -- FLOOR(DATEDIFF(CURDATE(),birth_date) / 365)
   -- WHERE FLOOR(DATEDIFF(CURDATE(), emp.fecha_contrato) / 365) > 20     -- NOTA: con esta opción, usando FLOOR, un empleado con 20.3 años se filtraría y no aparecería en el resultado
  ;

-- Comprobación:
  SELECT emp.nombre,
         emp.apellido,
         car.cargo,
         dpt.departamento,
         emp.fecha_contrato,
         CURRENT_DATE() AS hoy,
         DATEDIFF(CURRENT_DATE(), emp.fecha_contrato) AS diferencia_fechas,
         DATEDIFF(CURRENT_DATE(), emp.fecha_contrato)/365 AS diferencia_fechas_en_anyos
    FROM empleado emp
         INNER JOIN cargo car 
                    ON emp.fk_cargo = car.pk_cargo
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE DATEDIFF(CURRENT_DATE(), emp.fecha_contrato)/365 > 20
   -- WHERE FLOOR(DATEDIFF(CURDATE(), emp.fecha_contrato) / 365) > 20     -- NOTA: con esta opción, usando FLOOR, un empleado con 20.3 años se filtraría y no aparecería en el resultado
  ;


-- 12. Lista nombre y apellido, edad, nombre del cargo, nombre del departamento de los empleados Solteros, Divorciados o Viudos que tengan más de un hijo. 
  SELECT emp.nombre,
         emp.apellido,
         'fecha_nacimiento',
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

-- Comprobación:
  SELECT emp.nombre,
         emp.apellido,
         car.cargo,
         dpt.departamento,
         emp.estado_civil,
         emp.hijos
    FROM empleado emp
         INNER JOIN cargo car 
                    ON emp.fk_cargo = car.pk_cargo
         INNER JOIN departamento dpt 
                    ON emp.fk_departamento = dpt.pk_departamento
   WHERE emp.estado_civil IN ('Soltero', 'Divorciado', 'Viudo')
     AND emp.hijos >= 2
  ;




/*****************************************************/
/*** Composición externa ( LEFT JOIN, RIGHT JOIN ) ***/
/*****************************************************/

-- 13. Lista todos departamentos registrados que existen en la base de datos, 
--      junto con el código, nombre y apellido del empleado que tiene cada uno de ellos. 
--      El listado deberá mostrar también aquellos departamentos que no tienen empleados asociados.
  SELECT dpt.departamento,
         emp.pk_empleado,
         emp.nombre,
         emp.apellido         
    FROM departamento dpt
         LEFT JOIN  empleado emp
                    ON dpt.pk_departamento = emp.fk_departamento
ORDER BY dpt.departamento,
         emp.fk_departamento
  ;


-- 14. Lista todos cargos registrados que existen en la base de datos, junto con el nombre y apellido del empleado, 
--      la edad y estado civil que tiene cada empleado. El listado deberá mostrar también aquellos cargos que no tienen empleados asociados.
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

-- Comprobación:
  SELECT car.cargo,
         emp.nombre,
         emp.apellido,
         FLOOR(DATEDIFF(CURDATE(), emp.fecha_nacimiento) / 365) AS edad,
         emp.estado_civil,
         emp.fecha_nacimiento,
         CURRENT_DATE() AS hoy,
         DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento) AS diferencia_fechas,
         DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365 AS diferencia_fechas_en_anyos
    FROM cargo car
         LEFT  JOIN empleado emp
                    ON car.pk_cargo = emp.fk_cargo
ORDER BY car.cargo,             -- NOTA: ordeno alfabéticamente por cargo, nombre, apellido
         emp.nombre,
         emp.apellido
  ;


-- 15. Lista los departamentos sin empleados asociados.
  SELECT dpt.departamento     
    FROM departamento dpt
         LEFT JOIN  empleado emp
                    ON dpt.pk_departamento = emp.fk_departamento
   WHERE emp.fk_departamento IS NULL
ORDER BY dpt.departamento
  ;

-- Comprobación:
  SELECT dpt.departamento,
         emp.fk_departamento  
    FROM departamento dpt
         LEFT JOIN  empleado emp
                    ON dpt.pk_departamento = emp.fk_departamento
ORDER BY emp.fk_departamento        -- NOTA: En MySQL no hay el "NULLS FIRTS", pero ordenando ASC ya pone primero los NULLs
  ;


-- 16. ¿Se puede asignar a un empleado un cargo que no esté registrado en la tabla de cargos? Justifica tu respuesta.

-- -- No se puede asignar un cargo que no existe en la tabla de cargos a un empleado porque dará error por la FK

INSERT INTO empleado (pk_empleado, apellido, nombre, sexo, fecha_nacimiento, fecha_contrato, sueldo, fk_cargo) 
              VALUES  (61, 'ape1', 'nom1', 'Hombre', CURRENT_DATE(), CURRENT_DATE(), 200, 25)
              ;
-- ERROR --> MySQL Error (1452): Cannot add or update a child row: a foreign key constraint fails (`nominas`.`empleado`, CONSTRAINT `cargos_empleados` FOREIGN KEY (`fk_cargo`) REFERENCES `cargo` (`pk_cargo`) ON DELETE RESTRICT ON UPDATE CASCADE)              


-- SHOW CREATE TABLE empleado;
-- SELECT * FROM empleado ORDER BY pk_empleado DESC;
-- SELECT * FROM cargo ORDER BY pk_cargo DESC;







/************************************************/
/*** Utilizando la Base de Datos Jardinería:: ***/
/************************************************/

USE jardineria;

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


-- +++++++++++++++++ PDTE PROBAR SI FUNCIONA ESTA QUERY ++++++++++++++++
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


21. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
22. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.