import os
import glob
import json
import pandas as pd
from sqlalchemy import create_engine, text

engine = create_engine("postgresql://dvielma@localhost:5432/biodiversidad")

BASE = "data/Biodiversidad"

# (carpeta física, tabla destino)
RUTAS = [
    (os.path.join(BASE, "Datos_Monitoreo"), "raw_monitoreo"),
    (os.path.join(BASE, "Datos_Rescate", "Captura"), "raw_captura"),
    (os.path.join(BASE, "Datos_Rescate", "AdaptacionRelocalizacion"), "raw_adaptacion"),
]

def leer_csv(path):
    return pd.read_csv(path, sep=";", decimal=".", encoding="utf-8-sig", low_memory=False)

def cargar_archivo(path, tabla, region, conn):
    df = leer_csv(path)
    nombre_archivo = os.path.basename(path)
    anio = "".join(filter(str.isdigit, nombre_archivo))[:4] or None

    registros = []
    for _, fila in df.iterrows():
        registros.append({
            "region_archivo": region,
            "anio_archivo": anio,
            "archivo_origen": nombre_archivo,
            "datos": json.dumps(fila.dropna().to_dict(), default=str),
        })

    if registros:
        conn.execute(
            text("""
                INSERT INTO {tabla} (region_archivo, anio_archivo, archivo_origen, datos)
                VALUES (:region_archivo, :anio_archivo, :archivo_origen, :datos)
            """.format(tabla=tabla)),
            registros
        )

def main():
    total_archivos = 0
    with engine.begin() as conn:
        for carpeta_base, tabla in RUTAS:
            regiones = [d for d in os.listdir(carpeta_base) if os.path.isdir(os.path.join(carpeta_base, d))]
            for region in regiones:
                carpeta_region = os.path.join(carpeta_base, region)
                archivos = glob.glob(os.path.join(carpeta_region, "*.csv"))
                for archivo in archivos:
                    print(f"Cargando: {archivo} -> {tabla}")
                    cargar_archivo(archivo, tabla, region, conn)
                    total_archivos += 1

    print(f"\n¡Listo! {total_archivos} archivos procesados.")

if __name__ == "__main__":
    main()