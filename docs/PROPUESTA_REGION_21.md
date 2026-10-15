# Bloque21 · Propuesta de siguiente región

Estado: preparación para decisión del creador. Ninguna selección, cifra o técnica nueva de este documento está implementada ni aprobada. Base validada Preview29 (0.17.0).

## Canon verificado
Fuente: Enciclopedia Oficial de Shisai- Ecosistemas y Best....pdf, archivo aportado por el creador, consultado directamente el14/10/2026. Página2: el mapa conecta Valle Jade con Bosque del Velo. Describe bambú de hasta30m, cerezos viejos, sendero antiguo y niebla lechosa perenne; los caminos reaccionan a la violencia latente de los viajeros. Esto no define una mecánica automática de caminos.

Candidatos comunes del Bosque del Velo:

| Especie | Página/entrada | Anatomía que debe conservarse |
| --- | --- | --- |
| Suzumeko | 8/17 | Gorrión de plumaje de fibras entrelazadas que emula pergamino doblado y patrones geométricos rígidos. |
| Kodamashi | 9/19 | Lagarto pequeño con piel cubierta de musgo y líquenes que cambian de color con la humedad. |
| Mujina-Kage | 9/20 | Tejón gris cenizo de pelaje denso; al madurar exuda vapor que desdibuja su silueta. |

La enciclopedia contiene descripciones lumínicas/sombrías, pero no define una tabla de Vida/Ataque/Defensa/Velocidad ni técnicas con magnitudes/recargas para estas tres especies. No equiparar automáticamente esas variantes a acciones de combate.

## Recomendación para decidir primero

| Decisión | Propuesta | Motivo |
| --- | --- | --- |
| Zona siguiente | Bosque del Velo | Conexión geográfica explícita con Jade y contraste visual sin inventar bioma. |
| Acceso | Entrenador Nv10 y1 punto de árbol | Continuidad con el tope de Jade y desbloqueo con puntos ya solicitado. |
| Tope de experiencia de zona | Nv15 por individuo | Tramo más corto que20 para probar la progresión regional. |
| XP por victoria en esta zona | 100 por individuo elegible | 60 victorias para10→15; Jade sigue en25. Cambio de balance exclusivamente propuesto. |
| Primer grupo | Suzumeko, Kodamashi y Mujina-Kage | Tres anatomías distintas y rareza común, sin añadir de golpe todas las especies. |
| Cifras y técnicas | Preparar tabla experimental completa para aprobación | El canon no ofrece magnitudes de combate; no repetir estadísticas arbitrarias en código. |

Jade conserva25XP/victoria y tope10;100×nivel sigue como requisito. Para10→15 se necesitan6000XP: con25XP serían240 victorias y con100XP serían60. Para10→20 serían14500XP/580 victorias a25XP. Por ello se propone un tramo15 y100XP en el Bosque, pendiente de decisión y posterior simulación. Ninguno de estos ritmos está validado como balance definitivo. La cifra100 también afecta a compañeros de nivel bajo y debe comprobarse con equipo mixto; no variar XP ni topes en el código todavía.

## Segunda tabla necesaria antes de programar
Después de decidir zona, selección y objetivo de ritmo, preparar para aprobación:

- Estadísticas base y técnicas de las tres especies (incluidas recargas, efectos y animaciones).
- Cantidad/orden de localizaciones, niveles rivales y nivel inicial de una criatura vinculada. Actualmente nuevas capturas empiezanNv1: no elevarlas automáticamente.
- Stamina de entrada y fondos por localización; no trasladar10/10/10/30 sin aprobación.
- Experiencia por victoria de la zona y límite final acordado, compatibilidad con tope Jade10 por individuo.
- Si se exige completar Jade además del nivel para acceder, decidirlo expresamente; no añadir condición nueva implícita.

## Alcance técnico cuando estén aprobadas las reglas
Una fase regional coherente: catálogo y fichas, tres criaturas con arte, tablas de combate, localizaciones/mapa cenital y fondos, navegación entre zonas, compra/desbloqueo con puntos, progreso de ruta por región, niveles rivales/capturas congelados en el encuentro, XP/resumen por región, migración y pruebas. Mantener especies, guardados y reglas ya validados. Producir un APK solo tras implementar y verificar ese bloque.

La ampliación de level_cap10 afecta validación del árbol, puntos, guardados y UI. award y navegación actuales todavía identifican Jade explícitamente: requieren adaptación probada, no basta añadir una fila a JSON. Iniciar feature/* desde dev validada cuando se apruebe el diseño completo.
