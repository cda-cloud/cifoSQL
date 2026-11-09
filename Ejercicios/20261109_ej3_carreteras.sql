-- carreteras.sql

CREATE DATABASE IF NOT EXISTS carreteras;
USE carreteras;

-- tabla carreteras
CREATE TABLE CARRETERAS(
  pk_carretera INT AUTO_INCREMENT,
  codigo_carretera VARCHAR(50),     -- ?? tipo datos ??
  nombre_carretera VARCHAR(50),
  titularidad INT, -- UNSIGNED,
  tipo_via INT, -- UNSIGNED,
  nivel INT, -- UNSIGNED,
  acceso_controlado BIT,
  doble_calzada BIT,
  prefijo VARCHAR(10),
  senyal VARCHAR(10),
  PRIMARY KEY (pk_carretera)
);

-- ALTER TABLE CARRETERAS ADD PRIMARY KEY (pk_carretera);


-- tabla observaciones_carretera
CREATE TABLE OBSERVACIONES_CARRETERA(
  pk_observacion INT AUTO_INCREMENT,
  carretera INT, -- UNSIGNED,
  observacion VARCHAR(4000),
  PRIMARY KEY (pk_observacion)
);

-- ALTER TABLE OBSERVACIONES_CARRETERA ADD PRIMARY KEY (pk_observacion);


-- tabla niveles
CREATE TABLE NIVELES(
  pk_nivel INT AUTO_INCREMENT,
  nivel VARCHAR(4),
  color VARCHAR(15),
  PRIMARY KEY (pk_nivel)
);

-- ALTER TABLE NIVELES ADD PRIMARY KEY (pk_nivel);


-- tabla tipos_via
CREATE TABLE TIPOS_VIA(
  pk_tipo_via INT AUTO_INCREMENT,
  via VARCHAR(30),
  PRIMARY KEY (pk_tipo_via)
);

-- ALTER TABLE TIPOS_VIA ADD PRIMARY KEY (pk_tipo_via);


-- tabla titularidades
CREATE TABLE TITULARIDADES(
  pk_titularidad INT AUTO_INCREMENT,
  titularidad VARCHAR(30),
  PRIMARY KEY (pk_titularidad)
);

-- ALTER TABLE TITULARIDADES ADD PRIMARY KEY (pk_titularidad);


-- tabla tipo_terrenos
CREATE TABLE TIPOS_TERRENO(
  pk_tipo_terreno INT AUTO_INCREMENT,
  tipo_terreno VARCHAR(30),
  PRIMARY KEY (pk_tipo_terreno)
);

-- ALTER TABLE TIPOS_TERRENO ADD PRIMARY KEY (pk_tipo_terreno);


-- tabla entornos
CREATE TABLE ENTORNOS(
  pk_entorno INT AUTO_INCREMENT,
  entorno VARCHAR(30),
  PRIMARY KEY (pk_entorno)
);

-- ALTER TABLE ENTORNOS ADD PRIMARY KEY (pk_entorno);


-- tabla tramos
CREATE TABLE TRAMOS(
  pk_tramo INT AUTO_INCREMENT,
  fk_carretera INT, -- UNSIGNED,
  fk_tipo_tramo INT, -- UNSIGNED,
  km_inicial DECIMAL (6,2),
  fk_provincia_inicial INT, -- UNSIGNED,
  km_final DECIMAL (6,2),
  fk_provincia_final INT, -- UNSIGNED,
  longitud DECIMAL (6,2),
  fk_tipo_terreno INT, -- UNSIGNED,
  fk_entorno INT, -- UNSIGNED,
  velocidad_limite SMALLINT UNSIGNED,
  sentidos DECIMAL(1,0),
  carriles_ida DECIMAL(2,0),
  carriles_vuelta DECIMAL(2,0),
  observaciones VARCHAR(4000),
  PRIMARY KEY (pk_tramo)
);

-- ALTER TABLE TRAMOS ADD PRIMARY KEY (pk_tramo);


-- tabla confluencias
CREATE TABLE CONFLUENCIAS(
  pk_confluencia INT AUTO_INCREMENT,
  fk_tramo1 INT, -- UNSIGNED,
  km_tramo1 INT, -- UNSIGNED,
  fk_tramo2 INT, -- UNSIGNED,
  km_tramo2 INT, -- UNSIGNED,
  fk_provincia INT, -- UNSIGNED,
  PRIMARY KEY (pk_confluencia)
);

-- ALTER TABLE CONFLUENCIAS ADD PRIMARY KEY (pk_confluencia);


-- tabla tipos_tramo
CREATE TABLE TIPOS_TRAMO(
  pk_tipo_tramo INT AUTO_INCREMENT,
  tipo_tramo VARCHAR(50),
  PRIMARY KEY (pk_tipo_tramo)
);

-- ALTER TABLE TIPOS_TRAMO ADD PRIMARY KEY (pk_tipo_tramo);


-- tabla provincias
CREATE TABLE PROVINCIAS(
  pk_provincia INT AUTO_INCREMENT,
  nombre_provincia VARCHAR(30),
  fk_ccaa INT, -- UNSIGNED,
  PRIMARY KEY (pk_provincia)
);

-- ALTER TABLE PROVINCIAS ADD PRIMARY KEY (pk_provincia);


-- tabla comunidades_autonomas
CREATE TABLE COMUNIDADES_AUTONOMAS(
  pk_ccaa INT AUTO_INCREMENT,
  comunidad_autonoma VARCHAR(30),
  PRIMARY KEY (pk_ccaa)
);

-- ALTER TABLE COMUNIDADES_AUTONOMAS ADD PRIMARY KEY (pk_ccaa);



-- foreign keys
ALTER TABLE CARRETERAS 
ADD CONSTRAINT fk_titularidad_carretera
FOREIGN KEY (titularidad) REFERENCES TITULARIDADES(pk_titularidad)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CARRETERAS 
ADD CONSTRAINT fk_tipo_via_carretera
FOREIGN KEY (tipo_via) REFERENCES TIPOS_VIA(pk_tipo_via)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CARRETERAS 
ADD CONSTRAINT fk_nivel_carretera
FOREIGN KEY (nivel) REFERENCES NIVELES(pk_nivel)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE OBSERVACIONES_CARRETERA
ADD CONSTRAINT fk_obs_carretera
FOREIGN KEY (carretera) REFERENCES CARRETERAS(pk_carretera)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAMOS
ADD CONSTRAINT fk_tramo_carretera
FOREIGN KEY (fk_carretera) REFERENCES CARRETERAS(pk_carretera)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAMOS
ADD CONSTRAINT fk_tipo_tramo
FOREIGN KEY (fk_tipo_tramo) REFERENCES TIPOS_TRAMO(pk_tipo_tramo)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAMOS
ADD CONSTRAINT fk_prov_ini_tramo
FOREIGN KEY (fk_provincia_inicial) REFERENCES PROVINCIAS(pk_provincia)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAMOS
ADD CONSTRAINT fk_prov_fin_tramo
FOREIGN KEY (fk_provincia_final) REFERENCES PROVINCIAS(pk_provincia)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAMOS
ADD CONSTRAINT fk_tipo_terreno_tramo
FOREIGN KEY (fk_tipo_terreno) REFERENCES TIPOS_TERRENO(pk_tipo_terreno)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE TRAMOS
ADD CONSTRAINT fk_entorno_tramo
FOREIGN KEY (fk_entorno) REFERENCES ENTORNOS(pk_entorno)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CONFLUENCIAS
ADD CONSTRAINT fk_tramo1_confluencia
FOREIGN KEY (fk_tramo1) REFERENCES TRAMOS(pk_tramo)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CONFLUENCIAS
ADD CONSTRAINT fk_tramo2_confluencia
FOREIGN KEY (fk_tramo2) REFERENCES TRAMOS(pk_tramo)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE CONFLUENCIAS
ADD CONSTRAINT fk_provincia_confluencia
FOREIGN KEY (fk_provincia) REFERENCES PROVINCIAS(pk_provincia)
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE PROVINCIAS
ADD CONSTRAINT fk_ccaa_provincia
FOREIGN KEY (fk_ccaa) REFERENCES COMUNIDADES_AUTONOMAS(pk_ccaa)
ON UPDATE CASCADE ON DELETE RESTRICT;
