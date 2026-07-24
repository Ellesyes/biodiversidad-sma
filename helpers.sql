-- ============================================================
-- Versión OPTIMIZADA de las funciones safe_*.
-- En vez de intentar convertir y capturar el error (lento a
-- gran escala, por el overhead de EXCEPTION en PL/pgSQL),
-- validamos el formato con una expresión regular ANTES de
-- convertir. Mismo resultado, muchísimo más rápido con
-- millones de filas.
-- ============================================================

CREATE OR REPLACE FUNCTION safe_date(txt TEXT) RETURNS DATE AS $$
    SELECT CASE
        WHEN txt ~ '^\d{4}-\d{2}-\d{2}$' THEN txt::date
        ELSE NULL
    END;
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_time(txt TEXT) RETURNS TIME AS $$
    SELECT CASE
        WHEN txt ~ '^\d{1,2}:\d{2}(:\d{2})?$' THEN txt::time
        ELSE NULL
    END;
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_numeric(txt TEXT) RETURNS NUMERIC AS $$
    SELECT CASE
        WHEN txt ~ '^-?\d+(\.\d+)?$' THEN txt::numeric
        ELSE NULL
    END;
$$ LANGUAGE sql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_int(txt TEXT) RETURNS INT AS $$
    SELECT CASE
        WHEN txt ~ '^-?\d+$' THEN txt::int
        ELSE NULL
    END;
$$ LANGUAGE sql IMMUTABLE;

-- Actualiza estadísticas para que el planificador de consultas
-- elija el mejor camino posible (importante después de cargar
-- las dimensiones antes de correr las tablas de hechos).
ANALYZE dim_campana;
ANALYZE dim_estacion;
ANALYZE dim_taxon;
ANALYZE raw_monitoreo;
ANALYZE raw_captura;
ANALYZE raw_adaptacion;