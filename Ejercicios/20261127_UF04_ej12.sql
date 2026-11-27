/**************************************************************************/
/***** Ejercicio 12. Operaciones de Conjunto ******************************/
/**************************************************************************/


/*******************************************/
/*** Usando la Base de Datos jardineria: ***/
/*******************************************/
USE jardineria;



-- 1. Crea la siguiente consulta de UNION con la tabla de cliente, empleado y oficina.
--      La consulta deberá tener los siguientes campos: inicial, id, contacto, tipo, teléfono.
--      -- El campo inicial será la inicial del apellido
--      -- El campo id será el pk del cliente/empleado. Usa la función LPAD() para rellenar con ceros a la izquierda
--      -- El campo contacto será la concatenación del nombre + el (los) apellidos
--      -- El campo tipo será un valor literal que indique el tipo de contacto “cliente” o “empleado”.
--      -- El campo teléfono viene de la tabla cliente u oficina según el origen de datos.
--      La consulta deberá ordenarse por el apellido.
--      Ejemplo de salida:
--          inicial id  contacto                tipo        telefono
--          B       030 Julian Bellinelli       empleado    +61 2 9264 2451
--          B       007 Jose Bermejo            cliente     654987321
--          B       018 Michael Bolton          empleado    +1 650 219 4782
--          C       009 Lucio Campoamor Martín  empleado    +34 91 7514487
--          C       018 Victoria Cruz           cliente     612343529
--          …
--  Guarda la consulta como una vista, con el nombre vista_contactos.
DESCRIBE cliente;
DESCRIBE empleado;

CREATE OR REPLACE VIEW vista_contactos
  AS 
    SELECT a.inicial,
           a.id,
           a.contacto,
           a.tipo,
           a.telefono
      FROM (
            SELECT UPPER(LEFT(cli.apellido_contacto, 1)) AS inicial,
                   LPAD(cli.pk_cliente, 3, 0) AS id,
                   CONCAT_WS(' ', cli.nombre_contacto, cli.apellido_contacto) AS contacto,
                   'cliente' AS tipo,
                   cli.telefono AS telefono,
                   cli.apellido_contacto AS orden
              FROM cliente cli
            UNION
            SELECT UPPER(LEFT(emp.apellido1, 1)) AS inicial,
                   LPAD(emp.pk_empleado, 3, 0) AS id,
                   CONCAT_WS(' ', emp.nombre, emp.apellido1, emp.apellido2) AS contacto,
                   'empleado' AS tipo,
                   ofi.telefono AS telefono,
                   CONCAT_WS(' ', emp.apellido1, emp.apellido2) AS orden
              FROM empleado emp
                   LEFT JOIN oficina ofi
                             ON emp.fk_oficina = ofi.pk_oficina
            ) a
    ORDER BY a.orden
    ;

SELECT *
  FROM vista_contactos
  ;


-- 2. Usando el campo fk_cliente y una de las consultas de operaciones de conjunto (UNION,
--      INTERCEPT, EXCEPT), genera una lista de códigos de clientes que hayan hecho pedidos que
--      estén entregados y no tengan pagos. Guarda esta consulta como una vista con el
--      nombre clientes_morosos.


CREATE OR REPLACE VIEW clientes_morosos
  AS
SELECT DISTINCT ped.fk_cliente AS cliente       -- NOTA: uso DISTINCT porque el cliente podría haber hecho varios pedidos
  FROM pedido ped
 WHERE ped.estado = 'Entregado'
EXCEPT
SELECT DISTINCT pag.fk_cliente AS cliente       -- NOTA: uso DISTINCT porque el cliente podría tener varios pedidos sin pagar, aunque no es necesario porque sólo afecta cuando tiene varios pedidos y 
  FROM pago pag
  ;

SELECT *
  FROM clientes_morosos
;  

-- También se puede obtener utilizando NOT EXISTS de la siguiente forma:
SELECT DISTINCT ped.fk_cliente AS cliente
  FROM pedido ped
 WHERE ped.estado = 'Entregado'
 AND NOT EXISTS(
                SELECT pag.fk_cliente
                  FROM pago pag
                 WHERE pag.fk_cliente = ped.fk_cliente
               )  
;


-- NOTA:
    -- Hay registros con estado = 'Entregado' que no tienen la fecha_entrega informada
    -- Hay registros con la fecha_entrega informada pero con el estado <> 'Entregado'
SELECT *
  FROM pedido
 WHERE (fecha_entrega IS NOT NULL OR estado = 'Entregado')      
 ;

-- Vemos el cliente que no está en la tabla de "pago":
SELECT *
  FROM pedido
 WHERE fk_cliente = 36
 ;

-- No se puede distinguir con la información disponible si un cliente que tiene varios pedidos ha completado el pago de algún pedido pero es 'moroso' en otro(s) pedido(s),
--      ya que en el pago no hay relación con el ID del pedido
SELECT *
  FROM pago
;  

SELECT *
  FROM detalle_pedido
;  


-- 3. Usa la vista clientes_morosos junto con un INNER JOIN para mostrar los datos de los clientes sin pagos.
SELECT cli.*
  FROM cliente cli
       JOIN clientes_morosos mor
            ON cli.pk_cliente = mor.cliente
;


-- 4. Repite los puntos 2 y 3 para tener la lista de clientes con pagos. Al generar la lista de
--      clientes que hayan pagado (equivalente al punto 3) indica la fecha del pago y el importe.


CREATE OR REPLACE VIEW clientes_corriente_pago
  AS
SELECT ped.fk_cliente AS cliente       -- NOTA: uso DISTINCT porque el cliente podría haber hecho varios pedidos
  FROM pedido ped
 WHERE ped.estado = 'Entregado'
INTERSECT
SELECT pag.fk_cliente AS cliente       -- NOTA: uso DISTINCT porque el cliente podría tener varios pedidos sin pagar, aunque no es necesario porque sólo afecta cuando tiene varios pedidos y 
  FROM pago pag
  ;

SELECT *
  FROM clientes_corriente_pago
  ;

-- NOTA: los clientes que hayan realizado varios pagos aparecerán más de 1 vez, cada uno con su 'fecha_pago' y su 'total':
  SELECT cli.*,
         pag.fecha_pago,
         pag.total AS importe
    FROM cliente cli
         JOIN clientes_corriente_pago cor
              ON cli.pk_cliente = cor.cliente
         JOIN pago pag
              ON cli.pk_cliente = pag.fk_cliente
ORDER BY cli.pk_cliente            
;