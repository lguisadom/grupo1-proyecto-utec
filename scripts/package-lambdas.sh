#!/bin/bash

# Crear directorio build si no existe
mkdir -p build

# Limpiar archivos ZIP existentes
rm -f build/*.zip

# Empaquetar get-clientes
cd functions/shared
zip -r ../../build/get-clientes.zip node_modules
cd ../get-clientes
zip -r ../../build/get-clientes.zip get-clientes.mjs

# Empaquetar get-cliente-by-id
cd ../shared
zip -r ../../build/get-cliente-by-id.zip node_modules
cd ../get-cliente-by-id
zip -r ../../build/get-cliente-by-id.zip get-cliente-by-id.mjs 