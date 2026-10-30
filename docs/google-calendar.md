# Conexión y consulta de Google Calendar

## Configuración

1. Aplicar las migraciones pendientes de `supabase/migrations` en orden, incluida `202610300002_calendar_preferences.sql`. Las preferencias se guardan por usuario con RLS; no contienen tokens.
2. En Google Cloud habilitar Calendar API y crear un cliente OAuth de tipo Aplicación web.
3. Configurar la pantalla de consentimiento y usuarios de prueba si el proyecto está en modo Testing.
4. Añadir el origen de desarrollo (`http://localhost:5173`) y el origen publicado a los orígenes JavaScript autorizados. Este flujo usa Google Identity Services con ventana emergente, no una URL de callback del Worker ni el callback de Supabase.
5. Añadir `VITE_GOOGLE_CLIENT_ID=...apps.googleusercontent.com` a `.env.local` y reiniciar Vite. Para producción, definirlo durante la compilación. El Client ID es público; no añadir Client Secret al navegador.
6. Iniciar sesión en MuseArt, abrir Google Calendar y pulsar Conectar. Autorizar la lectura de la lista de calendarios y acceso a eventos.
7. Elegir el calendario principal (requiere rol owner o writer), seleccionar otros calendarios para consultar y guardar.

## Comportamiento

- Conectar Calendar es independiente de iniciar sesión mediante Supabase.
- Las preferencias se conservan en Supabase. El token de Google vive solo en memoria del navegador; no se guarda en localStorage ni en la base de datos.
- El token caduca y se pierde al recargar. Hay que volver a conectar para consultar; la renovación automática con refresh tokens en el backend aún está pendiente.
- Al guardar un evento, se consultan los eventos que se superponen en el calendario principal y los adicionales. Se ignoran eventos cancelados y transparentes. El usuario puede guardar aunque exista una coincidencia.
- Si Google rechaza la consulta o el acceso caduca, la aplicación informa de que no pudo comprobar disponibilidad y permite guardar igualmente.
- Actualmente se requieren calendarios con lectura de detalles (reader, writer u owner); no se admiten calendarios que solo expongan free/busy.
- No se importan ni escriben eventos en Google todavía. El calendario principal se registra como preferencia para la futura sincronización.
- Al cambiar de cuenta Google, revisar y guardar de nuevo los calendarios seleccionados. Una selección inaccesible produce una advertencia al comprobar disponibilidad, nunca se interpreta como libre.

## Verificación manual con cuentas reales

Crear un evento en un calendario adicional y luego una actuación con el mismo horario en MuseArt: debe aparecer una advertencia que permita guardar. Repetir sin solapamiento, con autorización caducada y con acceso revocado. Confirmar que un segundo usuario no puede leer ni modificar las preferencias del primero. La validación automatizada usa respuestas simuladas, no demuestra configuración OAuth ni RLS en un proyecto remoto.
