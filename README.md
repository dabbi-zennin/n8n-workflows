# n8n Workflows Backup & Governance Repository

## 📌 Descripción general

Este repositorio contiene el **respaldo versionado (backup)** de los workflows de **n8n**, con un enfoque **profesional, seguro y auditable**.

El objetivo principal es **preservar la lógica de automatización**, facilitar la **documentación**, permitir **recuperación controlada**, y **evitar la exposición de secretos** (tokens, API keys, credenciales) en sistemas de control de versiones como GitHub.

---

## 🎯 Objetivos del proyecto

- 📦 Mantener **backups confiables** de workflows de n8n  
- 🧠 Conservar la **lógica completa** de cada flujo (nodos, conexiones, expresiones)  
- 🔐 Garantizar que **ningún secreto** quede almacenado en el repositorio  
- 📝 Facilitar la **documentación individual** de cada workflow  
- 🔄 Permitir **restauración controlada** en caso de incidentes  
- 📊 Alinear el manejo de automatizaciones con **buenas prácticas DevOps / SecOps**

---

## 🏗️ Estructura del repositorio

n8n-workflows/

├─ README.md

├─ backup-n8n.ps1 # Script de exportación automática desde n8n

├─ sanitize-workflows.ps1 # Script de saneamiento de secretos

└─ workflows/

├─ <WorkflowName>--<ID>.json

└─ ...


---

## 🔄 Flujo de trabajo implementado

### 1️⃣ Exportación automática de workflows

- Se utiliza la **API oficial de n8n** (`/api/v1/workflows`)
- Los workflows se exportan como **JSON crudo (raw)** para evitar errores de profundidad
- Cada workflow se guarda con el formato:


📌 **Resultado:** backup completo y reproducible de todos los workflows.

---

### 2️⃣ Saneamiento (sanitize) de secretos

Antes de subir los archivos al repositorio:

- Se detectan y eliminan:
  - API tokens (Apify, API Layer, etc.)
  - `Authorization: Bearer ...`
  - `token=...`
  - `apiKey`, `access_key`, `client_secret`, `password`

- Los valores sensibles se reemplazan por:
  - `{{$env.VARIABLE_NAME}}`
  - o `***REDACTED***` cuando aplica

📌 **Resultado:**  
El repositorio **no contiene secretos**, cumpliendo políticas de seguridad y evitando bloqueos por GitHub Push Protection.

---

### 3️⃣ Versionado y control de cambios

- Cada ejecución genera un commit **solo si hay cambios**
- Se mantiene un historial claro para:
  - Auditoría
  - Comparación de versiones
  - Recuperación por **commit hash**

---

## 🔐 Modelo de seguridad adoptado (Regla PRO)

> **GitHub guarda lógica.**  
> **n8n guarda secretos.**  
> **Nunca al revés.**

### En la práctica

- 🔒 Tokens y credenciales viven en:
  - **Environment Variables**
  - **Credentials de n8n**
- 📁 El repositorio contiene solo:
  - lógica
  - estructura
  - referencias a variables (`{{$env...}}`)
- 🚫 Nunca se suben:
  - tokens reales
  - passwords
  - API keys en texto plano

---

## ♻️ Restauración de un workflow (escenario extremo)

1. Seleccionar el commit deseado:
```bash
git checkout <commit-hash>

Importar el JSON del workflow en n8n

Reconectar:

Credentials

Variables de entorno necesarias

Ejecutar pruebas controladas

📌 Nota:
Los JSON del repositorio están pensados como base estructural, no como copia “plug & play” con secretos incluidos.

🛠️ Mejoras implementadas

✅ Automatización completa de backups

✅ Eliminación de secretos del historial Git

✅ Compatibilidad con GitHub Push Protection

✅ Preparación para documentación workflow-por-workflow

✅ Base sólida para auditorías técnicas o handover de proyectos

🔜 Próximos pasos recomendados

📘 Crear un README.md individual por workflow crítico

🗂️ Clasificar workflows por dominio (Leads, Mailing, Inventario, etc.)

⏰ Programar ejecución periódica del backup (Task Scheduler / cron)

🔁 Migrar gradualmente tokens hardcodeados a:

Credentials de n8n

Variables de entorno centralizadas

📊 Añadir diagramas o capturas por flujo documentado
