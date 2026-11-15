---
name: godot-gameplay
description: "Mantener arquitectura, gameplay, GDScript, estado de combate, navegación y persistencia de Karmany Monsta Android sin modificar reglas canónicas no autorizadas."
---

# Desarrollo de gameplay con fidelidad canónica

## Activación
Cuando un trabajo afecta lógica de reglas, exploración, combate, progreso, captura, estados o guardados. Para cambios visuales usar primero las skills UI; gameplay no debe intervenir salvo dependencia técnica comprobable.

## Fuentes prioritarias
1. `AGENTS.md`, `docs/ROADMAP_ESTADO.md`, `docs/CONTINUIDAD.md`, documento maestro si existe en la rama, contratos por fase y archivos reales bajo `data/`, `scripts/` y `tests/`.
2. Verificar HEAD, historial, PRs y alcance autorizado. Las conversaciones y PR no integrados no constituyen canon vigente por sí solos.
3. Si reglas, números, efectos, entidades o arquitectura crítica faltan o se contradicen, detener esa decisión y pedir definición; no inferirlos desde prototipos visuales.

## Método
1. Construir un mapa mínimo de flujo de datos y nodos afectados, guardados y tests existentes.
2. Aislar el primer error reproducible y su causa raíz. No corregir síntomas en cascada.
3. Implementar el cambio mínimo robusto, compartiendo funciones cuando se repitan comportamientos y evitando estado global implícito.
4. Respetar lifecycle de Godot 4.x, grupos, señales, UI reentrante, referencias a nodos liberados, coroutines y validaciones al restaurar partidas.
5. Conservar baselines y comportamiento aprobado. Tests nuevos deben probar la condición original y la regresión, no solo el caso feliz.
6. Verificar compatibilidad de API/GDScript con versión real del proyecto, ejecutar suites afectadas y revisar migraciones de persistencia.
7. Abrir PR desde `feature/*` y entregar evidencia técnica; integrar solo tras validación segura del creador y reglas de `AGENTS.md`.

## Restricciones
- Sin E6/R2-R4, cambios de balance, criaturas, economía, acciones ni misiones sin autorización expresa.
- Sin force push, reescritura de historia o debilitamiento de asserts.
- Prototipos UX y kit visual pendientes no habilitan nuevas mecánicas.

## Entrega
Alcance exacto, análisis de causa, prueba reproducible, commit, cobertura y resultado esperado. Identificar explícitamente cualquier prueba física pendiente.
