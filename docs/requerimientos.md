# MuseArt — Especificación de requisitos e implementación

Estado: especificación propuesta para desarrollo; todavía no implementada.

Este documento reúne los requisitos expresados por el usuario y las decisiones técnicas recomendadas para convertirlos en una aplicación ejecutable. Las decisiones propuestas son valores iniciales, no acuerdos ya confirmados. Las casillas representan trabajo pendiente, no funcionalidades existentes.

## 1. Objetivo y alcance

Plataforma para músicos solistas, agrupaciones y representantes que centraliza agenda, contrataciones, producción y finanzas de actuaciones, con sincronización bidireccional con Google Calendar.

El usuario podrá importar eventos de un calendario, crear eventos desde MuseArt, editar sus detalles y fechas, gestionar recursos y dinero, y cancelar o eliminar eventos vinculados. Los solapamientos generarán advertencias sin impedir guardar.

## 2. Decisiones propuestas para la primera versión

| Tema | Valor inicial propuesto |
| --- | --- |
| Organización | Espacios de trabajo independientes para un músico o agrupación |
| Google | Una conexión y un calendario seleccionado por espacio de trabajo |
| Importación inicial | Selección de eventos antes de convertirlos en contrataciones |
| Ventana inicial | Desde 3 meses atrás hasta 12 meses adelante, ampliable por el usuario |
| Eventos | Individuales con fecha y hora de inicio y fin |
| Recurrencias y día completo | Identificar y explicar la limitación; gestión completa en una fase posterior |
| Moneda | Una moneda por evento; PEN como valor inicial configurable |
| Zona horaria | Configurable; America/Lima como valor inicial |
| Comprobantes | Registrar estado y adjuntar archivo; emisión fiscal en una fase posterior |
| Borrado | Cancelar y conservar historial financiero por defecto; eliminación definitiva separada |
| Ensayos | Registros relacionados con el evento; publicación en Calendar opcional |

## 3. Usuarios, acceso y aislamiento

- [ ] ACC-01: Crear cuenta, iniciar y cerrar sesión, recuperar acceso y conectar Google mediante los flujos de autenticación elegidos.
- [ ] ACC-02: Separar autorización para iniciar sesión de los permisos de Calendar. La app debe poder utilizarse sin Calendar conectado.
- [ ] ACC-03: Crear un espacio de trabajo y asignar al creador como propietario.
- [ ] ACC-04: Aislar datos y archivos por espacio de trabajo mediante políticas de acceso verificables.
- [ ] ACC-05: Preparar roles de propietario, gestor y músico. En el MVP puede habilitarse solo el propietario; los demás roles se activan en la segunda fase.
- [ ] ACC-06: Los músicos contratados pueden existir como contactos sin cuenta.
- [ ] ACC-07: Permitir desconectar Google y explicar qué sucede con los datos importados y las tareas pendientes.

Matriz propuesta para colaboración: propietario administra miembros, integraciones y toda la información; gestor administra eventos y finanzas; músico consulta únicamente sus eventos asignados y la información operativa autorizada. La información financiera del cliente no se comparte por defecto con músicos.

## 4. Agenda y eventos

- [ ] EVT-01: Mostrar agenda en lista y calendario, con filtros por fecha, estado y cliente.
- [ ] EVT-02: Crear y editar título, descripción, inicio, fin, zona horaria, ubicación y notas internas.
- [ ] EVT-03: Registrar tipo de actuación, estado comercial y estado operativo.
- [ ] EVT-04: Estados iniciales: por confirmar, confirmado, realizado y cancelado. El estado de cobro se calcula aparte.
- [ ] EVT-05: Validar título obligatorio y fin posterior al inicio; mostrar errores junto a los campos.
- [ ] EVT-06: Advertir solapamientos al crear o cambiar horarios y permitir continuar explícitamente.
- [ ] EVT-07: Detectar conflictos de músicos asignados; considerar montaje y traslado cuando se hayan indicado.
- [ ] EVT-08: No revelar detalles de eventos privados de otros espacios al advertir conflictos.
- [ ] EVT-09: Cancelar una actuación conservando historial, cobros, gastos y motivo.
- [ ] EVT-10: Ofrecer eliminación definitiva con confirmación y permisos. Bloquearla mientras existan movimientos financieros; usar cancelación en esos casos.
- [ ] EVT-11: Mostrar historial de modificaciones relevantes y estado de sincronización.
- [ ] EVT-12: Distinguir descripción que puede publicarse en Google y notas privadas.

Aceptación: crear, consultar y editar un evento conserva todos los datos; dos eventos superpuestos pueden guardarse tras advertencia; cancelar no elimina movimientos financieros.

## 5. Integración con Google Calendar

- [ ] CAL-01: Autorizar Google mediante OAuth con permisos mínimos suficientes para el calendario elegido.
- [ ] CAL-02: Listar calendarios disponibles y permitir seleccionar uno con permisos de escritura; informar si solo permite lectura.
- [ ] CAL-03: Importar eventos seleccionados y conservar la relación entre espacio, conexión, calendario e identificador externo.
- [ ] CAL-04: Crear desde MuseArt un evento vinculado en Google, usando un identificador idempotente para evitar duplicados.
- [ ] CAL-05: Sincronizar título, fecha, horas, zona horaria, ubicación y descripción pública en ambas direcciones.
- [ ] CAL-06: Nunca exportar automáticamente cobros, gastos, tarifas de músicos, comprobantes ni notas internas.
- [ ] CAL-07: Mostrar estados pendiente, sincronizado, conflicto, desconectado y requiere atención.
- [ ] CAL-08: Guardar el evento y la tarea pendiente de sincronización en una misma transacción de base de datos.
- [ ] CAL-09: Procesar tareas en segundo plano con reintentos limitados, espera progresiva y recuperación manual de fallos definitivos.
- [ ] CAL-10: Recibir notificaciones de cambios, validar el canal y consultar los cambios mediante sincronización incremental.
- [ ] CAL-11: Renovar canales antes de su vencimiento y ejecutar reconciliación periódica; no depender únicamente de notificaciones.
- [ ] CAL-12: Recuperar una sincronización cuyo token haya caducado mediante una nueva lectura completa sin duplicar registros.
- [ ] CAL-13: Conservar versiones y último estado sincronizado; combinar cambios en campos distintos y pedir resolución si el mismo campo cambió en ambos lados.
- [ ] CAL-14: Impedir bucles de actualización y procesar de forma segura mensajes repetidos o fuera de orden.
- [ ] CAL-15: Si Google elimina un evento importado, marcarlo cancelado o retirado del calendario y conservar el historial interno.
- [ ] CAL-16: Al cancelar desde MuseArt, permitir retirar también el evento de Google; al eliminar definitivamente un evento vinculado, comunicar y ejecutar la eliminación externa.
- [ ] CAL-17: Mantener una tarea o registro de eliminación hasta que Google confirme el resultado, incluso si el evento ya no aparece en la interfaz.
- [ ] CAL-18: Gestionar permisos revocados, expiración de credenciales, cuotas y errores temporales sin perder cambios locales.
- [ ] CAL-19: Desconectar o cambiar de calendario no elimina automáticamente eventos existentes ni crea copias; definir una migración explícita para un cambio de calendario.
- [ ] CAL-20: Mostrar la última sincronización correcta y permitir reintentar.
- [ ] CAL-21: No modificar invitados ni enviar invitaciones de Calendar de forma implícita. La gestión de invitados queda fuera del MVP.

Aceptación: crear y editar desde ambos sistemas converge al mismo estado; repetir una tarea no duplica eventos; una caída temporal permite guardar localmente y sincronizar después; revocar acceso solicita reconexión; una eliminación externa conserva los datos financieros internos.

## 6. Cliente y ubicación

- [ ] CLI-01: Crear, editar, buscar y asociar clientes con nombre, contacto, correo, teléfono y observaciones.
- [ ] CLI-02: Guardar razón social, tipo y número de documento y dirección fiscal cuando se requieran para el comprobante.
- [ ] CLI-03: Asociar un cliente principal y un contacto operativo al evento.
- [ ] CLI-04: Registrar nombre del local, dirección, enlace a mapa, contacto y notas de acceso o montaje.
- [ ] CLI-05: Evitar borrar clientes con historial; permitir archivarlos.

## 7. Repertorio, sonido y producción

- [ ] PRO-01: Mantener un catálogo de canciones con título, autor o intérprete, duración, tonalidad y notas opcionales.
- [ ] PRO-02: Crear repertorios ordenados por evento, organizados en bloques y con duración estimada.
- [ ] PRO-03: Conservar la versión del repertorio usada en un evento aunque cambie el catálogo.
- [ ] PRO-04: Registrar equipo de sonido requerido, cantidad, responsable, proveedor, coste y estado de disponibilidad.
- [ ] PRO-05: Añadir instrucciones técnicas, horario de llegada, montaje, prueba de sonido y desmontaje.
- [ ] PRO-06: Adjuntar documentos privados necesarios para la producción con límites de tamaño y tipos admitidos.

## 8. Músicos y ensayos

- [ ] MUS-01: Registrar cantidad de plazas contratadas independientemente del número de músicos asignados.
- [ ] MUS-02: Mantener directorio de músicos con contacto, instrumentos y observaciones.
- [ ] MUS-03: Asignar músicos a un evento con función, tarifa acordada y estado: pendiente, confirmado o rechazado.
- [ ] MUS-04: Mostrar plazas sin cubrir y advertir asignaciones duplicadas o incompatibilidades horarias.
- [ ] MUS-05: Registrar pagos parciales a cada músico y calcular su saldo pendiente.
- [ ] MUS-06: Indicar si el evento necesita ensayos y crear uno o varios con horario, lugar, participantes y coste.
- [ ] MUS-07: Permitir publicar un ensayo como evento separado de Calendar sin reemplazar la actuación principal.

## 9. Cobros, gastos y comprobantes

- [ ] FIN-01: Registrar precio total acordado y moneda del evento.
- [ ] FIN-02: Registrar múltiples cobros con importe, fecha, medio, referencia y concepto; identificar adelantos sin sumarlos dos veces.
- [ ] FIN-03: Calcular saldo del cliente = precio acordado − cobros netos de devoluciones; mostrar sobrepago si existe.
- [ ] FIN-04: Registrar gastos previstos y reales por transporte, músicos, sonido, ensayos y otros conceptos.
- [ ] FIN-05: Separar obligaciones o costes de sus pagos para evitar duplicar gastos cuando se abona una tarifa.
- [ ] FIN-06: Registrar pagos parciales de gastos y devoluciones mediante movimientos trazables.
- [ ] FIN-07: Calcular ganancia prevista = precio acordado − costes previstos totales.
- [ ] FIN-08: Calcular resultado de caja = cobros recibidos netos − gastos pagados netos. No presentarlo como ganancia definitiva.
- [ ] FIN-09: Calcular ganancia final al cerrar el evento con todos sus costes reales registrados; documentar si los importes incluyen impuestos. El MVP no calcula obligaciones tributarias.
- [ ] FIN-10: Usar decimal exacto o unidades monetarias mínimas; validar importes y moneda en servidor.
- [ ] FIN-11: No sumar monedas diferentes en un total sin conversión definida; presentar resúmenes separados por moneda.
- [ ] FIN-12: Registrar comprobante requerido: ninguno, boleta o factura.
- [ ] FIN-13: Registrar estado del comprobante: pendiente, emitido, enviado o anulado, número, archivo y fechas de emisión y envío.
- [ ] FIN-14: Marcar enviado exige registrar fecha; adjuntar un archivo no implica que fue enviado al cliente.
- [ ] FIN-15: Mostrar pendientes de cobro, pagos a músicos, comprobantes pendientes y resumen por periodo.
- [ ] FIN-16: Mantener trazabilidad de correcciones financieras; evitar sobrescribir silenciosamente movimientos históricos.

Ejemplo de aceptación: precio 1.000, adelanto 300 y segundo cobro 200 producen cobrado 500 y saldo 500. Con costes previstos de 400, la ganancia prevista es 600. Si se han pagado 150 de gastos, el resultado de caja es 350.

## 10. Interfaz y dirección visual

- [ ] UX-01: Diseñar para móvil y escritorio, priorizando consulta rápida durante una actuación.
- [ ] UX-02: Pantallas: acceso, agenda, detalle/edición de evento, clientes, músicos, repertorios, finanzas y configuración de Google.
- [ ] UX-03: La ficha responde de inmediato: qué se toca, cuándo, dónde, con quién, qué llevar y cuánto falta cobrar.
- [ ] UX-04: Agrupar la ficha en información general, producción, participantes, finanzas e historial sin ocultar los datos esenciales.
- [ ] UX-05: Incluir estados vacíos, carga, error, reintento, guardado pendiente y desconexión.
- [ ] UX-06: Navegación por teclado, foco visible, etiquetas accesibles, contraste suficiente y estados que no dependan solo del color; objetivo WCAG 2.2 AA.
- [ ] UX-07: Dirección propuesta: agenda editorial musical, fondos cálidos, tinta oscura, acento de color y tipografía expresiva solo en títulos.
- [ ] UX-08: Preparar tablero de referencias y prototipo de agenda y ficha antes de ampliar pantallas.

Referencias para investigar: Artist Growth, Back On Stage y Gigwell para flujos musicales; Linear y Notion Calendar para navegación y densidad; Readymag, Awwwards y programas de conciertos para composición; Figma Community para componentes con licencia compatible. No se ha realizado una auditoría de estos productos. Reutilizar patrones y recursos autorizados, no copiar marcas ni diseños completos.

## 11. Arquitectura propuesta

| Capa | Tecnología y responsabilidad |
| --- | --- |
| Interfaz | React + TypeScript + Vite; recursos estáticos en Cloudflare |
| API e integración | Cloudflare Workers para OAuth, operaciones privilegiadas y webhooks |
| Datos | Supabase Postgres con migraciones y Row Level Security |
| Identidad | Supabase Auth |
| Archivos | Supabase Storage privado con acceso temporal autorizado |
| Trabajo asíncrono | Cloudflare Queues; patrón outbox en Postgres y tareas programadas para despachar y reconciliar |
| Agenda externa | Google Calendar API |

- [ ] TEC-01: El navegador consulta datos internos; no llamar a Calendar en cada renderizado o apertura de pantalla.
- [ ] TEC-02: Proteger credenciales de Google con cifrado y acceso exclusivo del backend; las claves privilegiadas no se incluyen en el frontend.
- [ ] TEC-03: Validar identidad, espacio y autorización en cada operación privilegiada; una clave de servicio no sustituye estas comprobaciones.
- [ ] TEC-04: Implementar OAuth con validación de estado, redirecciones autorizadas y protección contra vinculación de cuentas incorrectas.
- [ ] TEC-05: La sincronización de fondo usa credenciales autorizadas para acceso sin sesión activa del usuario y gestiona su renovación.
- [ ] TEC-06: Aplicar índices por espacio, intervalo de fechas, estado e identificador externo; paginar listados.
- [ ] TEC-07: Definir unicidad de vínculos externos y claves de idempotencia por operación.
- [ ] TEC-08: Usar conexiones o API compatibles con Workers y controlar la concurrencia de trabajos por conexión de Google.

## 12. Modelo de datos inicial

Todas las entidades de negocio deben asociarse a un espacio de trabajo y tener identificador, fechas de creación/actualización y controles de acceso.

| Entidad | Contenido y relaciones principales |
| --- | --- |
| workspaces / memberships | Organización, usuario y rol |
| calendar_connections | Cuenta de Google, calendario, permisos y estado; secretos en almacenamiento restringido |
| calendar_sync_state | Tokens de sincronización, canales, vencimientos y última ejecución por calendario |
| events | Horarios, cliente, ubicación, estado, moneda, precio y plazas contratadas |
| external_event_links | Entidad interna, calendario, ID externo, versión y última representación sincronizada |
| clients / venues | Clientes, contactos y ubicaciones |
| musicians / event_musicians | Directorio, asignaciones, función, confirmación y tarifa |
| songs / event_repertoire_items | Catálogo y repertorio ordenado del evento |
| equipment_requirements | Recursos, cantidades, proveedor, responsable y disponibilidad |
| rehearsals / rehearsal_participants | Ensayos vinculados y sus participantes |
| receivables / receipts | Importe acordado y movimientos de cobro o devolución |
| expenses / expense_payments | Costes previstos/reales y pagos o reintegros asociados |
| documents / attachments | Comprobantes, metadatos y referencias de archivos privados |
| sync_outbox / sync_attempts | Operaciones pendientes, reintentos, fallos y claves de idempotencia |
| audit_log | Actor, acción, entidad y cambios relevantes sin credenciales |

Evitar duplicar importes entre la tarifa del músico y el gasto: definir una única obligación financiera asociada a la asignación. Aplicar claves foráneas y políticas de borrado que conserven historial.

## 13. Seguridad, operación y rendimiento

- [ ] OPS-01: Separar desarrollo, pruebas y producción con proyectos y credenciales adecuados.
- [ ] OPS-02: Probar aislamiento de lectura, escritura y archivos entre dos espacios distintos.
- [ ] OPS-03: No registrar tokens, credenciales ni datos financieros completos en logs.
- [ ] OPS-04: Disponer de logs de errores, métricas de latencia, fallos y retraso de sincronización, con alertas operativas.
- [ ] OPS-05: Configurar copias de seguridad según el plan contratado y verificar una restauración antes de producción.
- [ ] OPS-06: Establecer política de conservación, exportación y eliminación de datos de cuenta.
- [ ] OPS-07: Limitar peticiones abusivas, validar entradas y restringir tamaño y tipo de archivos.
- [ ] OPS-08: Documentar cuotas de Google y límites reales de los planes elegidos; revisar el proceso de verificación OAuth antes del lanzamiento público.
- [ ] OPS-09: Ejecutar CI con tipos, pruebas, compilación y comprobación de migraciones.
- [ ] OPS-10: Documentar instalación, variables por nombre sin valores secretos, inicio local, migraciones, despliegue y recuperación.

Objetivos iniciales propuestos: acciones internas comunes con p95 inferior a 1 segundo bajo la carga objetivo, excluyendo latencia externa de Google; cambios salientes normalmente sincronizados en menos de 60 segundos y reconciliación de respaldo cada 15 minutos. Son objetivos por validar y ajustar a cuotas y costes, no garantías.

## 14. Usuarios concurrentes y pruebas de carga

No se puede afirmar una capacidad por elegir Supabase y Cloudflare. Depende del plan, los índices, las consultas y el volumen de integración.

- [ ] CAP-01: Validar primero 100 usuarios activos simultáneos con datos representativos y después explorar 500 y 1.000.
- [ ] CAP-02: Definir el escenario: consultas de agenda, apertura de fichas, ediciones, cobros y sincronización concurrente.
- [ ] CAP-03: Medir p50/p95/p99, errores, consumo de base de datos, conexiones, cola y coste estimado.
- [ ] CAP-04: Probar ráfagas de importación y recuperación tras interrupciones sin sobrepasar cuotas de Google; usar simulación para carga masiva y una prueba limitada con Google real.
- [ ] CAP-05: Publicar el resultado con plan, tamaño de datos, duración y patrón de actividad; no confundir sesiones abiertas con usuarios activos.

Ejemplo de carga: 1.000 usuarios con una acción cada 30 segundos generan unas 33 acciones por segundo. Si cada acción hace tres peticiones, son unas 100 peticiones por segundo, sin contar tareas de fondo. Este cálculo no demuestra capacidad.

## 15. Plan de ejecución

### Fase 0 — Base y diseño

- [ ] Confirmar las decisiones propuestas de la sección 2 y registrar cambios de alcance.
- [ ] Crear estructura del proyecto, herramientas, CI y documentación de ejecución.
- [ ] Preparar diseño de agenda y ficha con datos de ejemplo, incluyendo estados de error y móvil.
- [ ] Configurar Supabase de desarrollo, migraciones iniciales, autenticación y aislamiento.

Salida: proyecto compila, se ejecuta y permite acceder a un espacio propio sin ver datos ajenos.

### Fase 1 — Prueba completa de Calendar

- [ ] Configurar proyecto de Google, consentimiento, URLs OAuth y permisos necesarios.
- [ ] Implementar conexión, elección de calendario y eventos básicos.
- [ ] Implementar outbox, cola, webhooks, renovaciones y reconciliación.
- [ ] Probar creación, edición y eliminación/cancelación desde ambos lados, duplicados, conflictos y desconexión.

Salida: sincronización real con una cuenta de pruebas y recuperación verificable ante fallos.

### Fase 2 — MVP de gestión musical

- [ ] Implementar agenda, cliente, ubicación, repertorio, equipo, músicos y ensayos.
- [ ] Implementar cobros, gastos, saldos, ganancias y estado de comprobantes.
- [ ] Añadir advertencias de solapamiento y registro de cambios.
- [ ] Completar interfaz móvil y accesibilidad de los flujos principales.

Salida: una contratación puede gestionarse desde su creación hasta el cierre financiero.

### Fase 3 — Preparación para lanzamiento

- [ ] Ejecutar pruebas de integración, extremo a extremo, aislamiento y carga.
- [ ] Validar restauración, observabilidad, límites y costes con los planes elegidos.
- [ ] Completar verificación OAuth si corresponde y configurar dominios de producción.
- [ ] Documentar despliegue, reversión y soporte; validar con músicos en un piloto.

Salida: evidencia de funcionamiento y límites conocidos antes de publicar para usuarios generales.

### Evolución posterior

- [ ] Colaboradores con roles y portal de músico.
- [ ] Varios calendarios y conexiones por espacio.
- [ ] Recurrencias completas y eventos de día completo.
- [ ] Emisión electrónica de comprobantes mediante proveedor e integración fiscal correspondiente.
- [ ] Envío de comprobantes, invitaciones y comunicaciones con consentimiento explícito.
- [ ] Cobros en línea, portal de cliente, contratos y reportes avanzados.

## 16. Pruebas mínimas de aceptación del lanzamiento

| Caso | Resultado esperado |
| --- | --- |
| Crear desde MuseArt | Evento local y un único evento vinculado en Google |
| Importar dos veces | Mismo evento interno, sin duplicados |
| Cambiar título o fecha desde Google | Actualización interna sin perder detalles privados |
| Editar el mismo campo simultáneamente | Conflicto visible y resolución explícita |
| Dos actuaciones superpuestas | Advertencia y posibilidad de guardar |
| Google temporalmente caído | Guardado local y tarea pendiente recuperable |
| Notificación duplicada o tardía | Sin duplicación ni regresión a una versión antigua |
| Token de sincronización inválido | Reconstrucción del estado sin pérdida de información interna |
| Permisos de Google revocados | Estado desconectado y flujo de reconexión |
| Cancelar evento con cobros | Historial financiero conservado |
| Dos abonos y un pago parcial | Saldos y resultado de caja correctos |
| Acceso desde otro espacio | Lectura y escritura denegadas, incluidos archivos |
| Uso móvil y teclado | Flujos principales completos y accesibles |
| Restauración de respaldo | Datos recuperados y sincronización reanudada sin duplicados |

## 17. Prerrequisitos externos y definición de terminado

Se necesitarán proyectos de Supabase, Cloudflare y Google Cloud, un calendario de pruebas y configuración OAuth. Para producción harán falta dominio, URLs de redirección y webhook, políticas de privacidad y los requisitos de verificación que Google indique. Las credenciales se introducirán mediante gestores de secretos o configuración segura, nunca en el repositorio.

La implementación estará terminada para el MVP cuando las fases 0–3 tengan evidencia de sus criterios de salida, los requisitos aplicables al MVP estén validados, la documentación permita repetir instalación y despliegue, y se hayan informado los límites reales de carga y las funcionalidades diferidas. Esta especificación no ejecuta ni despliega la aplicación por sí misma.
