---
name: godot-ui-implementation
description: "Implementar y refactorizar interfaces nativas de Godot 4.x con Control, Theme, StyleBox, Container y recursos reutilizables, integrando arte de Karmany Monsta Android sin romper gameplay."
---

# Implementación robusta de UI en Godot

## Preparación
1. Leer `AGENTS.md`, `project.godot`, escena raíz y scripts de UI realmente afectados. Verificar versión de Godot del commit objetivo; no asumir disponibilidad de APIs por memoria.
2. Confirmar que diseño y recursos están aprobados o etiquetarlos claramente como prototipo. No integrar un kit entero desde PR ajeno sin autorización y revisión de conflictos.
3. Elegir rama `feature/*` desde baseline apropiado, comprobar HEAD/historia y mantener un único escritor en archivos compartidos.

## Implementación
1. Diseñar árbol de controles reutilizables y componentes con responsabilidad única. Preferir `Control`, `Container`, `MarginContainer`, `PanelContainer`, `TextureRect` y `Button` según el caso.
2. Centralizar estilos en un recurso `Theme` y `StyleBox` o variaciones de tipo. Utilizar overrides locales solamente cuando exista una justificación explícita; evitar redibujar cada botón manualmente.
3. Separar contenido, estado visual y acciones; no duplicar lógica de gameplay ni conectar señales dos veces durante reconstrucciones.
4. Adaptar anclas, size flags, tamaños mínimos, relaciones de aspecto, safe areas y escalado según el `project.godot` real y el dispositivo objetivo.
5. Aplicar texturas/íconos con importación y filtrado adecuados; comprobar escalado, nine-patch cuando corresponda y ausencia de deformaciones o bordes cortados.
6. Revisar navegación Atrás, foco, menús, señales, bloqueo de input, escenas liberadas y coroutines en teardown. No crear nodos huérfanos ni trabajos que sobrevivan al cierre.
7. Mantener GDScript compatible con la versión instalada: sin identificadores reservados, constantes runtime inválidas ni colisiones con métodos heredados.

## Verificación
- Importar proyecto y ejecutar tests/regresiones existentes; ante errores buscar PRIMER error real sin relajar asserts.
- Comparar capturas de estados normal/pulsado/deshabilitado/contextual con referencia visual aprobada.
- Validar interacción táctil y transiciones en APK; `CI verde` no significa `prueba física aprobada`.
- Revisar diffs de scripts, `scenes/`, `assets/` y guardados antes de proponer integración.

## Entrega
Árbol de componentes, archivos modificados, commits, pruebas ejecutadas/reales, capturas, limitaciones y prueba física solicitada. Sin nuevos sistemas ni cambios de balance encubiertos.
