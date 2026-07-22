-- ============================================
-- Esquema: Biodiversidad SMA
-- Tablas de dimensión + tablas de hechos
-- ============================================

-- ---------- DIMENSIONES ----------

CREATE TABLE dim_campana (
    campana_sma_id TEXT PRIMARY KEY,
    documento_id TEXT,
    nombre_campana TEXT,
    ano_inicio INT,
    fecha_inicio DATE,
    fecha_termino DATE,
    objetivo_campana TEXT,
    informe_id TEXT
);

CREATE TABLE dim_estacion (
    estacion_replica_sma_id TEXT PRIMARY KEY,
    nombre_estacion TEXT,
    tipo_monitoreo TEXT,
    rescate_adaptacion_relocalizacion TEXT,
    region TEXT,
    provincia TEXT,
    comuna TEXT,
    localidad TEXT,
    ecosistema_nivel1 TEXT,
    ecosistema_nivel2 TEXT,
    exposicion TEXT,
    largo_m NUMERIC,
    ancho_m NUMERIC,
    radio_m NUMERIC,
    superficie_m2 NUMERIC,
    lat_central NUMERIC,
    lon_central NUMERIC
);

CREATE TABLE dim_taxon (
    taxon_id SERIAL PRIMARY KEY,
    reino TEXT,
    filo_division TEXT,
    clase TEXT,
    orden TEXT,
    familia TEXT,
    genero TEXT,
    subgenero TEXT,
    epiteto_especifico TEXT,
    epiteto_infraespecifico TEXT,
    nombre_comun TEXT,
    UNIQUE (genero, epiteto_especifico, epiteto_infraespecifico)
);

-- ---------- HECHOS ----------

CREATE TABLE fact_ocurrencia (
    ocurrencia_sma_id TEXT PRIMARY KEY,
    campana_sma_id TEXT REFERENCES dim_campana(campana_sma_id),
    estacion_replica_sma_id TEXT REFERENCES dim_estacion(estacion_replica_sma_id),
    taxon_id INT REFERENCES dim_taxon(taxon_id),
    fecha_evento DATE,
    hora_inicio_evento TIME,
    lat_registro NUMERIC,
    lon_registro NUMERIC,
    tipo_cuantificacion TEXT,
    valor NUMERIC,
    unidad_valor TEXT,
    estado_organismo TEXT,
    condicion_reproductiva TEXT,
    sexo_fauna TEXT,
    codigo_individuo TEXT
);

CREATE TABLE fact_captura (
    captura_sma_id TEXT PRIMARY KEY,
    individuo_sma_id TEXT,
    campana_sma_id TEXT REFERENCES dim_campana(campana_sma_id),
    estacion_replica_sma_id TEXT REFERENCES dim_estacion(estacion_replica_sma_id),
    taxon_id INT REFERENCES dim_taxon(taxon_id),
    fecha_evento DATE,
    metodo_captura TEXT,
    lat_registro NUMERIC,
    lon_registro NUMERIC,
    peso_g NUMERIC,
    altura_cm NUMERIC,
    largo_cm NUMERIC,
    ancho_cm NUMERIC,
    tipo_marca TEXT,
    tipo_liberacion TEXT
);

CREATE TABLE fact_adaptacion (
    adaptacion_sma_id TEXT PRIMARY KEY,
    individuo_sma_id TEXT,
    campana_sma_id TEXT REFERENCES dim_campana(campana_sma_id),
    estacion_replica_sma_id TEXT REFERENCES dim_estacion(estacion_replica_sma_id),
    taxon_id INT REFERENCES dim_taxon(taxon_id),
    tipo_accion TEXT,
    fecha_evento DATE,
    lat_registro NUMERIC,
    lon_registro NUMERIC,
    peso_g NUMERIC,
    altura_cm NUMERIC,
    largo_cm NUMERIC,
    ancho_cm NUMERIC,
    estado_organismo TEXT
);