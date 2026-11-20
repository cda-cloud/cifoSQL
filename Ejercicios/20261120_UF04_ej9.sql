/*************************************************************/
/***** Ejercicio 9. Consultas Multitabla *********************/
/*************************************************************/

/*** Utilizando la Base de Datos Nómina: ***/
USE nominas;

-- DESCRIBE empleado;

/*** Composición interna (INNER JOIN) ******/

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
   WHERE DATEDIFF(CURRENT_DATE(), emp.fecha_contrato)/365 > 20          -- FLOOR(DATEDIFF(CURDATE(),birth_date) / 365)
  ;


-- 12. Lista nombre y apellido, edad, nombre del cargo, nombre del departamento de los empleados Solteros, Divorciados o Viudos que tengan más de un hijo. 
  SELECT emp.nombre,
         emp.apellido,
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




/*** Composición externa ( LEFT JOIN, RIGHT JOIN ) ***/
13. Lista todos departamentos registrados que existen en la base de datos, junto con el código, nombre y apellido del empleado que tiene cada uno de ellos. El listado deberá mostrar también aquellos departamentos que no tienen empleados asociados.
14. Lista todos cargos registrados que existen en la base de datos, junto con el nombre y apellido del empleado, la edad y estado civil que tiene cada empleado. El listado deberá mostrar también aquellos cargos que no tienen empleados asociados.
15. Lista los departamentos sin empleados asociados.
16. ¿Se puede asignar a un empleado un cargo que no esté registrado en la tabla de cargos? Justifica tu respuesta.




/*** Utilizando la Base de Datos Jardinería:: ***/
USE jardineria;


Composición interna (INNER JOIN)
1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.

El ejercicio 8, permite comparar filas dentro de la misma tabla generalmente
para extraer relaciones jerárquicas, por ejemplo, emparejar empleados con sus
respectivos gerentes. Para que funcione, es obligatorio usar alias de tabla (por
ejemplo, t1 y t2) para que el sistema distinga entre las dos instancias virtuales
de la misma tabla.
La siguiente consulta muestra, para cada empleado (de una tabla hipotética),
el nombre de su gerente.
SELECT
e.nombre AS empleado,
g.nombre AS gerente
FROM
empleados e
LEFT JOIN
empleados g
ON
e.id_gerente = g.id;
Intenta realizar el siguiente ejercicio usando como base el ejemplo anterior.


8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.


/*** Composición externa ( LEFT JOIN, RIGHT JOIN ) **********/

11. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
13. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
14. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
15. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
16. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan. 
17. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.
18. Devuelve un listado de los productos que nunca han aparecido en un pedido.
19. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.
20. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
21. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
22. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.