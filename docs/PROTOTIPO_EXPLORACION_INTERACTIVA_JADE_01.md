# Prototipo A · Exploración interactiva en Valle Jade (Lugar 1)

**Decisión del creador, 14/11/2026:** aprobada la opción A (explorar tocando zonas de una ilustración). Esta autorización cubre exclusivamente un **prototipo de localización**; no autoriza sustituir todas las regiones ni rediseñar las reglas, stamina, combate, colección o progresión.

## Base y dependencia

- Repositorio: `axenoban/karmany-monsta-android`.
- Baseline publicado como última versión validada: `dev/karmany-core @ 29be7ba3d30ea72e860f62ec4f0c8aa766e6d1b4`, con Preview42.
- Rama del prototipo: `feature/jade-interactive-location-prototype`, creada a partir de `feature/jade-nocturno @ 2591d0538d05b594b713a7a8aac32a6ec6b64deb` (PR23).
- Dependencias en cadena **sin integrar**: PR21 (NAV/QA) → PR22 (documento maestro) → PR23 (identidad Jade); PR24 (kit gráfico) es hermana del prototipo y no está fusionada ni aprobada visualmente. El prototipo NO incorpora los diseños pendientes de PR24.
- Sin cambios en `main` o `dev/karmany-core`. Prototipo pendiente de CI, revisión Android y aprobación expresa.

## Interacción y contrato

**Único punto intervenido:** `jade_point_1`, primera localización de Valle Jade. Mantiene su fondo ya aprobado, descripción y entorno desde `LocationVisuals.details()`. No introduce un mapa de movimiento libre.

1. El jugador entra desde la ruta regional utilizando el **mismo** `App.start_route(point_id)`: se cobra y guarda la stamina mediante el modelo existente.
2. Si el encuentro continúa en fase de exploración (`campaign.exploration.scouting`), se dibuja la ilustración en `LocationHotspots`.
3. Sobre la imagen hay **tres controles táctiles reales, con foco y soporte de teclado**:
   - **Entorno**: muestra exclusivamente el valor `environment` ya existente.
   - **Camino**: muestra exclusivamente `description` ya existente.
   - **Buscar encuentro**: emite una señal y el controlador llama a `App.discover_location(encounter_id)`; al éxito navega a `battle`.
4. Los dos puntos de inspección son **de solo lectura**, no tiran dados ni generan recompensas; no modifican el perfil ni son coleccionables. La búsqueda conserva la identidad, enemigo, nivel, tiradas, recompensa y costes existentes.
5. Abandonar confirma la misma retirada anterior. Navegar hacia atrás o reanudar desde el mapa debe recuperar el encuentro sin volver a cobrar.
6. Las otras **once** etapas mantienen la interfaz anterior de `TrialUI`. El laboratorio QA utiliza el mismo prototipo únicamente al configurar Jade1.

## Implementación

- `scripts/location_hotspots.gd`: `Control` presentacional, con botones posicionados proporcionalmente. Emite `inspected` y `encounter_requested`, sin acceso a `App` ni a `SaveStore`.
- `scripts/trial_ui.gd`: integración condicional por `point_id` y puente hacia `App.discover_location`, reutilizando el flujo de combate.
- `tests/location_hotspots_tests.gd`: inspección, dimensiones, accesibilidad, coste y flujo QA.
- `.github/workflows/android-preview.yml`: valida el prototipo en CI y habilita PRs contra `feature/jade-nocturno` sin cambiar reglas del motor.

**Prohibiciones:** no editar `data/*.json`, `App`, `SaveStore`, `CombatCatalog`, `TrialCampaign`, `JadeRoute`, ni `ExplorationEnergy`; no crear enemigos, materiales, recursos, misiones, RNG adicional, stamina persistente diferente, desplazamiento libre o efectos de inspección. Tampoco iniciar E6/R2 completo/R3/R4.

## Aceptación

| ID | Caso | Resultado |
|---|---|---|
| A-01 | Entrar en Jade1 | Se paga la entrada una vez con la lógica preexistente |
| A-02 | Tocar Entorno/Camino | Se muestra texto real del lugar, sin cambiar ningún byte lógico del perfil |
| A-03 | Tocar Buscar encuentro | Se inicia combate con el mismo `encounter.id`; no se vuelve a cobrar stamina |
| A-04 | Reabrir o volver al mapa con scouting | Se conserva el encuentro pendiente y la opción de retomarlo |
| A-05 | Salir con confirmación | Misma retirada, sin devolución de stamina |
| A-06 | Jade2–6 y Velo1–6 | Navegación y encuentros anteriores intactos |
| A-07 | 1280×720 / 960×540, texto normal/grande | Botones visibles, sin solapamiento, táctiles y con foco |
| A-08 | QA aislado | Ninguna inspección o búsqueda en QA escribe el perfil normal |
| A-09 | Compatibilidad de guardados | Las regresiones Preview32/E2/38/40/42/R1.1/Jade siguen aprobando |
| A-10 | Android físico | Se prueba en dispositivo real; se registra versión, SHA, resultados y defectos |

## Validación

```bash
godot --headless --editor --path . --import --quit
xvfb-run -a godot --rendering-method gl_compatibility --audio-driver Dummy --path . --script tests/location_hotspots_tests.gd
godot --headless --path . --script tests/run_tests.gd
python3 -m unittest discover -s tests -p 'test_*.py'
```

El workflow existente ejecuta el resto de regresiones y prepara el APK si tiene éxito. **No sustituir una CI pendiente por una afirmación de pruebas superadas.** La validación real requiere descargar la candidata identificada y repetir el caso en un teléfono Android sin desinstalar la versión anterior.

## Próxima decisión de producto

Después de la prueba física, evaluar si la inspección ofrece diversión real o solo añade pulsaciones: tiempo hasta combate, claridad de las zonas, deseo de explorar de nuevo y necesidad de más interacciones. **No ampliar a 12 etapas ni introducir nuevas recompensas/ramificaciones sin una decisión de diseño específica.**

**SIGUIENTE PASO:** ejecutar CI y validación física del prototipo, corregir defectos confirmados, y pedir `prueba correcta` indicando APK/commit. No integrar la cadena de PR pendientes de forma implícita.

**RESPONSABLE:** WORK para implementación/verificación, creador para la prueba Android.
**INSTRUCCIÓN PARA CONTINUAR:** En `axenoban/karmany-monsta-android`, verifica el HEAD de `feature/jade-interactive-location-prototype` y los PR21–24; revisa este contrato, ejecuta Godot 4.7.2 y regresiones completas, comprueba APK y guardados antiguos, publica evidencias en el PR del prototipo sin integrar `dev` ni `main`; conserva canones y reglas.
