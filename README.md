# MuseArt

Agenda y gestión de actuaciones para músicos. React + TypeScript, Supabase opcional y despliegue de recursos estáticos mediante Cloudflare Workers.

## Desarrollo

Requiere Node.js 22 o posterior.

```sh
npm ci --cache /tmp/museart-npm
npm run dev
```

Sin variables de entorno se inicia en modo local: los datos se guardan en el navegador. No introducir información sensible en equipos compartidos. La opción Exportar permite descargar los datos en JSON; todavía no existe importación de copias.

## Supabase

1. Crear un proyecto de desarrollo.
2. Ejecutar los archivos de `supabase/migrations/` en orden de nombre en el editor SQL o mediante el CLI de Supabase. Para una base existente, ejecutar solo las migraciones pendientes. La migración `202610300001_events_grants.sql` concede acceso a la tabla al rol autenticado; las políticas RLS siguen limitando cada usuario a sus propios eventos.
3. Copiar `.env.example` a `.env.local` y completar la URL del proyecto y su clave pública anon. Nunca usar la clave service_role en el frontend.
4. Habilitar acceso por correo en Supabase Auth y configurar la URL del sitio y sus redirecciones autorizadas.
5. Reiniciar Vite; iniciar sesión mediante enlace por correo.

El esquema inicial aplica aislamiento por propietario. La colaboración por espacios de trabajo todavía no está implementada. Los datos locales no se transfieren automáticamente al configurar Supabase.

## Validación

```sh
npm test
npm run build
```

## Cloudflare

```sh
npm run build
npm run worker:dev
npm run deploy
```

El despliegue requiere autenticación y cuenta de Cloudflare. Configurar las variables `VITE_SUPABASE_URL` y `VITE_SUPABASE_ANON_KEY` en el entorno de compilación. Son configuración pública, no credenciales privilegiadas. `/api/health` informa del estado del Worker. Los procesos locales no sobreviven al reinicio del entorno.

## Estado real del proyecto

Implementado: agenda y búsqueda, filtros, edición y cancelación, advertencia de solapamiento, clientes asociados, repertorio y producción en texto, asignación de músicos, cobros y gastos, cálculos financieros, registro de estado del comprobante, exportación JSON, persistencia local, adaptador Supabase con acceso por correo y esquema inicial con RLS, Worker estático y CI.

Pendiente antes de un lanzamiento completo: sincronización Google Calendar/OAuth/outbox/webhooks; modelo normalizado por espacios de trabajo; auditoría e inmutabilidad financiera; devoluciones; catálogo independiente de clientes y músicos; ensayos estructurados; archivos; comprobantes adjuntos; zonas horarias explícitas (actualmente horarios locales del navegador); accesibilidad completa del diálogo; pruebas de navegador, aislamiento con Supabase real, carga y restauración. No se ha validado despliegue remoto ni servicios con credenciales reales. Esta versión es una base funcional, no el cumplimiento completo de la especificación.

Los movimientos financieros actualmente son editables; no utilizar como registro contable definitivo hasta implementar auditoría y correcciones trazables. Las tarifas de músicos se incluyen en previsión y sus pagos en caja: no repetirlos como gastos.

Ver [especificación completa](docs/requerimientos.md).

## Google Calendar: preferencias y detección de cruces

La pestaña Google Calendar permite conectar una sesión de Google, guardar el calendario principal y seleccionar calendarios de consulta. Consulta [la guía de configuración](docs/google-calendar.md). Es independiente del inicio de sesión. La sincronización y la renovación automática del acceso en backend siguen pendientes.

La pestaña Google Calendar también muestra eventos del calendario principal por fechas y permite importar actuaciones individuales a Agenda sin duplicarlas ni sobrescribir datos existentes. Requiere conexión Google activa y Supabase configurado; no necesita una migración adicional. Los eventos recurrentes y de día completo se muestran solo para consulta.
