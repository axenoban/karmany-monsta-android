---
name: android-game-qa
description: "Verificar compilaciones, APK, pantallas, tactilidad, rendimiento, navegación, guardados y regresiones de Karmany Monsta Android en dispositivos reales y CI."
---

# QA reproducible de un juego Godot para Android

## Punto de partida
1. Leer `AGENTS.md`, `docs/CONTINUIDAD.md`, `docs/ROADMAP_ESTADO.md`, `ci/README.md`, workflows y guías de prueba Android vigentes para el SHA objetivo.
2. Identificar el build/commit/PR exactos. Diferenciar baselines aprobados, candidatos con CI verde y cambios puramente documentales.
3. Si no hay herramientas para compilar o dispositivo físico, declarar la limitación y no simular ejecución.

## Matriz de validación
- **Integridad:** importación Godot, parseo GDScript, recursos faltantes, warnings significativos y scripts de tests existentes.
- **UI:** vistas de menú, mapa, combate, equipo, Libro y diálogos realmente presentes en el build; estados de botones, texto truncado, contraste, layering, overlays y gestos.
- **Dispositivo:** resolución, densidad, orientación efectiva, bordes de pantalla, gestos del sistema Android, interrupción/reanudación y rendimiento sostenido.
- **Navegación:** pantalla de procedencia, botón Atrás contextual, retorno al combate, menús reversibles y bloqueo de doble interacción.
- **Persistencia:** guardados existentes intactos, actualización sobre APK anterior, reinicio, cambios de escena y separación absoluta de los perfiles del laboratorio QA cuando aplique.
- **Regresión:** acciones y reglas de combate, captura, progresión, regiones validadas y accesibilidad de funciones antes visibles.

## Procedimiento
1. Proponer matriz de casos con precondiciones y resultado observable. Evitar casos hipotéticos de funciones aún no implementadas.
2. Ejecutar primero checks automáticos pertinentes, conservar logs y ubicar el primer fallo real.
3. Guardar capturas reproducibles por dispositivo/estado y contrastarlas con la referencia.
4. Registrar build, commit, versión, dispositivo, resultado, severidad y pasos de reproducción.
5. Ejecutar regresiones focalizadas después de cada corrección; no aumentar watchdogs ni reducir cobertura para hacer pasar CI.
6. Solicitar aprobación física explícita. Solo la expresión del creador y el artefacto identificable autorizan integrar el bloque según `AGENTS.md`.

## Entrega
Tabla de casos pasados/fallidos/no ejecutados, evidencia (PR/CI/APK/SHA), problemas priorizados, pasos locales y resultado esperado. Nunca atribuir pruebas físicas inexistentes.
