CREATE TABLE raw_monitoreo (
    id SERIAL PRIMARY KEY,
    region_archivo TEXT,
    anio_archivo TEXT,
    archivo_origen TEXT,
    fecha_ingesta TIMESTAMP DEFAULT now(),
    datos JSONB
);

CREATE TABLE raw_captura (
    id SERIAL PRIMARY KEY,
    region_archivo TEXT,
    anio_archivo TEXT,
    archivo_origen TEXT,
    fecha_ingesta TIMESTAMP DEFAULT now(),
    datos JSONB
);

CREATE TABLE raw_adaptacion (
    id SERIAL PRIMARY KEY,
    region_archivo TEXT,
    anio_archivo TEXT,
    archivo_origen TEXT,
    fecha_ingesta TIMESTAMP DEFAULT now(),
    datos JSONB
);