-- ============================================================
-- Transformación: raw (JSONB) -> modelo normalizado (dim/fact)
-- Es idempotente: se puede correr muchas veces sin duplicar,
-- gracias a ON CONFLICT DO NOTHING sobre las llaves únicas.
-- ============================================================

-- ---------- 1. DIM_CAMPANA ----------
-- (se alimenta de las 3 tablas raw, porque las 3 tienen campañas)

INSERT INTO dim_campana (campana_sma_id, documento_id, nombre_campana, ano_inicio, fecha_inicio, fecha_termino, objetivo_campana, informe_id)
SELECT DISTINCT ON (datos->>'CampanaSmaId')
    datos->>'CampanaSmaId',
    datos->>'DocumentoId',
    datos->>'NombreCampana',
    safe_int(datos->>'AnoInicio'),
    safe_date(datos->>'FechaInicio'),
    safe_date(datos->>'FechaTermino'),
    datos->>'ObjetivoCampana',
    datos->>'InformeId'
FROM raw_monitoreo
WHERE datos->>'CampanaSmaId' IS NOT NULL
ON CONFLICT (campana_sma_id) DO NOTHING;

INSERT INTO dim_campana (campana_sma_id, documento_id, nombre_campana, ano_inicio, fecha_inicio, fecha_termino, objetivo_campana, informe_id)
SELECT DISTINCT ON (datos->>'CampanaSmaId')
    datos->>'CampanaSmaId',
    datos->>'DocumentoId',
    datos->>'NombreCampana',
    safe_int(datos->>'AnoInicio'),
    safe_date(datos->>'FechaInicio'),
    safe_date(datos->>'FechaTermino'),
    datos->>'ObjetivoCampana',
    datos->>'InformeId'
FROM raw_captura
WHERE datos->>'CampanaSmaId' IS NOT NULL
ON CONFLICT (campana_sma_id) DO NOTHING;

INSERT INTO dim_campana (campana_sma_id, documento_id, nombre_campana, ano_inicio, fecha_inicio, fecha_termino, objetivo_campana, informe_id)
SELECT DISTINCT ON (datos->>'CampanaSmaId')
    datos->>'CampanaSmaId',
    datos->>'DocumentoId',
    datos->>'NombreCampana',
    safe_int(datos->>'AnoInicio'),
    safe_date(datos->>'FechaInicio'),
    safe_date(datos->>'FechaTermino'),
    datos->>'ObjetivoCampana',
    datos->>'InformeId'
FROM raw_adaptacion
WHERE datos->>'CampanaSmaId' IS NOT NULL
ON CONFLICT (campana_sma_id) DO NOTHING;


-- ---------- 2. DIM_ESTACION ----------

INSERT INTO dim_estacion (estacion_replica_sma_id, nombre_estacion, tipo_monitoreo, rescate_adaptacion_relocalizacion,
    region, provincia, comuna, localidad, ecosistema_nivel1, ecosistema_nivel2, exposicion,
    largo_m, ancho_m, radio_m, superficie_m2, lat_central, lon_central)
SELECT DISTINCT ON (datos->>'EstacionReplicaSmaId')
    datos->>'EstacionReplicaSmaId',
    datos->>'NombreEstacion',
    datos->>'TipoMonitoreo',
    datos->>'RescateAdaptacionRelocalizacion',
    datos->>'Region',
    datos->>'Provincia',
    datos->>'Comuna',
    datos->>'Localidad',
    datos->>'EcosistemaNivel1',
    datos->>'EcosistemaNivel2',
    datos->>'Exposicion',
    safe_numeric(datos->>'LargoM'),
    safe_numeric(datos->>'AnchoM'),
    safe_numeric(datos->>'RadioM'),
    safe_numeric(datos->>'SuperficieM2'),
    safe_numeric(datos->>'LatitudDecimalCentral'),
    safe_numeric(datos->>'LongitudDecimalCentral')
FROM raw_monitoreo
WHERE datos->>'EstacionReplicaSmaId' IS NOT NULL
ON CONFLICT (estacion_replica_sma_id) DO NOTHING;

INSERT INTO dim_estacion (estacion_replica_sma_id, nombre_estacion, tipo_monitoreo, rescate_adaptacion_relocalizacion,
    region, provincia, comuna, localidad, ecosistema_nivel1, ecosistema_nivel2, exposicion,
    largo_m, ancho_m, radio_m, superficie_m2, lat_central, lon_central)
SELECT DISTINCT ON (datos->>'EstacionReplicaSmaId')
    datos->>'EstacionReplicaSmaId',
    datos->>'NombreEstacion',
    datos->>'TipoMonitoreo',
    datos->>'RescateAdaptacionRelocalizacion',
    datos->>'Region',
    datos->>'Provincia',
    datos->>'Comuna',
    datos->>'Localidad',
    datos->>'EcosistemaNivel1',
    datos->>'EcosistemaNivel2',
    datos->>'Exposicion',
    safe_numeric(datos->>'LargoM'),
    safe_numeric(datos->>'AnchoM'),
    safe_numeric(datos->>'RadioM'),
    safe_numeric(datos->>'SuperficieM2'),
    safe_numeric(datos->>'LatitudDecimalCentral'),
    safe_numeric(datos->>'LongitudDecimalCentral')
FROM raw_captura
WHERE datos->>'EstacionReplicaSmaId' IS NOT NULL
ON CONFLICT (estacion_replica_sma_id) DO NOTHING;

INSERT INTO dim_estacion (estacion_replica_sma_id, nombre_estacion, tipo_monitoreo, rescate_adaptacion_relocalizacion,
    region, provincia, comuna, localidad, ecosistema_nivel1, ecosistema_nivel2, exposicion,
    largo_m, ancho_m, radio_m, superficie_m2, lat_central, lon_central)
SELECT DISTINCT ON (datos->>'EstacionReplicaSmaId')
    datos->>'EstacionReplicaSmaId',
    datos->>'NombreEstacion',
    datos->>'TipoMonitoreo',
    datos->>'RescateAdaptacionRelocalizacion',
    datos->>'Region',
    datos->>'Provincia',
    datos->>'Comuna',
    datos->>'Localidad',
    datos->>'EcosistemaNivel1',
    datos->>'EcosistemaNivel2',
    datos->>'Exposicion',
    safe_numeric(datos->>'LargoM'),
    safe_numeric(datos->>'AnchoM'),
    safe_numeric(datos->>'RadioM'),
    safe_numeric(datos->>'SuperficieM2'),
    safe_numeric(datos->>'LatitudDecimalCentral'),
    safe_numeric(datos->>'LongitudDecimalCentral')
FROM raw_adaptacion
WHERE datos->>'EstacionReplicaSmaId' IS NOT NULL
ON CONFLICT (estacion_replica_sma_id) DO NOTHING;


-- ---------- 3. DIM_TAXON ----------

INSERT INTO dim_taxon (reino, filo_division, clase, orden, familia, genero, subgenero, epiteto_especifico, epiteto_infraespecifico, nombre_comun)
SELECT DISTINCT ON (datos->>'Genero', datos->>'EpitetoEspecifico', datos->>'EpitetoInfraespecifico')
    datos->>'Reino', datos->>'FiloDivision', datos->>'Clase', datos->>'Orden',
    datos->>'Familia', datos->>'Genero', datos->>'Subgenero',
    datos->>'EpitetoEspecifico', datos->>'EpitetoInfraespecifico', datos->>'NombreComun'
FROM raw_monitoreo
ON CONFLICT (genero, epiteto_especifico, epiteto_infraespecifico) DO NOTHING;

INSERT INTO dim_taxon (reino, filo_division, clase, orden, familia, genero, subgenero, epiteto_especifico, epiteto_infraespecifico, nombre_comun)
SELECT DISTINCT ON (datos->>'Genero', datos->>'EpitetoEspecifico', datos->>'EpitetoInfraespecifico')
    datos->>'Reino', datos->>'FiloDivision', datos->>'Clase', datos->>'Orden',
    datos->>'Familia', datos->>'Genero', datos->>'Subgenero',
    datos->>'EpitetoEspecifico', datos->>'EpitetoInfraespecifico', datos->>'NombreComun'
FROM raw_captura
ON CONFLICT (genero, epiteto_especifico, epiteto_infraespecifico) DO NOTHING;

INSERT INTO dim_taxon (reino, filo_division, clase, orden, familia, genero, subgenero, epiteto_especifico, epiteto_infraespecifico, nombre_comun)
SELECT DISTINCT ON (datos->>'Genero', datos->>'EpitetoEspecifico', datos->>'EpitetoInfraespecifico')
    datos->>'Reino', datos->>'FiloDivision', datos->>'Clase', datos->>'Orden',
    datos->>'Familia', datos->>'Genero', datos->>'Subgenero',
    datos->>'EpitetoEspecifico', datos->>'EpitetoInfraespecifico', datos->>'NombreComun'
FROM raw_adaptacion
ON CONFLICT (genero, epiteto_especifico, epiteto_infraespecifico) DO NOTHING;


-- ---------- 4. FACT_OCURRENCIA ----------

INSERT INTO fact_ocurrencia (ocurrencia_sma_id, campana_sma_id, estacion_replica_sma_id, taxon_id,
    fecha_evento, hora_inicio_evento, lat_registro, lon_registro,
    tipo_cuantificacion, valor, unidad_valor, estado_organismo, condicion_reproductiva, sexo_fauna, codigo_individuo)
SELECT
    r.datos->>'OcurrenciaSmaId',
    r.datos->>'CampanaSmaId',
    r.datos->>'EstacionReplicaSmaId',
    t.taxon_id,
    safe_date(r.datos->>'FechaEvento'),
    safe_time(r.datos->>'HoraInicioEvento'),
    safe_numeric(r.datos->>'LatitudDecimalRegistro'),
    safe_numeric(r.datos->>'LongitudDecimalRegistro'),
    r.datos->>'TipoCuantificacion',
    safe_numeric(r.datos->>'Valor'),
    r.datos->>'UnidadValor',
    r.datos->>'EstadoOrganismo',
    r.datos->>'CondicionReproductiva',
    r.datos->>'SexoFauna',
    r.datos->>'CodigoIndividuo'
FROM raw_monitoreo r
LEFT JOIN dim_taxon t
    ON t.genero IS NOT DISTINCT FROM r.datos->>'Genero'
    AND t.epiteto_especifico IS NOT DISTINCT FROM r.datos->>'EpitetoEspecifico'
    AND t.epiteto_infraespecifico IS NOT DISTINCT FROM r.datos->>'EpitetoInfraespecifico'
WHERE r.datos->>'OcurrenciaSmaId' IS NOT NULL
ON CONFLICT (ocurrencia_sma_id) DO NOTHING;


-- ---------- 5. FACT_CAPTURA ----------

INSERT INTO fact_captura (captura_sma_id, individuo_sma_id, campana_sma_id, estacion_replica_sma_id, taxon_id,
    fecha_evento, metodo_captura, lat_registro, lon_registro, peso_g, altura_cm, largo_cm, ancho_cm, tipo_marca, tipo_liberacion)
SELECT
    r.datos->>'CapturaSmaId',
    r.datos->>'IndividuoSmaId',
    r.datos->>'CampanaSmaId',
    r.datos->>'EstacionReplicaSmaId',
    t.taxon_id,
    safe_date(r.datos->>'FechaEvento'),
    r.datos->>'MetodoCaptura',
    safe_numeric(r.datos->>'LatitudDecimalRegistro'),
    safe_numeric(r.datos->>'LongitudDecimalRegistro'),
    safe_numeric(r.datos->>'PesoG'),
    safe_numeric(r.datos->>'AlturaCm'),
    safe_numeric(r.datos->>'LargoCm'),
    safe_numeric(r.datos->>'AnchoCm'),
    r.datos->>'TipoMarca',
    r.datos->>'TipoLiberacion'
FROM raw_captura r
LEFT JOIN dim_taxon t
    ON t.genero IS NOT DISTINCT FROM r.datos->>'Genero'
    AND t.epiteto_especifico IS NOT DISTINCT FROM r.datos->>'EpitetoEspecifico'
    AND t.epiteto_infraespecifico IS NOT DISTINCT FROM r.datos->>'EpitetoInfraespecifico'
WHERE r.datos->>'CapturaSmaId' IS NOT NULL
ON CONFLICT (captura_sma_id) DO NOTHING;


-- ---------- 6. FACT_ADAPTACION ----------

INSERT INTO fact_adaptacion (adaptacion_sma_id, individuo_sma_id, campana_sma_id, estacion_replica_sma_id, taxon_id,
    tipo_accion, fecha_evento, lat_registro, lon_registro, peso_g, altura_cm, largo_cm, ancho_cm, estado_organismo)
SELECT
    r.datos->>'AdaptacionSmaId',
    r.datos->>'IndividuoSmaId',
    r.datos->>'CampanaSmaId',
    r.datos->>'EstacionReplicaSmaId',
    t.taxon_id,
    r.datos->>'TipoAccion',
    safe_date(r.datos->>'FechaEvento'),
    safe_numeric(r.datos->>'LatitudDecimalRegistro'),
    safe_numeric(r.datos->>'LongitudDecimalRegistro'),
    safe_numeric(r.datos->>'PesoG'),
    safe_numeric(r.datos->>'AlturaCm'),
    safe_numeric(r.datos->>'LargoCm'),
    safe_numeric(r.datos->>'AnchoCm'),
    r.datos->>'EstadoOrganismo'
FROM raw_adaptacion r
LEFT JOIN dim_taxon t
    ON t.genero IS NOT DISTINCT FROM r.datos->>'Genero'
    AND t.epiteto_especifico IS NOT DISTINCT FROM r.datos->>'EpitetoEspecifico'
    AND t.epiteto_infraespecifico IS NOT DISTINCT FROM r.datos->>'EpitetoInfraespecifico'
WHERE r.datos->>'AdaptacionSmaId' IS NOT NULL
ON CONFLICT (adaptacion_sma_id) DO NOTHING;