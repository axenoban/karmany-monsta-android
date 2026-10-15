# Candidata de unificación · Preview32 + E1 + E2

Estado: candidata Preview38 lista en feature/unificacion-jade-bosque. CódigoAPKf0266badaa7851da3de2bcc08a65752b6409360b; CI38824304295 correcta. Único escritor Work; Chat revisa. No integrada en dev/main; aprobación física pendiente.

## Procedencia y recuperación

- APK Preview32 original: SHA256 3a65d6f760bd881e0fb176220e1c2ae59c25b1e09327d4fa2ed71c36f453f06a, código original 009e0c7d9dc4e7e6aa61509157318982152971f7. No apareció un respaldo fuente original en las búsquedas por nombre de Karmany/Preview32/Fuente en Library ni en las ramas GitHub.
- GDRE Tools v2.7.4 recuperó 39 scripts editables (ningún fallo), detectó Godot4.7.2 y bytecode4.5 ebc36a7. Convirtió97 recursos,23 indicados como lossy; no se afirma restauración de píxeles originales anteriores a la compresión. Las doce imágenes regionales se recuperaron como PNG importables, no como CTEX renombrados.
- `docs/recovery/Preview32_editable_scripts.zip` preserva los .gd recuperados sin integrar y los JSON exactos de la APK. No contiene GDC usado como código de producción. Decompilado no equivale a recuperar comentarios ni historial Git original.
- `docs/recovery/E2_incremental.bundle` conserva exactamente HEADdc4a20a63c70526270350b28c4bb4fa950ffc303 y código42fed0ce330366de891ad7944e50e6d79f5836d8, requisito1719c6821319279f191734a0d4fbf836e9de428e. `git bundle verify` correcto en clon de GitHub.
- El envío Git nativo no dispone de credenciales. La rama remota feature/e2-regional-engine-recovered @1f65222 contiene el mismo árbol fuente de E2, con la única adición del bundle; comparación git diff verificada. El bundle preserva los SHA originales; el commit de importación tiene su propia identidad y no se presenta como dc4a20a.

## Comparación funcional implementada

| Función | Preview32 | E1 | E2 | Candidata |
|---|---|---|---|---|
| Valle Jade |6 etapas|4|4|6; ID históricos conservados|
| Bosque del Velo |6 etapas|ausente|ausente|6; accesoNv10/coste1/tope15 recuperados|
| Criaturas de combate |13|5|5|13; cifras y técnicas recuperadas, excepción Saku E1|
| Catálogo canónico |21|15|15|21; no confundir con13 criaturas de combate|
| Final regional |dos rivales consecutivos|ausente|motor en pruebas|Jade Inubari+Ushigane; Bosque Karasu-Origami+Mujina-Kage|
| Relevo Sakuromushi |apoyo sin relevo|golpe70%, relevo, +20%/2rondas|preservado|E1 conservado, incluido al derrotar primer rival|
| Motor regional |implementación anterior|heredado|contrato congelado y transacciones|E2 reutilizado; adaptador de datos Preview32|
| Recompensas |claves punto@1|heredadas|región/punto/v1|E2; conversión de claves sin volver a cobrar bonos|
| Captura final |un objetivo elegido|heredada|selección irreversible|una selección y tres intentos persistidos|
| Derrota y entrada |animadas|ataques|motor|flujos Preview32 y ataques E1|
| XP y vínculo |flujo continuo|ventana anterior|XP multinivel|flujo Preview32 con muestreo multinivel E2|
| Escenario |transiciones regionales|escena anterior|escena anterior|fondo completo en batalla y flujos; controles superpuestos|
| Guardados |formato divergente|base29|base29/E1|lector compatible y respaldo original antes de escribir|

No se alteran cifras recuperadas para facilitar las simulaciones; no se declara balance final aprobado.

## Persistencia y seguridad de actualización

Preview32 usa regional.version, claves punto@1 y cambia enemy_index al elegir captura. E2 usa regional.schema, enemigos congelados dentro del contrato y enemy_index conserva el último rival vencido. `preview32_contract.gd` conserva únicamente el validador anterior; `preview32_migration.gd` convierte contratos y claves, conserva HP/efectos/recargas/turno/selección/rolls/XP/colección y valida después el perfil completo. No se cambian encuentros activos sin contrato ni capturas históricas de nivel1.

La lectura no escribe. Antes del primer guardado que sustituya un perfil Preview32, se copia el archivo original a `.pre-unification`; si no se puede preservar, el guardado se rechaza. Sigue funcionando el respaldo transaccional .bak/.tmp. No se elimina la partida para resolver corrupción.

Se verificó el mismo certificado SHA256 en Preview32, E2 y el keystore de previews del repositorio:756c8c1a8136ae2e80987c540d805641d7bfd2d5b657d1f04584f0074ac61bf8. La CI debe verificar también la firma del APK candidato. La instalación es una actualización del paquete de previews, sin desinstalar.

## Pruebas reproducibles

69 JSON generados ejecutando el motor recuperado original de Preview32: batalla, relevo rival, victoria, elección, intento, captura, mapa, respuesta pendiente, derrota y reemplazo aliado, incluyendoXPparcial. La suite de unificación verifica la carga, conservación, recarga exacta, copia original e idempotencia y continúa combates/vínculos. Además recorre los12 puntos reales, costes, contratos, finales, capturas y activos importados. No se generan los fixtures con el migrador nuevo.

Las suites históricas de ruta/progresión/UI ejecutan sus contratos anteriores sobre los JSON de Preview29 conservados en tests/fixtures/preview29. Se mantienen sus asserts. La campaña real de doce puntos se prueba aparte; los conteos canónicos se amplían a21. Las pruebas E2 usan datos históricos explícitos para el encuentro pre-E2 y navegan por el nuevo flujo de elección. Las pruebas de vínculo finalizan la nueva presentación de derrota antes de intentar capturar.

```sh
godot --headless --editor --path . --import --quit
godot --headless --path . --script tests/unification_tests.gd
godot --headless --path . --script tests/unification_ui_tests.gd
godot --headless --path . --script tests/regional_balance_tests.gd
python3 -m unittest discover -s tests -p test_apk_privacy.py
```

Ejecutar también todas las suites de .github/workflows/android-preview.yml. La revisión visual renderiza22 pantallas de mapas/combate/derrota/XP/elección/vínculo con texto normal y grande en CI. Las24 simulaciones deterministas ejercitan cada etapa con equipo al nivel rival y dos niveles inferior; son pruebas de finalización e integridad, no sustituyen playtest.

## Validación física del creador

1. Anotar versión instalada y equipo/progreso actual. Instalar la candidata encima; no desinstalar ni borrar datos. Si Android rechaza actualizar, conservar la partida y reportar el mensaje.
2. Verificar colección, niveles, XP parcial, Libro, puntos, compras, stamina y ajustes. Si había encuentro abierto, retomarlo sin cobrar de nuevo ni cambiar HP/rival.
3. Confirmar seis puntos en cada mapa. Bosque conserva el accesoNv10 y desbloqueo de un punto; no aparece abierto gratis en partida nueva.
4. Con Sakuromushi activo y reserva viva, usar Insignia y elegir compañero: ver golpe, salida/entrada, bonificación y respuesta rival contra el entrante.
5. En una final, vencer al primer rival: entra el segundo sin curar aliados ni atacar gratis. Solo al vencer al último se concede recompensa.
6. Ver derrota→victoria→XP→elección→vínculo sobre el mismo escenario. Elegir un rival final e intentar vincular; cerrar/reabrir entre intentos conserva la elección y los intentos.
7. Repetir etapa: recibir XP de repetición, sin cobrar el bono inicial otra vez. Probar también una etapa ya completada en Preview32.
8. Perder con reserva, elegir reemplazo y comprobar ausencia de ataque extra. Perder el equipo completo, cerrar/reabrir y volver al mapa sin perder avance.
9. Probar texto grande, movimiento reducido, sonido y Atrás de Android; informar versión del APK y pasos ante cualquier fallo.
10. Solo después confirmar «prueba correcta» sobre esta candidata. Hasta entonces, no integrar en dev.

### Recuperación reproducible de fixtures
Los scripts en ci/recovery se ejecutan con Godot4.7.2 sobre el proyecto original descomprimido desde docs/recovery/Preview32_editable_scripts.zip (con sus recursos recuperados), no sobre el motor unificado:

```sh
godot --headless --path /ruta/preview32-recuperado --script /ruta/repositorio/ci/recovery/generate_campaign_fixtures.gd -- --output=/ruta/fixtures
godot --headless --path /ruta/preview32-recuperado --script /ruta/repositorio/ci/recovery/generate_edge_fixtures.gd -- --output=/ruta/fixtures
```

Revisión gráfica local posterior:22pantallas renderizadas con Mesa/Xvfb, texto normal/grande, mapas de ambas regiones y flujos regionales. Se detectó y corrigió un fondo secundario estrecho en la vista previa del Libro: ahora esa vista dibuja solo actores/Libro sobre el escenario continuo. La animación de vínculo a pantalla completa conserva su fondo. Las24simulaciones terminaron en victoria,4–22rondas, sin tocar estadísticas. La aceptación final de ritmo y estética sigue siendo humana.

### Compatibilidad directa de la fuente E2
Además de las regresiones del motor, tests/e2_source_compatibility_tests.gd carga diez guardados generados ejecutando dc4a20a original: encuentros heredados y regionales, respuesta pendiente, relevo aliado E1, relevo rival, victoria, elección, intento, captura y mapa. Comprueba130condiciones de conservación/recarga. Los JSON están en tests/fixtures/e2; generador ci/recovery/generate_e2_fixtures.gd, ejecutable sobre el worktree original con --output=/ruta/fixtures. La formación sintética del generador ejercita el contrato preparado en E2 y no añade contenido al juego.

## Resultado final de esta entrega
[Descargar Preview38 / v0.21.0-unification](https://github.com/axenoban/karmany-monsta-android/releases/download/android-preview-38/karmany-monsta-preview.apk). [CI correcta](https://github.com/axenoban/karmany-monsta-android/actions/runs/38824304295). [PR18 borrador](https://github.com/axenoban/karmany-monsta-android/pull/18).

4409checks únicos Godot/26suites y3Python correctos; la suite UI se repite además al renderizar22pantallas. Todas las24simulaciones finalizaron con victoria en4–22rondas. No implica aprobación humana del balance. SHA256APK16a66fc970346981eb628f7ac4a04a7633eac8ff08b93a735d723c7bb37c08ac;83365989bytes. Código fuente, dosregiones y ausencia de tests/ci/docs verificados dentro delAPK descargado. Firma v2/v3 correcta y certificado igual al de Preview32/E2. Conservar partida mediante actualización sin desinstalar; ante rechazo de instalación, reportar el mensaje conservando los datos.

Limitaciones explícitas: no se ha ejecutado en el dispositivo físico del creador; el historial Git y los comentarios originales de Preview32 no pueden recuperarse de laAPK; las imágenes se recuperan de sus recursos ya comprimidos. La procedencia editable, las mecánicas y los formatos de partidas sí se implementaron y probaron. No se afirma equivalencia visual física definitiva ni balance final aprobado. Esperar prueba del creador antes de integrar.
