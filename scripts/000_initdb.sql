CREATE DATABASE potenciartrabajo;

\c potenciartrabajo

/* Definición de tablas a utilizar según estructura CSV
Tabla: Periodo (periodo,titulares (cantidad))
Tabla: Provincia (provincia_id, provincia)
Tabla: Departamento (departamento_id,departamento)
Tabla: Municipio (municipio_id,municipio)
Tabla: Titular(persona_id,sexo,genero,edad,nacionalidad)
*/

/*
Borro las tablas si existen
*/
DROP TABLE IF EXISTS public.periodo;

DROP TABLE IF EXISTS public.municipio;

DROP TABLE IF EXISTS public.periodopormunicipio;

DROP TABLE IF EXISTS public.provincia;

DROP TABLE IF EXISTS public.departamento;

DROP TABLE IF EXISTS public.titular;

/* Creo las tablas para la base de datos definitiva, respetando todas las formas normales */

CREATE TABLE public.periodo (
    idPeriodo SERIAL,
    periodo DATE,
    departamento VARCHAR,
    departamento_id INT,
    municipio VARCHAR,
    municipio_id INT,
    titulares INT
);

CREATE TABLE public.provincia (
    provincia VARCHAR,
    provincia_id INT
);

CREATE TABLE public.departamento (
    departamento VARCHAR,
    departamento_id INT,
    provincia_id INT
);

CREATE TABLE public.municipio (
    municipio VARCHAR,
    municipio_id INT,
    departamento_id INT
);

CREATE TABLE public.periodopormunicipio (
    idPeriodoxMunicipio SERIAL,
    periodo INT,
    municipio INT
);

/*Tabla: Titular(persona_id,sexo,genero,edad,nacionalidad)*/
CREATE TABLE public.titular (
    persona_id INT,
    sexo VARCHAR,
    genero VARCHAR,
    edad FLOAT,
    nacionalidad VARCHAR,
    municipio_id INT
);

/*Claves primarias*/
ALTER TABLE public.periodo
ADD CONSTRAINT pk_periodo PRIMARY KEY (idPeriodo);

ALTER TABLE public.provincia
ADD CONSTRAINT pk_provincia PRIMARY KEY (provincia_id);

ALTER TABLE public.departamento
ADD CONSTRAINT pk_departamento PRIMARY KEY (departamento_id);

ALTER TABLE public.municipio
ADD CONSTRAINT pk_municipio PRIMARY KEY (municipio_id);

ALTER TABLE public.periodopormunicipio
ADD CONSTRAINT pk_periodoPorMunicipio PRIMARY KEY (idPeriodoxMunicipio);

ALTER TABLE public.titular
ADD CONSTRAINT pk_titular PRIMARY KEY (persona_id);

/*Claves foráneas*/
ALTER TABLE public.departamento
ADD CONSTRAINT fk_departamento_provincia FOREIGN KEY (provincia_id) REFERENCES provincia (provincia_id);

ALTER TABLE public.municipio
ADD CONSTRAINT fk_municipio_departamento FOREIGN KEY (departamento_id) REFERENCES departamento (departamento_id);

ALTER TABLE public.periodopormunicipio
ADD CONSTRAINT fk_periodoPorMunicipio_periodo FOREIGN KEY (periodo) REFERENCES periodo (idPeriodo);

ALTER TABLE public.periodopormunicipio
ADD CONSTRAINT fk_periodoPorMunicipio_municipio FOREIGN KEY (municipio) REFERENCES municipio (municipio_id);

ALTER TABLE public.titular
ADD CONSTRAINT fk_titular_municipio FOREIGN KEY (municipio_id) REFERENCES municipio (municipio_id);