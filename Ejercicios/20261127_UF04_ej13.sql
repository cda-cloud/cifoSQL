/**************************************************************************/
/***** Ejercicio 13. Subconsultas *****************************************/
/**************************************************************************/



/*******************************************/
/*** Usando la Base de Datos jardineria: ***/
/*******************************************/
USE jardineria;

/**********************************************************/
/*** Subconsultas con operadores básicos de comparación ***/
/**********************************************************/
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT cli.nombre_cliente
  FROM cliente cli
 WHERE cli.limite_credito = (SELECT MAX(c.limite_credito)
                               FROM cliente c
                            )
;


-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT prod.nombre
  FROM producto prod
 WHERE prod.precio_venta = (SELECT MAX(p.precio_venta)
                              FROM producto p
                           )
;


-- 3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en
--      cuenta que tendrá que calcular cuál es el número total de unidades que se han
--      vendido de cada producto a partir de los datos de la tabla detalle_pedido)
SELECT prod.nombre       
  FROM producto prod
 WHERE prod.pk_producto = (  SELECT p.pk_producto
                               FROM producto p
                                    JOIN detalle_pedido det
                                         ON det.fk_producto = p.pk_producto
                           GROUP BY p.pk_producto
                           ORDER BY SUM(det.cantidad) DESC
                           LIMIT 1
                          )
;

  SELECT p.pk_producto,
         SUM(det.cantidad) as ventas
    FROM producto p
         JOIN detalle_pedido det
              ON det.fk_producto = p.pk_producto
GROUP BY p.pk_producto
ORDER BY SUM(det.cantidad) DESC
;

SELECT p.nombre
  FROM producto p
 WHERE p.pk_producto = 'AR-009'
;
-- nombre del producto con más ventas: 'Thymus Vulgaris' 


-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
SELECT * FROM (
SELECT cli.pk_cliente,
       cli.limite_credito,       
       (
          SELECT SUM(pag.total)
            FROM pago pag
           WHERE cli.pk_cliente = pag.fk_cliente
        GROUP BY pag.fk_cliente
       ) AS total_pagos
  FROM cliente cli
) A
  WHERE limite_credito > total_pagos  
;

-- Utilizando JOIN para comprobar si el resultado es correcto:
SELECT cli.pk_cliente,
       cli.limite_credito,
       p.total_pagos
  FROM cliente cli
  JOIN (
          SELECT pag.fk_cliente,
                 SUM(pag.total) as total_pagos
            FROM pago pag
        GROUP BY pag.fk_cliente
       ) p ON cli.pk_cliente = p.fk_cliente
 WHERE cli.limite_credito > p.total_pagos  
;


-- 5. Devuelve el producto que más unidades tiene en stock.
SELECT prod.*
  FROM producto prod
 WHERE prod.cantidad_en_stock = (SELECT MAX(p.cantidad_en_stock)        -- NOTA: hay 35 productos que tienen cantidad en stock máxima
                                   FROM producto p
                                )
;
  
-- La cantidad en stock máxima es de 400 unidades:
SELECT MAX(p.cantidad_en_stock)
  FROM producto p
;


-- 6. Devuelve el producto que menos unidades tiene en stock.
SELECT prod.*
  FROM producto prod
 WHERE prod.cantidad_en_stock = (SELECT MIN(p.cantidad_en_stock)        -- NOTA: hay 1 úninco producto con cantidad_en_stock mínima (0 unidades en stock)
                                   FROM producto p
                                )
;
  
-- La cantidad en stock mínima es de 0 unidades:
SELECT MIN(p.cantidad_en_stock)
  FROM producto p
;


-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
SELECT CONCAT_WS(' ', e.nombre, e.apellido1, e.apellido2) AS nombre_completo,
       e.email
  FROM empleado e
 WHERE e.fk_jefe = (SELECT emp.pk_empleado
                      FROM empleado emp
                     WHERE emp.nombre = 'Alberto'
                       AND emp.apellido1 = 'Soria'
                   )
;

-- Query para buscar 'Alberto Soria':
SELECT emp.*
  FROM empleado emp
 WHERE emp.nombre = 'Alberto'
   AND emp.apellido1 = 'Soria'
;  




/**********************************************************/
/*** Subconsultas con ALL y ANY ***************************/
/**********************************************************/

-- 8. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT cli.nombre_cliente
  FROM cliente cli
 WHERE cli.limite_credito >= ALL (SELECT c.limite_credito       -- NOTA: utilizando "ALL", no hace falta poner MAX(c.limite_credito) en la subquery
                                    FROM cliente c
                                 )
;

-- Comprobación:
SELECT MAX(c.limite_credito)
  FROM cliente c
;   -- el máximo es 600000.00

SELECT cli.nombre_cliente
  FROM cliente cli
 WHERE cli.limite_credito = 600000.00
; 


-- 9. Devuelve el nombre del producto que tenga el precio de venta más caro.
-- 10. Devuelve el producto que menos unidades tiene en stock.

/**********************************************************/
/*** Subconsultas con IN y NOT IN *************************/
/**********************************************************/

-- 11. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
-- 12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
-- 13. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
-- 14. Devuelve un listado de los productos que nunca han aparecido en un pedido.
-- 15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
-- 16. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas 
--      de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
-- 17. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.


/**********************************************************/
/*** Subconsultas con EXISTS y NOT EXISTS *****************/
/**********************************************************/
-- 18. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
-- 19. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
-- 20. Devuelve un listado de los productos que nunca han aparecido en un pedido.
-- 21. Devuelve un listado de los productos que han aparecido en un pedido alguna vez. Common Table Expressions (WITH)
-- 22. Elige dos subconsultas que se encuentren en la cláusula FROM y reescribelas utilizando la sintaxis moderna (con una CTE).


