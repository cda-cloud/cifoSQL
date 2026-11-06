-- vuelos.sql

CREATE DATABASE IF NOT EXISTS vuelos;
USE vuelos;

-- tabla vuelos
CREATE TABLE VUELOS(
  pk_vuelo INT AUTO_INCREMENT,
  programa_vuelo INT UNSIGNED,
  fecha DATE,
  hora TIME,
  plazas_vacias INT UNSIGNED,
  modelo INT UNSIGNED 
);

ALTER TABLE VUELOS ADD PRIMARY KEY (pk_vuelo);


-- tabla programas_vuelo
CREATE TABLE PROGRAMAS_VUELO(
  pk_programa_vuelo INT AUTO_INCREMENT,
  numero_vuelo  CHAR(6),     -- codigo IATA se forma con 2 letras de linea aerea y hasta 4 numeros
  linea_aerea INT UNSIGNED,
  aeropuerto_salida INT UNSIGNED,
  aeropuerto_llegada INT UNSIGNED
);

ALTER TABLE PROGRAMAS_VUELO ADD PRIMARY KEY (pk_programa_vuelo);


-- tabla lineas_aereas
CREATE TABLE LINEAS_AEREAS(
  pk_linea_aerea INT AUTO_INCREMENT,
  codigo CHAR(2),
  nombre VARCHAR(30)  
);

ALTER TABLE LINEAS_AEREAS ADD PRIMARY KEY (pk_linea_aerea);


-- tabla aeropuertos
CREATE TABLE AEROPUERTOS(
  pk_aeropuerto INT AUTO_INCREMENT,
  codigo CHAR(4),
  nombre VARCHAR(30),
  ciudad INT UNSIGNED
);

ALTER TABLE AEROPUERTOS ADD PRIMARY KEY (pk_aeropuerto);


-- tabla aeropuertos_modelos_aviones
CREATE TABLE AEROPUERTOS_MODELOS_AVIONES(
  aeropuerto INT UNSIGNED,
  modelo INT UNSIGNED
);

ALTER TABLE AEROPUERTOS_MODELOS_AVIONES ADD PRIMARY KEY (aeropuerto, modelo);


-- tabla modelos_aviones
CREATE TABLE MODELOS_AVIONES(
  pk_modelo INT AUTO_INCREMENT, 
  modelo VARCHAR(20),  -- A321neo -- A350-1000ULR
  capacidad SMALLINT
);

ALTER TABLE MODELOS_AVIONES ADD PRIMARY KEY (pk_modelo);


-- tabla ciudades
CREATE TABLE CIUDADES(
  pk_ciudad INT AUTO_INCREMENT,
  ciudad VARCHAR(30),
  pais INT UNSIGNED
);

ALTER TABLE CIUDADES ADD PRIMARY KEY (pk_ciudad);


-- tabla paises
CREATE TABLE PAISES(
  pk_pais INT AUTO_INCREMENT,
  pais VARCHAR(30)
);

ALTER TABLE PAISES ADD PRIMARY KEY (pk_pais);


-- tabla schedule_programas_vuelos
CREATE TABLE SCHEDULE_PROGRAMAS_VUELOS(
  programa_vuelo INT unsigned,
  dia_semana TINYINT UNSIGNED,
  hora_salida TIME
);

ALTER TABLE SCHEDULE_PROGRAMAS_VUELOS ADD PRIMARY KEY (programa_vuelo, dia_semana, hora_salida);




-- foreign keys
ALTER TABLE PROGRAMAS_VUELO 
ADD CONSTRAINT fk_linea_aerea_programa_vuelo
FOREIGN KEY (linea_aerea) REFERENCES LINEAS_AEREAS(pk_linea_aerea)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PROGRAMAS_VUELO 
ADD CONSTRAINT fk_aeropuerto_salida_programa_vuelo
FOREIGN KEY (aeropuerto_salida) REFERENCES AEROPUERTOS(pk_aeropuerto)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PROGRAMAS_VUELO
ADD CONSTRAINT fk_aeropuerto_llegada_programa_vuelo
FOREIGN KEY (aeropuerto_llegada) REFERENCES AEROPUERTOS(pk_aeropuerto)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE VUELOS
ADD CONSTRAINT fk_programa_vuelo
FOREIGN KEY (programa_vuelo) REFERENCES PROGRAMAS_VUELO(pk_programa_vuelo)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE VUELOS
ADD CONSTRAINT fk_modelo
FOREIGN KEY (modelo) REFERENCES MODELOS_AVIONES(pk_modelo)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE AEROPUERTOS
ADD CONSTRAINT fk_aeropuerto_ciudad
FOREIGN KEY (ciudad) REFERENCES CIUDADES(pk_ciudad)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CIUDADES
ADD CONSTRAINT fk_pais
FOREIGN KEY (pais) REFERENCES PAISES(pk_pais)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE SCHEDULE_PROGRAMAS_VUELOS
ADD CONSTRAINT fk_programa_vuelo
FOREIGN KEY (programa_vuelo) REFERENCES PROGRAMAS_VUELO(pk_programa_vuelo)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE AEROPUERTOS_MODELOS_AVIONES
ADD CONSTRAINT fk_aeropuerto
FOREIGN KEY (aeropuerto) REFERENCES AEROPUERTOS(pk_aeropuerto)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE AEROPUERTOS_MODELOS_AVIONES
ADD CONSTRAINT fk_modelo
FOREIGN KEY (modelo) REFERENCES MODELOS_AVIONES(pk_modelo)
ON UPDATE CASCADE ON DELETE RESTRICT;
