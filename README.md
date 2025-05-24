# API de Gestión de Clientes

Este repositorio contiene una implementación serverless de una API REST para la gestión de clientes utilizando servicios de AWS.

## Arquitectura

El proyecto implementa una arquitectura serverless utilizando los siguientes servicios de AWS:

- **API Gateway**: Para la exposición de endpoints REST
- **Lambda**: Para la lógica de negocio
- **DynamoDB**: Como base de datos NoSQL
- **IAM**: Para la gestión de permisos y roles

### Diagrama de Arquitectura

```
Cliente HTTP → API Gateway → Lambda → DynamoDB
```

## Estructura del Proyecto

```
.
├── build/                  # Directorio de artefactos compilados
├── functions/             # Funciones Lambda
│   ├── get-clientes/     # Lambda para listar clientes
│   └── get-cliente-by-id/ # Lambda para obtener cliente por ID
├── terraform/            # Infraestructura como código
│   ├── dynamodb/        # Módulo para recursos DynamoDB
│   ├── lambda/          # Módulo para recursos Lambda
│   ├── openapi/         # Definiciones OpenAPI/Swagger
│   ├── main.tf          # Configuración principal de Terraform
│   ├── variables.tf     # Variables globales
│   └── apigateway.tf    # Configuración de API Gateway
└── package.json         # Dependencias y scripts de construcción
```

## Endpoints de la API

### GET /clientes
- **Descripción**: Obtiene la lista de todos los clientes
- **Respuesta**: Array de objetos cliente
- **Códigos de Estado**:
  - 200: Éxito
  - 500: Error interno

### GET /clientes/{id}
- **Descripción**: Obtiene un cliente específico por ID
- **Parámetros**: id (path parameter)
- **Respuesta**: Objeto cliente
- **Códigos de Estado**:
  - 200: Éxito
  - 400: ID no proporcionado
  - 404: Cliente no encontrado
  - 500: Error interno

## Tecnologías Utilizadas

- **Node.js**: Runtime para las funciones Lambda
- **AWS SDK v3**: Cliente para interactuar con servicios AWS
- **Terraform**: Para la infraestructura como código
- **esbuild**: Para el empaquetado de las funciones Lambda
- **GitHub Actions**: Para CI/CD

## Configuración del Proyecto

### Prerrequisitos

- Node.js >= 20.x
- Terraform >= 1.3
- AWS CLI configurado
- Yarn o npm

### Variables de Entorno

Las funciones Lambda utilizan las siguientes variables de entorno:
- `DYNAMODB_TABLE_NAME`: Nombre de la tabla DynamoDB

Para GitHub Actions, necesitas configurar los siguientes secrets:
- `AWS_ACCESS_KEY_ID`: ID de clave de acceso de AWS
- `AWS_SECRET_ACCESS_KEY`: Clave secreta de AWS

### Scripts de Construcción

```bash
# Construir todas las funciones Lambda
yarn build:all

# Construir función get-clientes
yarn build:get-clientes

# Construir función get-cliente-by-id
yarn build:get-cliente-by-id
```

## Despliegue

### Despliegue Manual

1. Construir las funciones Lambda:
```bash
yarn build:all
```

2. Inicializar Terraform:
```bash
cd terraform
terraform init
```

3. Revisar los cambios:
```bash
terraform plan
```

4. Aplicar los cambios:
```bash
terraform apply
```

### Despliegue Automático (CI/CD)

El proyecto utiliza GitHub Actions para el despliegue automático. El pipeline se activa cuando:

1. Se realizan cambios en:
   - Código de funciones Lambda (`functions/**`)
   - Archivos de Terraform (`terraform/**`)
   - Package.json

2. El pipeline ejecuta:
   - Compilación de funciones Lambda
   - Validación de Terraform
   - Plan de Terraform
   - Aplicación de cambios (solo en main)

## Estructura de Módulos Terraform

### Módulo Lambda
- Gestiona las funciones Lambda y sus permisos
- Define roles IAM y políticas
- Configura variables de entorno
- Incluye proceso de build automático

### Módulo DynamoDB
- Define la tabla de clientes
- Configura la clave primaria (Id_Cliente)
- Establece el modo de facturación

### API Gateway
- Implementa API REST
- Utiliza definición OpenAPI/Swagger
- Configura integraciones con Lambda

## Seguridad

- Roles IAM con mínimos privilegios
- Políticas específicas por función
- Logs habilitados en CloudWatch
- Despliegue automatizado seguro
- Validación de cambios antes del despliegue

## Mantenimiento

Para agregar nuevas funciones Lambda:

1. Crear nuevo directorio en `functions/`
2. Agregar script de construcción en `package.json`
3. Definir recursos en Terraform
4. Actualizar la definición OpenAPI
5. Los cambios se desplegarán automáticamente al hacer push

## Contribución

1. Crear rama feature
2. Realizar cambios
3. Ejecutar pruebas
4. Crear Pull Request

Los cambios se desplegarán automáticamente al hacer merge a main. 