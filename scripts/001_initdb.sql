\c potenciartrabajo

/* Acá defino las tablas temporales (tal cual están en los archivos csv)*/

CREATE TEMPORARY TABLE temp_periodoAgosto (
    periodo DATE,
    provincia VARCHAR,
    provincia_id INT,
    departamento VARCHAR,
    departamento_id INT,
    municipio VARCHAR,
    municipio_id INT,
    titulares INT
);

CREATE TEMPORARY TABLE temp_periodoDiciembre (
    periodo DATE,
    provincia VARCHAR,
    provincia_id INT,
    departamento VARCHAR,
    departamento_id INT,
    municipio VARCHAR,
    municipio_id INT,
    titulares INT
);

CREATE TEMPORARY TABLE temp_titulares (
    persona_id INT,
    sexo VARCHAR,
    genero VARCHAR,
    edad FLOAT,
    nacionalidad VARCHAR,
    municipio_id INT,
    municipio VARCHAR,
    provincia_id INT,
    provincia VARCHAR,
    departamento_id INT,
    departamento VARCHAR
);

/* Acá desde el CSV le cargo los datos a las tablas temporales */

COPY temp_periodoAgosto
FROM '/superset/datos/periodoAgosto.csv' DELIMITER ',' CSV HEADER;

COPY temp_periodoDiciembre
FROM '/superset/datos/periodoDiciembre.csv' DELIMITER ',' CSV HEADER;

COPY temp_titulares
FROM '/superset/datos/titulares.csv' DELIMITER ',' CSV HEADER;

/* Acá cargamos los datos en las tablas definitivas*/

-- PROVINCIA
INSERT INTO
    public.provincia (provincia_id, provincia)
SELECT DISTINCT
    provincia_id,
    provincia
FROM temp_titulares
WHERE
    provincia_id IS NOT NULL
    AND provincia IS NOT NULL
ON CONFLICT (provincia_id) DO NOTHING;

-- DEPARTAMENTO
INSERT INTO
    public.departamento (
        departamento_id,
        departamento,
        provincia_id
    )
SELECT DISTINCT
    departamento_id,
    departamento,
    provincia_id
FROM temp_titulares
WHERE
    departamento_id IS NOT NULL
    AND departamento IS NOT NULL
ON CONFLICT (departamento_id) DO NOTHING;

-- MUNICIPIO
INSERT INTO
    public.municipio (
        municipio_id,
        municipio,
        departamento_id
    )
SELECT DISTINCT
    municipio_id,
    municipio,
    departamento_id
FROM temp_titulares
WHERE
    municipio_id IS NOT NULL
    AND municipio IS NOT NULL
ON CONFLICT (municipio_id) DO NOTHING;

-- TITULAR
INSERT INTO
    public.titular (
        persona_id,
        sexo,
        genero,
        edad,
        nacionalidad,
        municipio_id
    )
SELECT DISTINCT
    persona_id,
    sexo,
    genero,
    edad,
    nacionalidad,
    municipio_id
FROM temp_titulares
WHERE
    persona_id IS NOT NULL
    AND sexo IS NOT NULL
    AND genero IS NOT NULL
    AND edad IS NOT NULL
    AND nacionalidad IS NOT NULL
    AND municipio_id IS NOT NULL
    AND municipio_id IN (
        SELECT municipio_id
        FROM public.municipio
    )
ON CONFLICT (persona_id) DO NOTHING;

-- PERIODO AGOSTO
INSERT INTO
    public.periodo (
        periodo,
        departamento,
        departamento_id,
        municipio,
        municipio_id,
        titulares
    )
SELECT DISTINCT
    periodo,
    departamento,
    departamento_id,
    municipio,
    municipio_id,
    titulares
FROM temp_periodoAgosto
WHERE
    periodo IS NOT NULL
    AND departamento IS NOT NULL
    AND departamento_id IS NOT NULL
    AND municipio IS NOT NULL
    AND municipio_id IS NOT NULL
    AND titulares IS NOT NULL
ON CONFLICT DO NOTHING;

-- PERIODO DICIEMBRE
INSERT INTO
    public.periodo (
        periodo,
        departamento,
        departamento_id,
        municipio,
        municipio_id,
        titulares
    )
SELECT DISTINCT
    periodo,
    departamento,
    departamento_id,
    municipio,
    municipio_id,
    titulares
FROM temp_periodoDiciembre
WHERE
    periodo IS NOT NULL
    AND departamento IS NOT NULL
    AND departamento_id IS NOT NULL
    AND municipio IS NOT NULL
    AND municipio_id IS NOT NULL
    AND titulares IS NOT NULL
ON CONFLICT DO NOTHING;