# Madema | Post LinkedIn (n8n Workflow)

##  Descripción General

Este workflow automatiza la generación y publicación de contenido en LinkedIn para **Natalia Márquez (SDR en MADEMA)**.

El flujo:

1. Analiza noticias recientes desde RSS
2. Valida que el tema no esté repetido
3. Genera contenido con OpenAI
4. Genera imagen con IA
5. Publica en LinkedIn (perfil y página)
6. Guarda registro en Airtable
7. Envía notificación por Telegram (éxito o error)

---

#  Trigger

**Schedule Trigger**

Ejecuta:
- Lunes
- Miércoles
- Viernes
- 10:00 AM

---

#  Arquitectura del Flujo

## 1️⃣ Ingesta de Contenido

- RSS (Google News – facility management)
- Limpieza y normalización de datos
- Generación de hash para evitar duplicados

---

## 2️⃣ Validación Editorial

- Consulta Airtable (posts recientes)
- Compara semánticamente con memoria
- Evita repetición temática (±30 días)

---

## 3️⃣ Generación de Contenido

OpenAI genera:

- tema
- caption (120–300 palabras)
- copy_imagen
- text_image_prompt

Se aplican reglas:
- Rotación temática
- Enfoque B2B
- Enfoque en facilities y cumplimiento normativo
- Alternancia oficina/planta
- CTA moderado

---

## 4️⃣ Generación de Imagen

- OpenAI genera imagen
- Placid aplica plantilla visual corporativa
- Estilo:
  - Photo-realistic
  - Entorno corporativo/industrial
  - Paleta neutra + acento verde
  - Sin texto incrustado

---

## 5️⃣ Publicación en LinkedIn

Se publica mediante Blotato en:

- Perfil personal
- Página corporativa Madema

---

## 6️⃣ Registro en Airtable

Se guarda:

- Caption
- Plantilla utilizada
- Fecha
- Status (Done)

---

## 7️⃣ Notificaciones

Telegram envía:

-  Confirmación de publicación exitosa
-  Aviso de error si falla

---

#  Credenciales Necesarias en n8n

Este JSON no incluye secretos.

Antes de ejecutar el workflow en otra instancia debes crear estas credenciales:

- OpenAI API
- Airtable Token API
- Placid API
- Blotato API
- Telegram Bot Token

Recomendación:

Nombrarlas por cliente para evitar confusión:

- OPENAI_MADEMA
- AIRTABLE_MADEMA
- PLACID_MADEMA
- BLOTATO_MADEMA
- TELEGRAM_MADEMA

---

#  Variables de Entorno

Las variables de entorno permiten configurar valores sin hardcodearlos dentro del workflow.

Se documentan en `env.example`.

Ejemplo:

MADEMA_AIRTABLE_BASE_ID=
MADEMA_AIRTABLE_TABLE_POSTS=
MADEMA_AIRTABLE_TABLE_REDES=
MADEMA_TELEGRAM_CHAT_ID=
MADEMA_BLOTATO_ACCOUNT_ID=
MADEMA_LINKEDIN_PAGE_ID=
MADEMA_RSS_URL=


## ¿Por qué usar variables de entorno?

Permiten:

- Separación clara por cliente
- Portabilidad entre servidores
- Cambiar configuraciones sin editar nodos
- Evitar exponer valores sensibles

En n8n se pueden usar así:


Actualmente algunos IDs están definidos directamente en nodos.
Se recomienda migrarlos progresivamente a variables de entorno.

---

#  Estructura del Repositorio

workflows/
madema/
madema-post-linkedin.json

docs/
madema-post-linkedin.md

.env.example
.gitignore
README.md


---

#  Cómo Importar el Workflow

1. Ir a n8n
2. Workflows → Import from File
3. Seleccionar `madema-post-linkedin.json`
4. Reasignar credenciales
5. Ejecutar prueba manual
6. Activar

---
#  Flujo de Versionado

Cada vez que se haga un cambio en n8n:

1. Guardar cambios
2. Descargar el JSON nuevamente
3. Reemplazar el archivo en `workflows/madema/`
4. Ejecutar:

git add .
git commit -m "feat(madema): descripción del cambio"
git push


El repositorio es la fuente histórica de verdad.

---

#  Buenas Prácticas

- No editar el JSON manualmente
- No subir `.env`
- No subir API keys
- Separar workflows por cliente
- Nombrar credenciales por cliente
- Documentar cambios relevantes

---

#  Estado del Workflow

Cliente: Madema  
Tipo: Producción  
Frecuencia: 3 veces por semana  
Objetivo: Generación y publicación automatizada en LinkedIn  
