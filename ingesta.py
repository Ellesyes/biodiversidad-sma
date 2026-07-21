import pandas as pd
from sqlalchemy import create_engine

# Leer el CSV (recuerda: separador ; y decimal .)
df = pd.read_csv(
    "data/Biobio_2023.csv",
    sep=";",
    decimal=".",
    encoding="utf-8-sig",  # antes: "latin-1"
    low_memory=False        # nuevo
)

# Ver que se leyó bien: forma y primeras filas
print(f"El archivo tiene {df.shape[0]} filas y {df.shape[1]} columnas")
print(df.head())

# Crear la base de datos SQLite y guardar los datos crudos
engine = create_engine("sqlite:///biodiversidad.db")
df.to_sql("monitoreo_raw", engine, if_exists="replace", index=False)

print("¡Listo! Datos guardados en biodiversidad.db, tabla monitoreo_raw")