-- ============================================================
-- Optimización: agrega una columna "taxon_key" a dim_taxon,
-- combinando género + epíteto + infraespecífico en un solo
-- texto. Esto permite comparar con "=" normal (indexable,
-- hash join) en vez de IS NOT DISTINCT FROM (no indexable,
-- fuerza un escaneo fila por fila -- por eso iba tan lento).
-- ============================================================

ALTER TABLE dim_taxon
    ADD COLUMN IF NOT EXISTS taxon_key TEXT
    GENERATED ALWAYS AS (
        COALESCE(genero, '') || '|' || COALESCE(epiteto_especifico, '') || '|' || COALESCE(epiteto_infraespecifico, '')
    ) STORED;

CREATE INDEX IF NOT EXISTS idx_dim_taxon_key ON dim_taxon(taxon_key);

ANALYZE dim_taxon;