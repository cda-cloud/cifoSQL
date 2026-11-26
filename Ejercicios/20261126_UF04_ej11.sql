/**************************************************************************/
/***** Ejercicio 11. Consultas de Datos Agrupados *************************/
/**************************************************************************/



/*******************************************/
/*** Usando la Base de Datos nominas: ******/
/*******************************************/
USE nominas;


-- 1. Calcula el número total de empleados que hay en la tabla empleado. 
SELECT COUNT(*)
  FROM empleado emp
  ;

-- Usando el campo de la PK:
SELECT COUNT(emp.pk_empleado) AS total_empleados
  FROM empleado emp
  ;


-- 2. Calcula el número total de departamentos que hay en la tabla departamento. 
SELECT COUNT(*)
  FROM departamento dept
  ;

-- Usando el campo de la PK:
SELECT COUNT(dept.pk_departamento) AS total_departamentos
  FROM departamento dept
  ;


-- 3. Calcula la media de sueldo de todos los empleados. 
SELECT SUM(emp.sueldo)/COUNT(emp.pk_empleado) AS sueldo_medio_calculado,    -- Cálculo sumando importes y dividiendo por el número de empleados
       AVG(emp.sueldo) AS sueldo_medio_calc_avg                             -- Cálculo con la función AVG()
  FROM empleado emp
  ;

-- NOTA: como el sueldo es un campo que NO puede ser NULL, no hace falta calcular el total de registros
SHOW FULL COLUMNS FROM empleado;

SELECT *
  FROM empleado
  ;


-- 4. Indica quién es el empleado más joven.
-- -- Resultado con GROUP BY y HAVING --> usando CROSS JOIN:
  SELECT emp.pk_empleado,
         emp.nombre, 
         emp.apellido, 
         emp.fecha_nacimiento
         -- MAX(emp.fecha_nacimiento)
    FROM empleado emp
         JOIN empleado emp_max_nac
            --  ON emp.pk_empleado = emp_max_nac.pk_empleado    -- NOTA: no se puede usar el ON porque cada grupo del GROUP BY tendrá un PK_EMPLEADO y estaría mirando la fecha_nacimiento de ese empleado
GROUP BY emp.pk_empleado,
         emp.nombre, 
         emp.apellido, 
         emp.fecha_nacimiento
  HAVING emp.fecha_nacimiento = MAX(emp_max_nac.fecha_nacimiento)
  ;

-- -- Resultado con ordenación y LIMIT:
  SELECT *
    FROM empleado emp
ORDER BY emp.fecha_nacimiento DESC
   LIMIT 1
  ;

-- -- Resultado con subconsulta:
SELECT *
  FROM empleado emp
 WHERE emp.fecha_nacimiento = (SELECT MAX(emp2.fecha_nacimiento)
                                 FROM empleado emp2
                              )
  ;

-- -- Resultado con variable:
SELECT MAX(emp.fecha_nacimiento) 
  INTO @max_fecha_nacimiento 
  FROM empleado emp
  ;

SELECT @max_fecha_nacimiento;

SELECT *
  FROM empleado emp
 WHERE emp.fecha_nacimiento = @max_fecha_nacimiento
 ;


-- 5. Indica quién es el empleado menos joven.
-- -- Resultado con ordenación y LIMIT:
  SELECT *
    FROM empleado emp
ORDER BY emp.fecha_nacimiento ASC
   LIMIT 1
  ;

-- -- Resultado con subconsulta:
SELECT *
  FROM empleado emp
 WHERE emp.fecha_nacimiento = (SELECT MIN(emp2.fecha_nacimiento)
                                 FROM empleado emp2
                              )
  ;

-- -- Resultado con variable:
SELECT MIN(emp.fecha_nacimiento) 
  INTO @min_fecha_nacimiento 
  FROM empleado emp
  ;

SELECT @min_fecha_nacimiento;

SELECT *
  FROM empleado emp
 WHERE emp.fecha_nacimiento = @min_fecha_nacimiento
 ;


-- 6. Calcula el número total de empleados por estado civil. 
  SELECT emp.estado_civil,
         COUNT(*) AS numero_empleados
    FROM empleado emp
GROUP BY emp.estado_civil
ORDER BY 2                  -- Ordenado por la 2a columna, que es el recuento de empleados de cada estado civil
  ;


-- 7. Muestra el número de empleados que han ingresado cada año a la empresa 
  SELECT YEAR(emp.fecha_contrato),
         COUNT(*) AS numero_empleados
    FROM empleado emp
GROUP BY YEAR(emp.fecha_contrato)
ORDER BY YEAR(emp.fecha_contrato)           -- Ordenado por el año de ingreso en la empresa
  ;


/*******************************************/
/*** Usando la Base de Datos jardineria: ***/
/*******************************************/
USE jardineria;

-- 8. Lista el nombre y el precio del producto más caro. 
SELECT prod.nombre,
       prod.precio_venta
  FROM producto prod
 WHERE prod.precio_venta = (SELECT MAX(precio_venta)
                              FROM producto)
 ;                              



/*******************************************/
/*** Usando la Base de Datos nominas: ******/
/*******************************************/
USE nominas;

-- 9. Calcula la suma de los salarios de los empleados por departamento. 
  SELECT dept.departamento,
         SUM(emp.sueldo) AS sueldo_total_departamento
    FROM empleado emp
         JOIN departamento dept
              ON emp.fk_departamento = dept.pk_departamento
GROUP BY dept.departamento
ORDER BY dept.departamento
;


-- 10. Calcula la suma de los salarios de los empleados por sexo. 
  SELECT emp.sexo,
         SUM(emp.sueldo) AS sueldo_total_por_sexo
    FROM empleado emp
GROUP BY emp.sexo
ORDER BY emp.sexo
;
       

-- 11. Calcula el número de empleados que son Asistentes. 
  SELECT car.cargo,
         COUNT(emp.pk_empleado) AS cuenta
    FROM empleado emp
         JOIN cargo car
              ON car.pk_cargo = emp.fk_cargo
   WHERE car.cargo = 'Asistente'
GROUP BY car.cargo
;


-- 12. Calcula la media de hijos de los empleados por sexo y estado civil 
  SELECT emp.sexo,
         emp.estado_civil,
         AVG(emp.hijos) AS promedio_hijos
    FROM empleado emp
GROUP BY emp.sexo,
         emp.estado_civil
ORDER BY emp.sexo,
         emp.estado_civil         
;

SELECT IF(GROUPING(emp.sexo) = 1, 'TOTAL GENERAL', emp.sexo) AS sexo,
       IF(GROUPING(emp.estado_civil) = 1, IF(GROUPING(emp.sexo) = 1, '---', 'Subtotal'), emp.estado_civil) AS estado_civil,
       AVG(emp.hijos) AS promedio_hijos
    FROM empleado emp
GROUP BY emp.sexo,
         emp.estado_civil
/*                              -- No funciona si se pone el ORDER BY
ORDER BY emp.sexo,
         emp.estado_civil         
*/
WITH ROLLUP         
;


-- 13. Calcula el sueldo más bajo de los Analistas. 
SELECT car.cargo,
       MIN(emp.sueldo) AS sueldo_min_analista
  FROM empleado emp
       JOIN cargo car
            ON car.pk_cargo = emp.fk_cargo
 WHERE car.cargo = 'Analista'
;


-- 14. Calcula el sueldo más alto de los Analistas. 
SELECT car.cargo,
       MAX(emp.sueldo) AS sueldo_max_analista
  FROM empleado emp
       JOIN cargo car
            ON car.pk_cargo = emp.fk_cargo
 WHERE car.cargo = 'Analista'
;


-- 15. Muestra el sueldo máximo, sueldo mínimo, sueldo promedio y el número total de empleados por cargo. 
  SELECT car.cargo,
         COUNT(emp.pk_empleado) AS num_empleados_cargo,
         MAX(emp.sueldo) AS sueldo_maximo,
         MIN(emp.sueldo) AS sueldo_minimo,
         AVG(emp.sueldo) AS sueldo_promedio
    FROM empleado emp
         JOIN cargo car
              ON car.pk_cargo = emp.fk_cargo
GROUP BY car.cargo
ORDER BY car.cargo
;                 


-- 16. Muestra el sueldo máximo, sueldo mínimo, sueldo promedio y el número total 
--      de empleados por departamento, ordenando de forma descendente por el 
--      sueldo promedio. 
  SELECT dept.departamento,
         COUNT(emp.pk_empleado) AS num_empleados_departamento,
         MAX(emp.sueldo) AS sueldo_maximo,
         MIN(emp.sueldo) AS sueldo_minimo,
         AVG(emp.sueldo) AS sueldo_promedio
    FROM empleado emp
         JOIN departamento dept
              ON dept.pk_departamento = emp.fk_departamento
GROUP BY dept.departamento
ORDER BY (AVG(emp.sueldo)) DESC
;


-- 17. Muestra la edad máxima, edad mínima, edad promedio y el número total de 
--      empleados de los departamentos que tienen una edad promedio superior a los 
--      45 años. 
  SELECT dept.departamento,
         COUNT(emp.pk_empleado) AS num_empleados_departamento,
         FLOOR(MIN(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365)) AS edad_empleado_max,
         FLOOR(MAX(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365)) AS edad_empleado_min,
         FLOOR(AVG(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365)) AS edad_empleado_promedio
    FROM empleado emp
         JOIN departamento dept
              ON dept.pk_departamento = emp.fk_departamento
GROUP BY dept.departamento
  HAVING edad_empleado_promedio > 45    
;

-- -- Si no se usa el FLOOR para redondear en el cálculo de la "edad promedio", aparece el departamento de informática con 45.34 años:
  SELECT dept.departamento,
         COUNT(emp.pk_empleado) AS num_empleados_departamento,
         FLOOR(MIN(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365)) AS edad_empleado_max,
         FLOOR(MAX(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365)) AS edad_empleado_min,
         AVG(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365) AS edad_empleado_promedio
    FROM empleado emp
         JOIN departamento dept
              ON dept.pk_departamento = emp.fk_departamento
GROUP BY dept.departamento
  HAVING edad_empleado_promedio > 45    
;


-- 18. Calcula el número de empleados que tienen un sueldo mayor o igual a 1800€.
SELECT COUNT(1)
  FROM empleado emp
 WHERE emp.sueldo >= 18000      -- NOTA: uso el sueldo de 18k porque todos cobran más de 1800€ al año
;


-- 19. Calcula el número de empleados que tienen una edad menor o igual a 28 años. 
SELECT COUNT(1) AS numero_empleados
  FROM empleado emp
 WHERE FLOOR(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365) <= 28
; 


-- 20. Lista los nombres de los departamentos cuyos empleados tienen una edad promedio mayor o igual a 35 años. 
  SELECT dept.departamento,  
         FLOOR(AVG(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365)) AS edad_empleado_promedio
    FROM empleado emp
         JOIN departamento dept
              ON dept.pk_departamento = emp.fk_departamento
GROUP BY dept.departamento
  HAVING edad_empleado_promedio >= 35       -- NOTA: todos los departamentos tienen edad promedio mayor a 35 años
;


-- 21. Devuelve un listado con los nombres de los cargos que tienen 5 o más empleados.
  SELECT car.cargo,
         COUNT(emp.pk_empleado) AS numero_empleados
    FROM cargo car
         JOIN empleado emp
              ON car.pk_cargo = emp.fk_cargo
GROUP BY car.cargo
  HAVING numero_empleados >= 5
;


-- 22. Devuelve un listado con los nombres de los departamentos donde el promedio de edad sea superior 40 años. 
  SELECT dept.departamento,  
         FLOOR(AVG(DATEDIFF(CURRENT_DATE(), emp.fecha_nacimiento)/365)) AS edad_empleado_promedio
    FROM empleado emp
         JOIN departamento dept
              ON dept.pk_departamento = emp.fk_departamento
GROUP BY dept.departamento
  HAVING edad_empleado_promedio > 40       -- NOTA: todos los departamentos tienen edad promedio mayor a 40 años
;




-- 23. Muestra el número total de empleados que tiene cada departamento. 
--      El listado también debe incluir los departamentos que no tienen ningún 
--      empleado. El resultado mostrará dos columnas, una con el nombre del 
--      departamento y otra con el número de empleados que tiene. Ordena el 
--      resultado descendentemente por el número de empleados. 
  SELECT dept.departamento,  
         COUNT(emp.pk_empleado) AS numero_empleados
    FROM departamento dept
         LEFT JOIN empleado emp
              ON dept.pk_departamento = emp.fk_departamento
GROUP BY dept.departamento
ORDER BY numero_empleados DESC
;

-- Los departamentos que NO tienen empleados son Finanzas-8-, Marketing-7-, Recepción-9-:
SELECT * FROM departamento;

SELECT *
  FROM empleado emp
 WHERE emp.fk_departamento IN (8, 7, 9)
;
-- Mostrar diferencia entre usar usar COUNT(*) o usar COUNT() con el campo PK de la tabla "débil" de la LEFT JOIN (empleado):
SELECT dept.departamento,  
         COUNT(emp.pk_empleado) AS numero_empleados,
         COUNT(*) as num_empleados_asterisco
    FROM departamento dept
         LEFT JOIN empleado emp
              ON dept.pk_departamento = emp.fk_departamento
GROUP BY dept.departamento
ORDER BY numero_empleados DESC
;


-- 24. Explica las diferencias entre las cláusulas WHERE y HAVING, y cuándo utilizar cada una de ellas.

-- -- El "WHERE" filtra las tablas ANTES de realizar la agrupación indicada en el GROUP BY --> se usa cuando se quiere filtrar resultados que no se quieren tener en cuenta en la agrupación
-- -- El "HAVING" filtra los resultados después de realizar la agrupación del GROUP BY --> se usa para filtrar el resultado que se obtiene de la agrupación

