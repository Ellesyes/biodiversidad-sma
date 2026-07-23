-- ============================================================
-- Funciones de conversión "segura": si el texto no se puede
-- convertir al tipo esperado (fecha, hora, número), devuelven
-- NULL en vez de romper toda la transformación.
-- Esto es necesario porque la SMA usa textos como "No aplica"
-- o "No registrada" en campos que deberían ser fecha/hora/numero.
-- ============================================================

CREATE OR REPLACE FUNCTION safe_date(txt TEXT) RETURNS DATE AS $$
BEGIN
    RETURN NULLIF(txt, '')::date;
EXCEPTION WHEN others THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_time(txt TEXT) RETURNS TIME AS $$
BEGIN
    RETURN NULLIF(txt, '')::time;
EXCEPTION WHEN others THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_numeric(txt TEXT) RETURNS NUMERIC AS $$
BEGIN
    RETURN NULLIF(txt, '')::numeric;
EXCEPTION WHEN others THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION safe_int(txt TEXT) RETURNS INT AS $$
BEGIN
    RETURN NULLIF(txt, '')::int;
EXCEPTION WHEN others THEN
    RETURN NULL;
END;
$$ LANGUAGE plpgsql IMMUTABLE;