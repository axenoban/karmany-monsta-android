---
name: game-visual-system
description: "Gestionar dirección artística Jade Nocturno, propuesta 02 Cristal Vivo, componentes, iconos, estados visuales, recursos SVG/PNG y revisiones de identidad gráfica de Karmany Monsta Android."
---

# Sistema visual, no solo paleta

## Autoridad y procedencia
1. Leer `AGENTS.md` y verificar el árbol Git real. Buscar `docs/diseno/jade-nocturno/`, `docs/JADE_NOCTURNO_IMPLEMENTACION.md` y `assets/ui/` EN LA RAMA de trabajo; pueden existir solo en ramas/PR pendientes.
2. El creador escogió la propuesta 02 de Jade Nocturno. Esa preferencia de dirección NO implica aprobación automática de todos los SVG ni del paquete completo.
3. Consultar PR23 (identidad), PR24 (kit Cristal Vivo) y sus decisiones actuales si son relevantes. No copiar automáticamente assets de PR no validado ni sustituir referencias aprobadas.
4. No asignar valores RGB, tipografía, iconografía, símbolos o contenido canónico que no estén documentados. Si faltan referencias, informar del bloqueo y presentar opciones para aprobación.

## Flujo de diseño
1. Seleccionar UNA familia visual y listar componentes, tamaños de uso, estados, variantes y contexto de juego.
2. Definir jerarquía visual, densidad, contraste, espacio negativo, estilo de bordes/materiales, escala y consistencia con referencias canónicas.
3. Desarrollar propuestas de buena calidad A TAMAÑO REAL para esa familia, en vez de una lámina única con decenas de miniaturas ilegibles.
4. Revisar con lupa bordes, simetría, alineación óptica, legibilidad de texto, consistencia de grosor, semántica de iconos y comportamiento sobre fondos claros/oscuros.
5. Separar fuente editable, exportación optimizada y vista de revisión. Registrar identificación, estado (propuesto/aprobado/integrado), procedencia, licencia y destino de cada archivo.
6. Para iconos interactivos incluir normal/pulsado/deshabilitado/seleccionado/foco solo cuando corresponda; no confundir estado visual con cambio de función.
7. Integrar progresivamente mediante `godot-ui-implementation` y validar capturas reales mediante `android-game-qa`.

## Puertas de calidad
- Una familia es aprobable individualmente sin asumir aprobación de las demás.
- No declarar `401 SVG` como `401 diseños distintos`: verificar diversidad y reutilización de geometría.
- No sustituir arte final por placeholders generados ni usar una paleta idéntica como única prueba de identidad.
- Proteger el arte y componentes ya aprobados: cambios visuales transversales requieren revisión de regresiones.

## Entrega
Índice de familia, referencias y versiones, imágenes fuente/exportadas, hojas por estado, revisión visual y decisión pendiente. No entregar assets gigantes como sustituto de evaluación humana.
