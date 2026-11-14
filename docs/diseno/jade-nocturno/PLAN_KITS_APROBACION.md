# Plan de kits pequeños y aprobación visual — Jade Nocturno / Cristal Vivo 02

Fecha: 14/11/2026 · Proyecto: Karmany Monsta Android · **Estado: planificación de entregas, NO aprobación gráfica**

## Fuente, alcance y estado de partida

- Repositorio: `axenoban/karmany-monsta-android`.
- Rama para producción y revisión de propuestas: `feature/jade-cristal-vivo-kit`, derivada de `feature/jade-nocturno`. No modificar `main` ni `dev/karmany-core` mediante este plan.
- Manual canónico del alcance gráfico: [README.md](README.md); inventario: [catalogo.csv](catalogo.csv); registro de imágenes: [imagenes/registro.csv](imagenes/registro.csv).
- Referencia visual aprobada como *dirección* de arte: `imagenes/00-referencias/jn-referencia-estilo-v001.png`. Su contenido numérico/textual de ejemplo no es canon jugable.
- La rama actual ya incluye una **propuesta técnica de 401 SVG para 53 familias** bajo `imagenes/cristal-vivo-02/` y láminas/guías. No se equipara la cantidad de archivos con calidad gráfica: las 53 familias permanecen **sin aprobación final**.
- Proteger reglas, personajes, estadísticas, jugabilidad, datos, preferencias, guardados y arte canónico existente. No importar convenciones visuales del juego de mesa o del proyecto Blockchain sin autorización.

## Método de entrega: UNA puerta de aprobación por kit

1. Mostrar al creador la **muestra del kit actual**: lámina de conjunto a tamaño útil, acercamientos de acabado y cuadrícula de estados/variantes (según aplique), más un ejemplo de uso contextual. Si el kit es de una sola familia, detallar sus múltiples piezas.
2. Mantener la geometría, los materiales y la jerarquía consistentes con los kits ya aprobados. No reducir calidad para reunir todo el catálogo en una lámina. Una imagen de concepto no reemplaza archivos aislados.
3. Si el creador pide otra propuesta, elaborar nueva revisión etiquetada `v002`, `v003`, etc., conservando revisiones anteriores y sin marcar el kit como aprobado.
4. **Solo después de aprobación visual explícita del kit**: terminar y verificar archivos aislados (SVG editables cuando sea apropiado; PNG RGBA reales/ilustraciones cuando sea necesario), vista previa, dimensiones, estados, márgenes de escalado, fuente/procedencia y registro. Subirlos a esta rama del repositorio, identificando el kit y la evidencia de aprobación. Actualizar `catalogo.csv` por IDs verdaderamente completos y `imagenes/registro.csv` por archivo. Conservar las propuestas descartadas como historial.
5. Distinguir **aprobado gráficamente** de **implementado en Godot**: solo trasladar a `assets/ui/jade/` tras revisión técnica de recursos, regresiones y autorización de integración correspondiente. La aprobación del kit no autoriza por sí sola merge a `dev` o `main`, ni aprobación de APK.
6. Entregar el enlace a commit y rutas para revisión; solicitar validación visual del siguiente kit solo después de cerrar el actual. No reutilizar un `OK` de un kit para dar por válidos otros.

### Criterios por kit

- Apariencia y acabados propios, no mera recoloración de controles genéricos; legibilidad y jerarquía sobre escenarios con contraste variable.
- Muestras completas sin recortes/artefactos; estados normal, pulsado, enfocado, seleccionado, deshabilitado o bloqueado **solo donde proceda**, con signos distintos del color.
- Marco/ornamento escalable sin distorsión; especificar zonas extensibles / NinePatch si corresponde. Separar textos/valores vivos de texturas decorativas.
- Composiciones base 1280×720; comprobar adaptabilidad a 960×540 y texto grande; objetivo táctil mínimo equivalente a 48dp tras conversión real.
- En animaciones: secuencia, duración prevista, estado de inicio/final y alternativa de movimiento reducido.
- Prohibido presentar cifras ficticias como canon, inventar elementos jugables o modificar el juego para ajustarlo a una maqueta.
- El visual aprobado puede conservar trazabilidad de fuente IA/propuesta/vector original; nunca presentar los 401 SVG actuales como aprobados de antemano.

## Secuencia de 22 kits

Cada ID del catálogo aparece exactamente una vez. El orden es el de la primera revisión de **diseño**, no una autorización de implementación funcional.

| Orden | Kit | Familias del inventario | Piezas que se evaluarán |
|---|---|---|---|
| K01 | ADN gráfico | `JN-BASE-02`, `JN-BASE-04`, `JN-BASE-05` | Tipografía, ornamentación y materiales; fijar reglas de contraste, reflejos y relieve |
| K02 | Marcos y paneles | `JN-BASE-03`, `JN-BASE-06` | Marcos extensibles, panel principal, fichas y ventanas; zonas NinePatch |
| K03 | Identidad e inicio | `JN-BASE-01`, `JN-BASE-07`, `JN-PANT-01` | Título/emblema, tratamiento del fondo y una composición inicial contextual |
| K04 | Botones esenciales | `JN-CTRL-01`, `JN-CTRL-02`, `JN-FX-02` | Acciones primarias/secundarias y respuesta a la pulsación; estados válidos |
| K05 | Controles de icono | `JN-CTRL-04`, `JN-ICO-01` | Volver, cerrar, ajustes, ayuda, información y flechas |
| K06 | Navegación principal | `JN-CTRL-05`, `JN-ICO-02` | Barra, secciones y sus iconos propios; activo/inactivo |
| K07 | Pestañas y estados | `JN-CTRL-06`, `JN-ICO-06` | Filtros, rareza, selección y bloqueos sin depender solo del color |
| K08 | Listas y laboratorio | `JN-CTRL-09`, `JN-CTRL-10`, `JN-PANT-21` | Scroll, desplegables, controles numéricos y paneles QA |
| K09 | Ajustes | `JN-CTRL-07`, `JN-CTRL-08`, `JN-ICO-07`, `JN-PANT-19` | Interruptores, controles de volumen, iconos y pantalla de configuración |
| K10 | Selección de regiones | `JN-PANT-02` | Tarjetas de región, progreso y requisitos reales |
| K11 | Mapa y exploración regional | `JN-PANT-03`, `JN-ICO-05` | Marcadores, rutas, estados, stamina y símbolos de exploración |
| K12 | Ficha de localización y escena | `JN-PANT-04`, `JN-PANT-05` | Panel de localización, vista de exploración, costo y acciones reales |
| K13 | Acciones de combate | `JN-CTRL-03`, `JN-ICO-03`, `JN-PANT-07` | Golpe, Protección e Insignia, y distribución de acciones en combate |
| K14 | HUD y ventanas de combate | `JN-PANT-06`, `JN-PANT-08`, `JN-ICO-04` | Retratos, PS, niveles, turno, estadísticas y paneles de detalle |
| K15 | Resultado y vinculación | `JN-PANT-09`, `JN-PANT-10`, `JN-FX-05` | Victoria/derrota, XP, recompensas, Libro, intentos y celebración |
| K16 | Equipo y selector | `JN-PANT-11`, `JN-PANT-12` | Ficha de criatura, activo/reserva y selector de miembros |
| K17 | Colección y Bestiario | `JN-PANT-13`, `JN-PANT-14` | Tarjetas de individuos/especies, filtros y detalles canónicos |
| K18 | Libro | `JN-PANT-15` | Ilustración funcional, mejoras, requisitos y probabilidades reales |
| K19 | Perfil y resonancias | `JN-PANT-16`, `JN-PANT-17`, `JN-PANT-18` | Perfil Ezel, nodos/ramas y espacios de resonancias realmente disponibles |
| K20 | Prólogo y ayudas | `JN-PANT-20` | Diálogo, progresión, omisión y ayuda contextual |
| K21 | Feedback visual | `JN-FX-01`, `JN-FX-03`, `JN-FX-04`, `JN-FX-06` | Ventanas, selección, barras y avisos de error/bloqueo |
| K22 | Transiciones y accesibilidad | `JN-FX-07`, `JN-FX-08` | Transiciones entre escenas y alternativas sin movimiento |

**Control de cobertura:** 22 kits, 53/53 familias asignadas; cero identificadores ausentes o repetidos. Un ID puede necesitar varias piezas/variantes; no equivale a una única imagen.

## Organizar la revisión sin perder el inventario previo

Conservar las cuatro carpetas físicas existentes (`01-kit-maestro`, `02-iconos-mapa-combate`, `03-equipo-y-progresion`, `04-pantallas-y-situaciones`) como clasificación de archivos fuente. Dentro de su `propuestas/` o `aprobados/`, registrar por nombre de kit `k01-` ... `k22-` cuando sea útil, **sin borrar ni desplazar** las piezas de Cristal Vivo 02 que ya existen.

Los 401 SVG anteriores se pueden usar como geometría de arranque o documentación, pero deben auditarse y rediseñarse selectivamente con el grado de detalle exigido. No dar aprobaciones por arrastre a otros archivos de una familia cuando una lámina parcial sea aceptada.

## Primer kit

**K01 · ADN gráfico:** `JN-BASE-02` + `JN-BASE-04` + `JN-BASE-05`.

Preparar una muestra específica que enseñe: pares tipográficos funcionales, variaciones de material profundo/jade/marfil/oro, relieves, ornamentación vegetal/símbolos, muestras de contraste y aplicación pequeña sobre un panel sin texto canónico inventado. Una referencia de aspecto sola no concluye K01: hay que conservar especificaciones reutilizables para K02–K22.

**Pendiente:** aprobación de muestra K01 por el creador. No se ha aprobado ni subido ningún kit final mediante este plan.

## Cierre y responsable

- HECHO: separación documental de 53 familias en 22 kits con orden y puerta de aprobación.
- RAMA: `feature/jade-cristal-vivo-kit` (plan exclusivamente documental).
- CI / APK: no corresponde a cambio de planificación; no se han ejecutado pruebas Godot ni compilado una APK nueva.
- SIGUIENTE PASO: CHAT presenta muestra de **K01** al creador para aprobar o pedir nueva propuesta.
- RESPONSABLE: CHAT para revisión artística y criterios de aprobación; al preparar recursos aprobados, un único escritor por bloque según coordinación del repositorio.
- INSTRUCCIÓN PARA CONTINUAR: «En `axenoban/karmany-monsta-android`, verifica HEAD de `feature/jade-cristal-vivo-kit`, lee `AGENTS.md`, `docs/diseno/jade-nocturno/README.md` y `PLAN_KITS_APROBACION.md`. Trabaja solo K01 (JN-BASE-02/04/05); presenta muestra con variantes/zoom/aplicación, sin atribuir aprobación previa. Tras aceptación explícita, empaqueta archivos individuales y registra la evidencia en rama feature. No toques reglas, guardados, dev ni main; no integres la candidata Preview46 ni los kits restantes sin sus puertas de validación.»
