# API de Siniestros

Este repositorio contiene una implementación serverless de una API REST para gestión de Siniestros utilizando servicios de AWS.

## Documentación
La documentación completa de la API está disponible en:
[Documentación OpenAPI](https://lguisadom.github.io/grupo1-proyecto-utec/#/)

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
├── docs/                   # Documentación de la API
│   ├── index.html         # Documentación interactiva
│   └── openapi.yaml       # Especificación OpenAPI
├── functions/             # Funciones Lambda
│   ├── get-clientes/     # Lambda para listar clientes
│   └── get-cliente-by-id/ # Lambda para obtener cliente por ID
├── scripts/              # Scripts de utilidad
├── terraform/            # Infraestructura como código
│   ├── dynamodb/        # Módulo para recursos DynamoDB
│   ├── lambda/          # Módulo para recursos Lambda
│   ├── openapi/         # Definiciones OpenAPI/Swagger
│   ├── main.tf          # Configuración principal de Terraform
│   ├── variables.tf     # Variables globales
│   ├── backend.tf       # Configuración del backend
│   ├── backend_infra.tf # Infraestructura del backend
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

- **Node.js**: Runtime para las funciones Lambda (Node.js 20)
- **AWS SDK v3**: Cliente para interactuar con servicios AWS
  - @aws-sdk/client-dynamodb: ^3.817.0
  - @aws-sdk/lib-dynamodb: ^3.817.0
- **Terraform**: Para la infraestructura como código
- **esbuild**: Para el empaquetado de las funciones Lambda (^0.25.4)
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

## Infraestructura como Código (Terraform)

### Estructura de Directorios
```
terraform/
├── main.tf              # Configuración principal y módulos
├── variables.tf         # Variables globales
├── backend.tf          # Configuración del backend de Terraform
├── backend_infra.tf    # Infraestructura del backend
├── apigateway.tf       # Configuración de API Gateway
├── dynamodb/           # Módulo de DynamoDB
├── lambda/             # Módulo de funciones Lambda
├── glue/              # Módulo de AWS Glue
├── s3/                # Módulo de Amazon S3
└── openapi/           # Definiciones OpenAPI
```

### Configuración Principal (main.tf)
El archivo `main.tf` define la configuración central de la infraestructura:

- **Provider AWS**: Configura la región de AWS donde se desplegarán los recursos
- **Versiones Requeridas**: 
  - Terraform >= 1.3
  - Provider AWS ~> 5.0

### Módulos
La infraestructura está organizada en módulos independientes:

#### 1. Módulo DynamoDB
- **Propósito**: Gestión de la base de datos NoSQL
- **Configuración**:
  - Tabla para almacenamiento de datos de siniestros
  - Configuración de capacidad de lectura/escritura
  - Definición de claves primarias

#### 2. Módulo Lambda
- **Propósito**: Gestión de funciones serverless
- **Características**:
  - Integración con DynamoDB (permisos y accesos)
  - Configuración de memoria y timeout
  - Variables de entorno específicas

#### 3. Módulo Glue
- **Propósito**: Procesamiento de datos ETL
- **Características**:
  - Scripts de transformación de datos
  - Integración con S3 y DynamoDB
  - Configuración de jobs de procesamiento

#### 4. Módulo S3
- **Propósito**: Almacenamiento de objetos
- **Características**:
  - Buckets para scripts de Glue
  - Configuración de políticas de acceso
  - Gestión del ciclo de vida de objetos

### Variables Globales (variables.tf)
Configuración centralizada de variables:

- **env**: Entorno de despliegue (default: "dev")
- **aws_region**: Región de AWS (default: "us-east-1")
- **group**: Identificador de grupo (default: "g1")
- **prefix**: Prefijo para recursos (default: "test-03")

#### Variables de Lambda
- **lmb_timeout**: Tiempo máximo de ejecución (60 segundos)
- **lmb_memory_size**: Memoria asignada (128 MB)
- **lmb_get_clientes_name**: Nombre de la función Lambda

#### Variables de API Gateway
- **api_name**: Nombre del API Gateway (default: "apigateway-siniestros")

### Backend y Estado (backend.tf y backend_infra.tf)
- **Propósito**: Gestión del estado de Terraform
- **Características**:
  - Almacenamiento remoto del estado
  - Bloqueo para prevenir conflictos
  - Infraestructura necesaria para el backend

### API Gateway (apigateway.tf)
- **Propósito**: Exposición de APIs REST
- **Configuración**:
  - Definición de endpoints
  - Integración con funciones Lambda
  - Configuración de seguridad y autenticación

### Consideraciones de Seguridad
1. **IAM**: 
   - Roles y políticas con mínimos privilegios
   - Segregación de permisos por función
   
2. **Networking**:
   - Configuración de VPC (si aplica)
   - Políticas de acceso y seguridad

3. **Logs y Monitoreo**:
   - CloudWatch Logs habilitado
   - Métricas y alertas configuradas

### Despliegue de Infraestructura
1. **Inicialización**:
   ```bash
   terraform init
   ```

2. **Validación**:
   ```bash
   terraform plan
   ```

3. **Aplicación**:
   ```bash
   terraform apply
   ```

4. **Destrucción** (cuando sea necesario):
   ```bash
   terraform destroy
   ```

### Mejores Prácticas Implementadas
1. **Modularización**: Código organizado en módulos reutilizables
2. **Variables**: Uso de variables para configuración flexible
3. **Documentación**: Comentarios y estructura clara
4. **Versionamiento**: Control de versiones de providers y módulos
5. **Seguridad**: Principio de mínimo privilegio 