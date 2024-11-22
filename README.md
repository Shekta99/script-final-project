# Proyecto: Script Bash para Crear Productos desde Hojas de Cálculo

Este proyecto es un script en Bash que permite leer datos de un archivo de hoja de cálculo de LibreOffice (.ods), convertirlos a formato JSON y enviarlos a una API mediante el método POST para crear productos con nombre, descripción y precio.

## Requisitos Previos

Antes de ejecutar este script, se necesita tener instaladas las siguientes herramientas:

1. **LibreOffice**: Para convertir el archivo .ods a .csv.
   ```bash
   sudo apt-get install libreoffice
   ```
2. **`jq`**: Herramienta para manipular datos JSON.
   ```bash
   sudo apt-get install jq
   ```
3. **`curl`**: Herramienta para realizar solicitudes HTTP.
   ```bash
   sudo apt-get install curl
   ```

## Instrucciones de Uso

### Paso 1: Clonar el Repositorio

Clona este repositorio en tu máquina local:

```bash
git clone https://github.com/Shekta99/script-final-project.git
```

### Paso 2: Configurar Permisos

Asegúrate de que el script tiene permisos de ejecución:

```bash
chmod +x script.sh
```

### Paso 3: Preparar el Archivo de Entrada

Crea un archivo de hoja de cálculo en formato `.ods` con la siguiente estructura:

| Nombre     | Descripción   | Precio |
| ---------- | ------------- | ------ |
| Producto 1 | Descripción 1 | 10.50  |
| Producto 2 | Descripción 2 | 25.00  |

Guarda el archivo con un nombre como `productos.ods`.

### Paso 4: Ejecutar el Script

Ejecuta el script proporcionando el archivo `.ods` como parámetro:

```bash
./script.sh productos.ods
```

### Salida Esperada

El script procesará cada fila del archivo `.ods`, convertirá los datos a JSON y los enviará a la API en la URL:

```
https://mock-backend-project.netlify.app/.netlify/functions/createProduct
```

Por cada producto, verás un mensaje de confirmación o error en la terminal:

- **Éxito**:
  ```
  Producto creado: Producto 1
  ```
- **Error**:
  ```
  Error al crear el producto: Producto 2 (Código HTTP: 400)
  ```

### Paso 5: Limpieza

El script eliminará automáticamente el archivo `.csv` temporal generado durante el proceso.

## Funcionamiento del Script

1. **Conversión del archivo**: Utiliza `libreoffice` en modo headless para convertir el archivo `.ods` a `.csv`.
2. **Procesamiento del archivo CSV**: Usa `tail` para omitir las cabeceras (titulos del archivo) y leer cada línea de datos.
3. **Creación de JSON**: Construye un objeto JSON para cada fila usando `jq`.
4. **Envío a la API**: Usa `curl` para enviar los datos JSON a la API mediante el método POST.

## Estructura del Proyecto

```
.
├── crear_productos.sh   # Script principal
├── README.md            # Este archivo
```

## Notas

- Asegúrate de que el archivo `.ods` no tenga filas vacías o valores no válidos en las columnas.
- Para ver los productos agregados se puede usar este endpoint [https://mock-backend-project.netlify.app/.netlify/functions/getProducts](https://mock-backend-project.netlify.app/.netlify/functions/getProducts)
