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