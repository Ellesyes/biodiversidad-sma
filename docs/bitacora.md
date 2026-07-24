# Bitácora del proyecto — Biodiversidad SMA

## 2026-07-21
- Instalé Python, VS Code y creé un entorno virtual (venv) desde cero.
- Instalé pandas, sqlalchemy y psycopg2-binary.
- Descargué el primer archivo real de la SMA: Biobío_2023.csv (Datos_Monitoreo).
- Escribí `ingesta.py`: lee el CSV (separador ";", decimal ".", encoding utf-8-sig) y lo carga a SQLite (`biodiversidad.db`, tabla `monitoreo_raw`).
- Resultado: 112,262 registros cargados correctamente.
- Escribí `explorar.py` para ver especies más registradas, comunas y rango de fechas.
- Detecté que la columna `NombreComun` tiene muchos valores "No aplica" — pendiente resolver combinando Género + Epíteto específico para no perder esos registros al analizar por especie.
- Configuré Git y GitHub. Creé el repositorio público `biodiversidad-sma` en mi cuenta (Ellesyes).
- Subí el primer commit con los scripts y limpié `.DS_Store` del control de versiones.

### Próximos pasos
- Crear columna combinada de nombre de especie (NombreComun o Género+Epíteto si falta).
- Diseñar y crear las tablas normalizadas (dim_campana, dim_estacion, dim_taxon, fact_ocurrencia).
- Escribir script de transformación raw → normalizado.

## 2026-07-21 11:11
- Instalé PostgreSQL localmente con Postgres.app (corriendo en puerto 5432).
- Creé la base de datos `biodiversidad`.
- Diseñamos el esquema completo en `schema.sql`: 3 dimensiones (dim_campana, dim_estacion, dim_taxon) + 3 tablas de hechos (fact_ocurrencia, fact_captura, fact_adaptacion), con diagrama ER de referencia.
- Ejecuté `schema.sql` contra la base — las 6 tablas quedaron creadas correctamente.
- Intenté descargar la carpeta completa de Drive (16 regiones × Datos_Monitoreo/Datos_Rescate) vía "Descargar" en la web — Drive la dividió en 6 zips y al extraerlos faltó la región Ñuble. Decidí reiniciar la descarga con un método más confiable.

### Pendiente para mañana
- [ ] Instalar Google Drive para escritorio y copiar la carpeta Biodiversidad completa (sin zips) a data/, verificando que estén las 16 regiones y ~754 CSV en Datos_Monitoreo + Datos_Rescate (Captura y AdaptacionRelocalizacion).
- [ ] Escribir el script de ingesta masiva (os.walk por región/año/tipo) que cargue todos los CSV a tablas raw en Postgres.
- [ ] Escribir el script de transformación raw → dim/fact (con upsert idempotente usando los IDs únicos de la SMA).
- [ ] Commit y push a GitHub de los avances.


## 2026-07-22 (continuación)
- Resuelto: la región Ñuble faltaba sistemáticamente en las descargas masivas de Drive (Datos_Monitoreo, Captura y AdaptacionRelocalizacion) — se descargó y agregó manualmente en cada carpeta.
- Confirmado dataset completo: 16 regiones, 1034 archivos CSV en total.
- Creadas tablas raw en Postgres (raw_monitoreo, raw_captura, raw_adaptacion) usando columna JSONB para flexibilidad.
- Escrito y ejecutado `ingesta_masiva.py`: recorre automáticamente las 16 regiones × 3 tipos de tabla y carga cada CSV a su tabla raw correspondiente.
- Los 1034 archivos se procesaron correctamente.
- Corrigido .gitignore: la regla anterior no cubría CSV en subcarpetas anidadas.

### Próximos pasos
- [ ] Confirmar conteo total de filas en las tablas raw.
- [ ] Escribir script de transformación raw → dim/fact (normalizado).
- [ ] Empezar a explorar la data completa (todas las regiones, no solo Biobío).

## 2026-07-22 23:59
- Detectado y resuelto: campos como HoraInicioEvento contienen texto ("No registrada") en vez de valores válidos, lo que rompía las conversiones de tipo.
- Creadas funciones auxiliares en Postgres (safe_date, safe_time, safe_numeric, safe_int) que devuelven NULL en vez de fallar ante datos sucios — patrón robusto para producción.
- Escrito `transformar.sql`: transformación completa raw (JSONB) -> modelo normalizado (dim/fact), usando SQL puro por el volumen (16.8M filas).
- Validado con `transformar_prueba_biobio.sql` (filtro de una sola región): funcionó completo, ~1.47M filas resultantes solo de Biobío, ~10 min de proceso.
- Lanzado `transformar.sql` completo (sin filtro), aprovechando que es idempotente (Biobío no se duplica, solo se agregan las 15 regiones restantes).

### Próximos pasos
- [ ] Confirmar que transformar.sql completo terminó sin errores y contar filas finales en cada tabla dim/fact.
- [ ] Crear índices en las tablas fact (por fecha, región, taxón) para que las consultas sean rápidas.
- [ ] Empezar el primer análisis real: tendencias por especie/región usando el modelo normalizado.
- [ ] Configurar el PATH permanente para psql (evitar escribir la ruta completa cada vez).


## 2026-07-24
- Detectado problema serio de rendimiento: el JOIN entre raw_monitoreo y dim_taxon usaba IS NOT DISTINCT FROM, operador no indexable en Postgres — forzaba a Postgres a comparar cada una de las 16M filas contra las ~26,000 especies una por una (nested loop), en vez de usar un índice. Resultado: el proceso llevaba más de 12 horas corriendo.
- Solución: agregada columna calculada `taxon_key` a dim_taxon (género+epíteto+infraespecífico combinados en un texto), con índice. Cambiado el join a igualdad simple (=) sobre esa llave, permitiendo hash join en vez de nested loop.
- También se optimizaron las funciones safe_* (de EXCEPTION/PLpgSQL a validación por regex en SQL puro) — más rápidas pero no eran el cuello de botella principal, el join sí lo era.
- Transformación completa raw -> dim/fact terminada para las 16 regiones:
  - fact_ocurrencia: 13,089,453 filas
  - fact_captura: 309,143 filas
  - fact_adaptacion: 453,119 filas
- Pendiente confirmar mañana: por qué la cantidad en fact es menor que en raw (¿solo por IDs nulos filtrados, o hay duplicados descartados por ON CONFLICT que valga la pena revisar?).

### Próximos pasos
- [ ] Confirmar que la diferencia raw vs fact se explica completamente por filas sin ID (no por pérdida de datos inesperada).
- [ ] Crear índices adicionales en fact_ocurrencia (fecha_evento, estacion_replica_sma_id) para consultas rápidas.
- [ ] Primera consulta analítica real: especie más registrada por región.
- [ ] Fijar el PATH de psql de forma permanente.