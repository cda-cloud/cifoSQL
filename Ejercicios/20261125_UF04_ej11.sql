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


-- NOTA: como el sueldo es un campo que NO puede ser NULL, no hace falta calcular el total de registros
SHOW FULL COLUMNS FROM empleado;
SELECT *
  FROM empleado
  ;



4. Indica quién es el empleado más joven. 
5. Indica quién es el empleado menos joven. 
6. Calcula el número total de empleados por estado civil. 
7. Muestra el número de empleados que han ingresado cada año a la empresa 
8. Lista el nombre y el precio del producto más caro. 
9. Calcula la suma de los salarios de los empleados por departamento. 
10. Calcula la suma de los salarios de los empleados por sexo. 
11. Calcula el número de empleados que son Asistentes. 
12. Calcula la media de hijos de los empleados por sexo y estado civil 
13. Calcula el sueldo más bajo de los Analistas. 
14. Calcula el sueldo más alto de los Analistas. 
15. Muestra el sueldo máximo, sueldo mínimo, sueldo promedio y el número total 
de empleados por cargo. 
16. Muestra el sueldo máximo, sueldo mínimo, sueldo promedio y el número total 
de empleados por departamento, ordenando de forma descendente por el 
sueldo promedio. 

17. Muestra la edad máxima, edad mínima, edad promedio y el número total de 
empleados de los departamentos que tienen una edad promedio superior a los 
45 años. 
18. Calcula el número de empleados que tienen un sueldo mayor o igual a 1800€. 
19. Calcula el número de empleados que tienen una edad menor o igual a 28 
años. 
20. Lista los nombres de los departamentos cuyos empleados tienen una edad 
promedio mayor o igual a 35 años. 
21. Devuelve un listado con los nombres de los cargos que tienen 5 o más 
empleados. 
22. Devuelve un listado con los nombres de los departamentos donde el promedio 
de edad sea superior 40 años. 
23. Muestra el número total de empleados que tiene cada departamento. 
El listado también debe incluir los departamentos que no tienen ningún 
empleado. El resultado mostrará dos columnas, una con el nombre del 
departamento y otra con el número de empleados que tiene. Ordena el 
resultado descendentemente por el número de empleados. 
24. Explica las diferencias entre las cláusulas WHERE y HAVING, y cuándo utilizar 
cada una de ellas. 

