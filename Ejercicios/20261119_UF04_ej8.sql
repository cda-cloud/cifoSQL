/*************************************************************/
/***** Ejercicio 8. Realización de consultas simples SQL *****/
/*************************************************************/

/*** Utilizando la Base de Datos Jardinería (en la sección Bases de Datos de la UF04): ***/
USE jardineria;



-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas. 
  SELECT pk_oficina,
         ciudad
    FROM oficina
    -- WHERE ciudad IS NOT NULL    -- No es necesario el filtro porque el campo "ciudad" tiene NOT NULL la tabla
ORDER BY pk_oficina
  ;


-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España. 
  SELECT pk_oficina,
         telefono
    FROM oficina
   WHERE pais = 'España'
ORDER BY pk_oficina
  ;


-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7. 
SELECT nombre,
       apellido1,
       apellido2,
       email
  FROM empleado
 WHERE fk_jefe = 7
  ;


-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa. 
SELECT puesto,
       nombre,
       apellido1,
       apellido2,
       email
  FROM empleado
 WHERE fk_jefe IS NULL  -- El jefe de la empresa es el empleado que no tiene informado el campo fk_jefe
  ;


-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
SELECT nombre,
       apellido1,
       apellido2,
       puesto
  FROM empleado
 WHERE puesto <> 'Representante Ventas'
  ;


-- 6. Devuelve un listado con el nombre de los todos los clientes españoles. 
SELECT DISTINCT nombre_cliente          -- NOTA: uso DISTINCT porque el cliente con nombre "Lasas S.A." está 2 veces en la tabla: con pk_cliente = 6 y con pk_cliente = 12
           FROM cliente
          WHERE pais = 'Spain'          -- El país está informado como 'Spain' en vez de 'España'
  ;


-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido. 
SELECT DISTINCT estado
           FROM pedido
           ;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008. Ten en cuenta que no deberás mostrar aquellos códigos de cliente que aparezcan repetidos. Resuelve la consulta: 
-- -- Utilizando la función YEAR de MySQL. 
SELECT DISTINCT fk_cliente              -- NOTA: el cliente con fk_cliente = 1 ha realizado 2 pagos en 2008 por el mismo importe total (id_transaccion = 'ak-std-000001' y con id_transaccion = 'ak-std-000002')
           FROM pago
          WHERE YEAR(fecha_pago) = 2008
  ;


SELECT *
  FROM pago
 WHERE YEAR(fecha_pago) = 2008
  ;


-- -- Utilizando la función DATE_FORMAT de MySQL.
SELECT DISTINCT fk_cliente
           FROM pago
          WHERE DATE_FORMAT(fecha_pago, "%Y") = 2008
  ;

-- -- Sin utilizar ninguna de las funciones anteriores. 
SELECT DISTINCT fk_cliente
           FROM pago
          WHERE fecha_pago LIKE '%2008%'
  ;

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo. 
SELECT pk_pedido,
       fk_cliente,
       fecha_esperada,
       fecha_entrega
  FROM pedido
 WHERE fecha_esperada >= fecha_entrega      -- NOTA: que no se entregue a tiempo implica que se entrega en la fecha esperada o antes de la fecha esperada
   -- AND fecha_entrega IS NOT NULL
  ;


-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada. 
-- -- Utilizando la función ADDDATE de MySQL. 
SELECT pk_pedido,
       fk_cliente,
       fecha_esperada,
       fecha_entrega
  FROM pedido
 WHERE fecha_esperada >= ADDDATE(fecha_entrega, INTERVAL 2 DAY)  -- mayor o igual porque dice "al menos" 2 días antes de la fecha esperada
   -- AND fecha_entrega IS NOT NULL
  ;


-- -- Utilizando la función DATEDIFF de MySQL. 
SELECT pk_pedido,
       fk_cliente,
       fecha_esperada,
       fecha_entrega
  FROM pedido
 WHERE DATEDIFF(fecha_esperada, fecha_entrega) >= 2  -- mayor o igual porque dice "al menos" 2 días antes de la fecha esperada
   -- AND fecha_entrega IS NOT NULL
  ;


-- -- ¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -?

-- RESPUESTA: no es posible, ya que los días de una fecha no son consecutivos. Es decir, entre el 30 de enero y el 1 de febrero hay 2 días, pero:
-- -- SELECT DATE_FORMAT("20260201", "%Y%m%d")-2 FROM DUAL;
-- -- Esta query devuelve la fecha "20260199" y el día "99" no es un día válido.


-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009. 
  SELECT pk_pedido
    FROM pedido
   WHERE estado = 'Rechazado'
     AND ((fecha_entrega IS NOT NULL AND YEAR(fecha_entrega) = 2009) OR
          YEAR(fecha_esperada) = 2009
         )
ORDER BY pk_pedido
  ;

-- Comprobación:
  SELECT pk_pedido,
         fk_cliente,
         fecha_pedido,
         fecha_esperada,
         fecha_entrega,
         estado,
         comentarios
    FROM pedido
   WHERE estado = 'Rechazado'
     AND ((fecha_entrega IS NOT NULL AND YEAR(fecha_entrega) = 2009) OR
          YEAR(fecha_esperada) = 2009
         )
ORDER BY pk_pedido
  ;


-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.
  SELECT pk_pedido
    FROM pedido
   WHERE MONTH(fecha_entrega) = '01'
ORDER BY pk_pedido
  ;

-- Comprobación:
  SELECT pk_pedido,
         fk_cliente,
         fecha_pedido,
         fecha_esperada,
         fecha_entrega
    FROM pedido
   WHERE MONTH(fecha_entrega) = '01'
ORDER BY pk_pedido
  ;

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordena el resultado de mayor a menor.
  SELECT id_transaccion
    FROM pago
   WHERE forma_pago = 'Paypal'
     AND YEAR(fecha_pago) = 2008
ORDER BY id_transaccion DESC
  ;

-- Comprobación:
  SELECT id_transaccion,
         forma_pago,
         fecha_pago
    FROM pago
   WHERE forma_pago = 'Paypal'
     AND YEAR(fecha_pago) = 2008
ORDER BY id_transaccion DESC
  ;


-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. 
--     Tenga en cuenta que no deben aparecer formas de pago repetidas. 
SELECT DISTINCT forma_pago
           FROM pago
  ;


-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales 
--     y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por 
--     su precio de venta, mostrando en primer lugar los de mayor precio. 
  SELECT pk_producto,
         nombre
    FROM producto
   WHERE fk_gama = 5              -- La gama de "Ornamentales" tiene el valor 5 en la tabla "gama_producto"
     AND cantidad_en_stock > 100
ORDER BY precio_venta DESC        -- Ordenación para que en primer lugar se muestren los de mayor precio
  ;



-- Comprobación:
  SELECT pk_producto,
         nombre,
         precio_venta
    FROM producto
   WHERE fk_gama = 5              -- La gama de "Ornamentales" tiene el valor 5 en la tabla "gama_producto"
     AND cantidad_en_stock > 100
ORDER BY precio_venta DESC        -- Ordenación para que en primer lugar se muestren los de mayor precio
  ;

-- Comprobar que los productos cuyo pk_producto empieza por 'OR' tengan todos la fk_gama = 5 (por si alguno de los que empieza por 'OR%' tuviera la fk_gama incorrecta)
SELECT DISTINCT fk_gama
  FROM producto
 WHERE pk_producto LIKE 'OR%'  
  ;


-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante 
--     de ventas tenga el código de empleado 11 o 30.
SELECT pk_cliente,
       nombre_cliente
  FROM cliente
 WHERE ciudad = 'Madrid'
   AND fk_representante_ventas IN (11, 30)
   ;

-- Comprobación:
SELECT pk_cliente,
       nombre_cliente,
       ciudad,
       fk_representante_ventas
  FROM cliente
 WHERE ciudad = 'Madrid'
   AND fk_representante_ventas IN (11, 30)
   ;
