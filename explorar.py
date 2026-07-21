import pandas as pd
from sqlalchemy import create_engine

engine = create_engine("sqlite:///biodiversidad.db")
df = pd.read_sql("SELECT * FROM monitoreo_raw", engine)

print("\n--- Especies más registradas ---")
print(df['NombreComun'].value_counts().head(10))

print("\n--- Comunas con más registros ---")
print(df['Comuna'].value_counts().head(10))

print("\n--- Rango de fechas ---")
print(df['FechaEvento'].min(), "a", df['FechaEvento'].max())

df['NombreComun'].value_counts().to_csv("especies_biobio.csv")
print("Guardado en especies_biobio.csv — ábrelo con doble clic")