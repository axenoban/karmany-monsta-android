---
name: godot-ui-ux
description: "Auditar, diseñar y validar UX de pantallas, HUD, menús, navegación contextual e interacción táctil de Karmany Monsta Android en Godot 4.x."
---

# UX jugable y accesible para Android

## Cuándo usar
Ante una pantalla nueva, rediseño de flujo, HUD, menú, tutorial, feedback de combate o problema de interacción táctil. Esta skill evalúa experiencia y estructura; la identidad gráfica pertenece a `game-visual-system` y la implementación a `godot-ui-implementation`.

## Fuentes y límites
1. Leer `AGENTS.md`, `docs/ROADMAP_ESTADO.md`, `docs/CONTINUIDAD.md` y los contratos de la pantalla. Comprobar ramas/HEAD/PR; no confundir candidatos con baseline validado.
2. Consultar escenas y scripts reales (`scenes/`, `scripts/`) antes de proponer un flujo. Revisar también los PR abiertos de UX cuando afecten a esa pantalla.
3. Preservar reglas, acciones disponibles, significado de iconos y transiciones existentes. No inventar habilidades, recursos ni misiones.

## Método
1. Inventariar el flujo actual: entrada, objetivo primario, acciones secundarias, Atrás/contexto, overlays y salida.
2. Detectar fricción comprobable: demasiados pasos, acciones ocultas, jerarquía confusa, targets táctiles estrechos, información truncada, dependencia exclusiva de color o retroalimentación insuficiente.
3. Elaborar wireframe de una pantalla concreta, con estados vacío/ocupado/bloqueado/seleccionado/error si aplican. Priorizar una acción principal inequívoca y acceso explícito a funciones secundarias.
4. Evaluar distintas relaciones de aspecto reales del juego, fuentes escaladas, safe areas, solapamientos y contraste. No fijar orientación ni puntos de corte sin revisar `project.godot` y el dispositivo objetivo.
5. Proponer criterio de aceptación verificable: pasos para completar tarea, localización de controles, legibilidad, accesibilidad y reversibilidad de menús.
6. Encargar componentes/recursos a `game-visual-system` y `godot-ui-implementation` solo tras identificar diseños aprobados.
7. Comparar capturas de Godot o APK con el wireframe y documentar desviaciones. Una imagen conceptual no es evidencia de integración ni de funcionamiento táctil.

## Entrega
Mapa de flujo breve, captura o wireframe por estado, problemas priorizados, cambios mínimos, criterios de aceptación y pruebas físicas pendientes. Nunca declarar una UX validada solo por CI.
