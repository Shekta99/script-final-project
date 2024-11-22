#!/bin/bash

# Validar si se proporcionó el archivo como argumento
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 archivo_hoja_calculo.ods"
    exit 1
fi

# Variables utilitarias
ARCHIVO="$1"
API_URL="https://mock-backend-project.netlify.app/.netlify/functions/createProduct"

# Convertir el archivo de LibreOffice a CSV
libreoffice --headless --convert-to csv "$ARCHIVO" --outdir . || { 
    echo "Error al convertir el archivo a CSV"; 
    exit 1; 
}

# Determinar el nombre del archivo CSV generado
CSV_ARCHIVO="${ARCHIVO%.*}.csv"

# Asegurarse de que el archivo CSV se creó correctamente
if [ ! -f "$CSV_ARCHIVO" ]; then
    echo "No se pudo crear el archivo CSV."
    exit 1
fi

# Leer el CSV línea por línea, omitiendo la primera fila (titulos)
tail -n +2 "$CSV_ARCHIVO" | while IFS=',' read -r nombre descripcion precio; do
    # Construir el JSON
    JSON_DATA=$(jq -n \
        --arg nombre "$nombre" \
        --arg descripcion "$descripcion" \
        --arg precio "$precio" \
        '{nombre: $nombre, descripcion: $descripcion, precio: $precio}')

    # Enviar el JSON a la API
    RESPONSE=$(curl -s -w "%{http_code}" -o /dev/null \
        -X POST \
        -H "Content-Type: application/json" \
        -d "$JSON_DATA" \
        "$API_URL")

    # Verificar el código de respuesta
    if [ "$RESPONSE" -eq 201 ]; then
        echo "Producto creado: $nombre"
    else
        echo "Error al crear el producto: $nombre (Código HTTP: $RESPONSE)"
    fi
done

# Eliminar archivo CSV temporal
rm -f "$CSV_ARCHIVO"
