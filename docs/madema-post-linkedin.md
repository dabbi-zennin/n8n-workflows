# Madema | Post LinkedIn (n8n Workflow)

##  Objetivo

Automatizar la generación y publicación de contenido en LinkedIn para MADEMA (perfil + página), utilizando noticias desde RSS y guardando registro en Airtable, con notificación por Telegram.

---

##  Trigger

### Schedule Trigger

- **Frecuencia:** Lunes / Miércoles / Viernes  
- **Hora:** 10:00 AM  

---

##  Arquitectura del flujo (alto nivel)

### 1) Ingesta (RSS)

- RSS Read obtiene items desde Google News (facility management).
- Se normaliza el contenido para preparar inputs de generación.

>  Nota: El RSS entrega campos como `title`, `link`, `pubDate`, `content`.  
> Es clave no perder `link` en nodos posteriores (Set / AI / etc).

---

### 2) Memoria y prevención de repetición

- Se consulta Airtable (posts recientes / memoria).
- Se genera o actualiza contexto para reducir repetición (según reglas del flujo).

---

### 3) Generación del post (OpenAI)

OpenAI genera:

- `titulo`
- `caption`
- `plantilla` (ID o referencia de template)
- `copy_imagen` (opcional)

Salida esperada típica:

- Titulo  
- Caption  
- plantilla  
- (opcional) copy_imagen  

---

### 4) Render de imagen (Placid)

**Placid – Create an image from a template**

- Usa Template by ID.
- Reemplaza layers (por ejemplo títulos/textos).

>  Si aparece “Error fetching options from Placid” en Layer Name, suele ser un tema de credenciales/permiso o de carga del template; aun así se puede ejecutar si los nombres se escriben manualmente correctamente.

---

### 5) Publicación en LinkedIn (Blotato)

**Blotato – Post Create**

- Publica en Perfil (nodo `Perfil1`).
- Publica en Página (nodo `Page1`).
- Media: usa la URL de la imagen subida (nodo `Upload media`).

---

### 6) Registro en Airtable

Guardar mínimo:

- `Caption`
- `Link` (si aplica)
- `Plantilla`
- `Fecha`
- `Status` (Done / Error)

---

### 7) Notificaciones (Telegram)

Envía un mensaje por Telegram:

-  Éxito: "Se realizó el posteo correctamente"
-  Error: "Hubo un error al publicar"

---

##  Credenciales requeridas

- OpenAI  
- Airtable  
- Placid  
- Blotato  
- Telegram  

###  Recomendación de naming por cliente


- OPENAI_MADEMA
- AIRTABLE_MADEMA
- PLACID_MADEMA
- BLOTATO_MADEMA
- TELEGRAM_MADEMA

---

---

##  Variables de entorno (env.example)

```env
MADEMA_AIRTABLE_BASE_ID=
MADEMA_AIRTABLE_TABLE_REDES=
MADEMA_TELEGRAM_CHAT_ID=
MADEMA_RSS_URL=
MADEMA_LINKEDIN_PAGE_ID=
MADEMA_BLOTATO_ACCOUNT_ID=

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
