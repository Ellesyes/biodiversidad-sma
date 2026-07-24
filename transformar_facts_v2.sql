-- ============================================================
-- FACT tables, usando taxon_key (equality join, indexable)
-- en vez de IS NOT DISTINCT FROM. Solo se corren estas 3
-- inserciones porque dim_campana, dim_estacion y dim_taxon
-- ya quedaron completas en el intento anterior (idempotente).
-- ============================================================

-- ---------- FACT_OCURRENCIA ----------

INSERT INTO fact_ocurrencia (ocurrencia_sma_id, campana_sma_id, estacion_replica_sma_id, taxon_id,
    fecha_evento, hora_inicio_evento, lat_registro, lon_registro,
    tipo_cuantificacion, valor, unidad_valor, estado_organismo, condicion_reproductiva, sexo_fauna, codigo_individuo)
SELECT
    r.datos->>'OcurrenciaSmaId', r.datos->>'CampanaSmaId', r.datos->>'EstacionReplicaSmaId', t.taxon_id,
    safe_date(r.datos->>'FechaEvento'),
    safe_time(r.datos->>'HoraInicioEvento'),
    safe_numeric(r.datos->>'LatitudDecimalRegistro'),
    safe_numeric(r.datos->>'LongitudDecimalRegistro'),
    r.datos->>'TipoCuantificacion', safe_numeric(r.datos->>'Valor'), r.datos->>'UnidadValor',
    r.datos->>'EstadoOrganismo', r.datos->>'CondicionReproductiva', r.datos->>'SexoFauna', r.datos->>'CodigoIndividuo'
FROM raw_monitoreo r
LEFT JOIN dim_taxon t
    ON t.taxon_key = COALESCE(r.datos->>'Genero', '') || '|' || COALESCE(r.datos->>'EpitetoEspecifico', '') || '|' || COALESCE(r.datos->>'EpitetoInfraespecifico', '')
WHERE r.datos->>'OcurrenciaSmaId' IS NOT NULL
ON CONFLICT (ocurrencia_sma_id) DO NOTHING;


-- ---------- FACT_CAPTURA ----------

INSERT INTO fact_captura (captura_sma_id, individuo_sma_id, campana_sma_id, estacion_replica_sma_id, taxon_id,
    fecha_evento, metodo_captura, lat_registro, lon_registro, peso_g, altura_cm, largo_cm, ancho_cm, tipo_marca, tipo_liberacion)
SELECT
    r.datos->>'CapturaSmaId', r.datos->>'IndividuoSmaId', r.datos->>'CampanaSmaId', r.datos->>'EstacionReplicaSmaId', t.taxon_id,
    safe_date(r.datos->>'FechaEvento'), r.datos->>'MetodoCaptura',
    safe_numeric(r.datos->>'LatitudDecimalRegistro'),
    safe_numeric(r.datos->>'LongitudDecimalRegistro'),
    safe_numeric(r.datos->>'PesoG'), safe_numeric(r.datos->>'AlturaCm'),
    safe_numeric(r.datos->>'LargoCm'), safe_numeric(r.datos->>'AnchoCm'),
    r.datos->>'TipoMarca', r.datos->>'TipoLiberacion'
FROM raw_captura r
LEFT JOIN dim_taxon t
    ON t.taxon_key = COALESCE(r.datos->>'Genero', '') || '|' || COALESCE(r.datos->>'EpitetoEspecifico', '') || '|' || COALESCE(r.datos->>'EpitetoInfraespecifico', '')
WHERE r.datos->>'CapturaSmaId' IS NOT NULL
ON CONFLICT (captura_sma_id) DO NOTHING;


-- ---------- FACT_ADAPTACION ----------

INSERT INTO fact_adaptacion (adaptacion_sma_id, individuo_sma_id, campana_sma_id, estacion_replica_sma_id, taxon_id,
    tipo_accion, fecha_evento, lat_registro, lon_registro, peso_g, altura_cm, largo_cm, ancho_cm, estado_organismo)
SELECT
    r.datos->>'AdaptacionSmaId', r.datos->>'IndividuoSmaId', r.datos->>'CampanaSmaId', r.datos->>'EstacionReplicaSmaId', t.taxon_id,
    r.datos->>'TipoAccion', safe_date(r.datos->>'FechaEvento'),
    safe_numeric(r.datos->>'LatitudDecimalRegistro'),
    safe_numeric(r.datos->>'LongitudDecimalRegistro'),
    safe_numeric(r.datos->>'PesoG'), safe_numeric(r.datos->>'AlturaCm'),
    safe_numeric(r.datos->>'LargoCm'), safe_numeric(r.datos->>'AnchoCm'),
    r.datos->>'EstadoOrganismo'
FROM raw_adaptacion r
LEFT JOIN dim_taxon t
    ON t.taxon_key = COALESCE(r.datos->>'Genero', '') || '|' || COALESCE(r.datos->>'EpitetoEspecifico', '') || '|' || COALESCE(r.datos->>'EpitetoInfraespecifico', '')
WHERE r.datos->>'AdaptacionSmaId' IS NOT NULL
ON CONFLICT (adaptacion_sma_id) DO NOTHING;