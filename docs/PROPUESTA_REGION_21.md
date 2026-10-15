# Bloque21 · Recorrido regional y progresión revisada

Estado: análisis y propuesta, no implementado. Base validada Preview29 (0.17.0), dev4d1817a. Rama de revisión feature/region-pacing-design.

## Solicitud del creador (14/10/2026)
Acepta la dirección de la siguiente región y solicita revisar el ritmo: niveles rivales crecientes al menos uno por etapa; regiones de5–6 etapas como mínimo y8–9 como máximo; una especie principal distinta en cada etapa; final con2–3 rivales en un mismo combate. Solicita análisis y recomendaciones, no aplicar magnitudes arbitrarias. La anterior propuesta de100XP constantes y tres especies queda sustituida por este análisis pendiente de decisión.

## Canon verificado
Fuente: Enciclopedia Oficial de Shisai- Ecosistemas y Best....pdf, archivo aportado por el creador, consultado directamente el14/10/2026. Página2: el mapa conecta Valle Jade con Bosque del Velo. Describe bambú de hasta30m, cerezos viejos, sendero antiguo y niebla lechosa perenne; los caminos reaccionan a la violencia latente de los viajeros. Esto no define una mecánica automática de caminos.

Candidatos comunes del Bosque del Velo:

| Especie | Página/entrada | Anatomía que debe conservarse |
| --- | --- | --- |
| Suzumeko | 8/17 | Gorrión de plumaje de fibras entrelazadas que emula pergamino doblado y patrones geométricos rígidos. |
| Kodamashi | 9/19 | Lagarto pequeño con piel cubierta de musgo y líquenes que cambian de color con la humedad. |
| Mujina-Kage | 9/20 | Tejón gris cenizo de pelaje denso; al madurar exuda vapor que desdibuja su silueta. |

La enciclopedia contiene descripciones lumínicas/sombrías, pero no define una tabla de Vida/Ataque/Defensa/Velocidad ni técnicas con magnitudes/recargas para estas tres especies. No equiparar automáticamente esas variantes a acciones de combate.


Otras tres comunes del Bosque para completar seis etapas (misma fuente ya consultada): Tsukimi-Usagi, página9/entrada21, conejo blanco de orejas largas; Kodama-Shin, página11/entrada28, humanoide de fibras vegetales y máscara ósea que simula madera; Karasu-Origami, páginas9–10/entrada22, cuervo de plumaje negro rígido con pliegues de papel. No alterar sus rangos ni inventar técnicas canónicas. Para Jade, Sakuraneko e Inubari ya están en data/jade_species.json, pero todavía carecen de arte y combate jugables.

## Diagnóstico medido
La curva vigente exige100×nivel. Jade1→10 necesita4500XP:180 victorias de25XP. Bosque10→15 necesita6000XP:60 victorias incluso con la propuesta anterior de100XP. Añadir más escenas manteniendo recompensas pequeñas no resuelve ese ritmo.

Recomendación: conservar la curva de requisitos y el escalado de estadísticas aprobado, pero hacer crecer la recompensa por etapa y separar XP repetible de un bono de primera victoria. Así la exploración nueva permite progresar sin repetir50–60 combates; la repetición sirve para capturas o compañeros nuevos. No proponer bajar todos los requisitos globales ni reinterpretar XP guardada.

## Recorridos propuestos para aprobación
Seis etapas por región en este bloque. Futuras regiones pueden tener5–9, con6 al principio y7–8 cuando aporten contenido distinto;9 como máximo. Cada etapa sube el nivel rival al menos1 y tiene una especie principal nueva respecto a las otras etapas de esa región.

### Jade: expansión propuesta, preservando el orden/IDs de los cuatro puntos existentes

| Etapa | Especie principal | Nivel rival | XP total primera victoria | XP repetición | Nivel esperado al ganar |
| --- | --- | --- | --- | --- | --- |
| 1 | Tanugami | 1 | 400 | 100 | 3 |
| 2 | Ushigane | 3 | 500 | 125 | 4 |
| 3 | Kitsunibi | 5 | 650 | 160 | 6 |
| 4 | Sakuromushi | 7 | 800 | 200 | 7 |
| 5 | Sakuraneko | 8 | 950 | 240 | 8 |
| 6 | Inubari + Ushigane | 10 ambos | 1200 | 300 | 10 |

### Bosque del Velo: acceso entrenador10/coste1punto/tope15 como base de la propuesta anterior

| Etapa | Especie principal | Nivel rival | XP total primera victoria | XP repetición | Nivel esperado al ganar |
| --- | --- | --- | --- | --- | --- |
| 1 | Suzumeko | 10 | 700 | 175 | 10 (700/1000XP) |
| 2 | Kodamashi | 11 | 850 | 210 | 11 |
| 3 | Mujina-Kage | 12 | 950 | 240 | 12 |
| 4 | Tsukimi-Usagi | 13 | 1050 | 260 | 13 |
| 5 | Kodama-Shin | 14 | 1150 | 290 | 14 |
| 6 | Karasu-Origami + Mujina-Kage | 15 ambos | 1300 | 325 | 15 |

Los niveles esperados suponen XP0 al entrar enNv1/Nv10 y participación en el equipo desde la etapa1. El total de primera victoria incluye la XP repetible: bono=primera−repetición, no sumar ambos totales. Cada individuo recibe esa cantidad sin repartir, limitado por el tope regional propio. Compañeros que se incorporan después no reciben los bonos anteriores retroactivamente. Los rivales adicionales de la final pueden repetir especies anteriores; su especie principal es distinta.

Una pasada de6 encuentros ganados permite llegar al tope para el entrenador/equipo presente desde el comienzo. Incluye7 rivales individuales al contar los dos de la final. No equivale a garantizar ganar los combates ni a validar el balance de daño. Una dificultad mayor en regiones futuras debe venir de estrategias/equipos y una progresión probada, no solo de repetir más.

Con enemigos10→15 y aumento mínimo1 caben exactamente6 etapas. Para8–9 se necesita un tramo mayor de niveles o cambiar el nivel inicial; no anunciar9 etapas y mantener simultáneamente esos límites sin revisar las cifras.

## Prueba final recomendada (requiere aprobación de formato)

- Dos Karmany rivales en el mismo encuentro, con uno activo y otro de reserva, enfrentados consecutivamente. Regiones posteriores pueden usar3 tras medir duración/dificultad.
- Vida restante del equipo persiste entre ambos rivales, sin curación automática al cambiar el enemigo. Relevo rival sin ataque gratuito. No introducir dos o tres respuestas enemigas por turno frente a una sola acción del jugador.
- Victoria/ruta/XP/objeto se resuelven una sola vez al derrotar el equipo completo; no multiplicar automáticamente XP por rival ni darla al retirarse a mitad.
- Después de la victoria, propuesta: elegir uno de los derrotados para el vínculo y mantener los tres intentos/política de Libro actuales. No conceder dos capturas por el mismo coste de entrada implícitamente.

Dos o tres enemigos activos simultáneamente son otra modalidad: exigen selección de objetivos, orden de ataques, efectos de área y reglas de turnos nuevas. Si el creador quiere esa modalidad, diseñarla antes de implementar; no presentarla como equivalente al relevo consecutivo.

## Otras recomendaciones y decisiones explícitas

1. Capturas nuevas: proponer conservar el nivel del encuentro (XP parcial0), en vez de reiniciar todas en1. Evita que una captura avanzada obligue a repetir gran parte de la región. Es un cambio respecto a la regla aprobada, todavía no autorizado; no subir capturas previas automáticamente.
2. Stamina propuesta para seis etapas:10 cada etapa normal y30 la final,80 en un recorrido sin derrotas, dentro del máximo100. Conserva regeneración/objeto actuales. Reasigna el coste del antiguo punto4 de Jade; necesita aprobación.
3. Guardados existentes: mantener niveles, capturas, XP, victorias y los cuatro IDs completados. Congelar encuentros en curso con sus niveles/recompensas/política originales. Preparar compensación única por bonos de etapas ya completadas; el creador debe decidir destinatarios (entrenador/equipo actual) porque no existe historial de participación que permita reconstruir beneficiarios antiguos. No otorgar XP a toda la colección como si hubiese participado.
4. No añadir como requisito completar Jade además del nivel si no se autoriza. Puntos de desbloqueo y compras permanentes conservan la política aprobada.

## Verificación reproducible y límites
Ejecutar `python3 docs/proposals/simulate_region_pacing_21.py`. Datos aislados en region_pacing_21.json; salida en REGION_PACING_21_REVIEW.md. Comprueba suma exacta de XP, ascenso por etapa,6 especies principales distintas, equipo final de2–3, tope individual, recompensas repetibles y resultados esperados.

Esto verifica aritmética, no daño, supervivencia, duración ni diversión. Faltan estadísticas/técnicas de ocho especies (dos de Jade y seis del Bosque) y simulación de combates antes de afirmar equilibrio. No hay APK nuevo ni cambios de reglas en data/ o scripts/.

## Alcance técnico y secuencia de trabajo tras decisiones

Primero aprobar curva/recorridos, formato de final, capturas y migración. Preparar tabla experimental de estadísticas/técnicas de las ocho especies para aprobación, sin deducir magnitudes del texto narrativo.

Luego dividir implementación en dos bloques revisables: (A) motor de rutas regionales, XP por etapa/bono único, niveles rivales, barras con múltiples subidas, equipo enemigo de reserva y guardados/capturas; (B) contenido completo de Jade/Bosque, arte y fichas de las ocho especies, escenarios y mapas de seis puntos, ajustes de stamina y pruebas integradas. No entregar una final que simule varias peleas independientes con curación entre ellas.

Auditoría real: TacticalEncounter mantiene un solo enemy y lo inicia sin nivel (Nv1); la ruta tiene4 puntos; award identifica Jade y valida gained≤25; el resumen de XP solo anima una transición de nivel. Todos necesitan adaptación/regresión para este diseño. Una edición de JSON no basta. Conservar sesiones legacy y no reinterpretar tiradas de captura.
