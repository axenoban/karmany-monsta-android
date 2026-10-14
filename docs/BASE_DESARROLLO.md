# Karmany Monsta Android — Base de desarrollo v0.2

Fecha: 14 de octubre de 2026.
Actualización: repositorio público creado por el usuario; reglas del Libro y escape aprobadas.
Estado: decisiones iniciales registradas; propuesta técnica y UX; reglas pendientes señaladas. No constituye un reglamento completo ni un APK.

## 1. Decisiones aprobadas por el creador

| Tema | Decisión |
|---|---|
| Plataforma | Android; validación física desde un POCO X6. |
| Exploración | Mapa 2D con puntos seleccionables. |
| Combate | Turnos tácticos. |
| Habilidades | Entre 2 y 4 habilidades por Karmany; una es insignia o especial. |
| Inicio narrativo | Ezel y Axe en Valle Jade. |
| Captura | Mediante el Libro. Sus mejoras aumentan probabilidades y desbloquean rarezas superiores; valores, costes y niveles pendientes. |
| Intentos | Máximo de tres intentos de captura cuando el Karmany ha sido derrotado. |
| Objetivo inmediato | Versión jugable y funcional; monetización por decidir tras las pruebas. |
| Arte | Imágenes generadas en otro chat a partir de instrucciones precisas preparadas por la dirección del proyecto. |
| Dirección | El asistente participa en arquitectura, programación, diseño, UX, documentación y pruebas; reglas ambiguas y cambios canónicos los decide el creador. |
| Repositorio | Nuevo, independiente del proyecto anterior. |

No están aprobados todavía: equipo de tres integrantes, orientación horizontal, rarezas desbloqueadas por nivel concreto, estadísticas, habilidades individuales, economía, costes de captura, evoluciones ni contenido narrativo nuevo.

## 2. Base técnica propuesta

- Godot 4.x estable y GDScript. Fijar la versión exacta después de comprobar disponibilidad de binarios, plantillas y exportación Android. No cambiar el motor durante un bloque sin justificación y regresión.
- Presentación 2D ilustrada; personajes y criaturas separados de fondos. Animación inicial mediante poses aprobadas, movimiento de piezas y efectos.
- Renderer Compatibility como candidato para este proyecto 2D. Validarlo físicamente antes de darlo por definitivo.
- Primera entrega propuesta sin conexión, sin cuentas ni servidor. Confirmar antes de convertirlo en requisito definitivo.
- GitHub Actions para importación, validación, pruebas y exportación APK.
- Clave de pruebas estable, protegida mediante secretos; paquete y versionCode coherentes para actualizar sin desinstalar. Separar firma de pruebas de distribución comercial.
- Guardado local versionado con escritura temporal y sustitución segura, copia de respaldo y futuras migraciones.
- Identificador de build, commit y versión visibles; registros exportables desde el dispositivo, sin recoger datos personales innecesarios.
- Objetivo inicial de rendimiento: 30 FPS estables en el dispositivo de prueba, con evaluación posterior de 60 FPS. Es un objetivo, no un resultado medido.

## 3. Arquitectura y responsabilidades

| Área | Responsabilidad |
|---|---|
| Catálogo canónico | Especies, biomas, fuente, restricciones y referencias de arte. |
| Datos jugables | Definiciones aprobadas de habilidades, estadísticas, progresión y reglas del Libro. |
| Individuos | Identidad persistente de cada criatura; estado separado de su especie. |
| Combate | Estado de turnos, acciones legales y resolución; independiente de animaciones. |
| Captura | Elegibilidad, intentos, resolución y alta de individuo. |
| Equipo y colección | Selección, consulta, almacenamiento y cambios de equipo. |
| Mapa | Puntos, conexiones, acceso y encuentros definidos mediante datos. |
| Narrativa | Diálogos y misiones aprobados; sin mezclar scripts de historia con reglas de combate. |
| Interfaz | Presentar datos, recoger acciones y explicar efectos con claridad. |
| Guardado y Android | Persistencia, suspensión, reanudación, botón Atrás y actualizaciones. |
| Calidad y entregas | Validación de referencias, pruebas, CI y distribución de builds. |

Cada especie debe poder indicar restricciones de captura sin codificar excepciones por nombre en múltiples escenas. Cada habilidad debe disponer de descripción coherente con su resolución real; la interfaz no calcula por separado el daño o la probabilidad de captura.

La aleatoriedad debe poder reproducirse en pruebas. Las animaciones no ejecutan el mismo efecto una segunda vez ni sobreviven a la salida de su escena.

## 4. Combate: contrato inicial y decisiones pendientes

Contrato aprobado: combate por turnos, 2–4 habilidades por criatura y una habilidad insignia o especial.

Diseño propuesto: elección clara entre habilidades con utilidades diferentes. Una habilidad especial no debe limitarse necesariamente a ser un ataque normal más potente; su función se decidirá a partir de la fisiología y resonancia canónicas de cada especie.

No asignar todavía cifras, efectos ni nombres de habilidades. Falta aprobar:

- Tamaño del equipo y número de criaturas simultáneas.
- Orden de turnos, cambio de criatura y condiciones de victoria/derrota.
- Recursos, recargas o límites de uso de habilidades.
- Diferencia entre habilidad insignia y habilidad especial, si la hubiera.
- Relación jugable entre resonancia lumínica y sombría.
- Progresión y aprendizaje de habilidades.

Estos puntos bloquean el reglamento de combate completo, pero no la base Android, navegación, guardado o diagnóstico.

## 5. Captura posterior a la derrota

Flujo aprobado hasta el nivel disponible:

1. El combate determina que el enemigo ha sido derrotado.
2. Se comprueba si la especie y el encuentro admiten captura mediante el Libro.
3. Se presenta la fase de captura con un máximo de tres intentos.
4. Una captura exitosa incorpora un único individuo a la colección.
5. El resultado se conserva en el guardado.

La captura debe explicarse de manera comprensible: Libro equipado, elegibilidad, intentos restantes y probabilidad, cuando esté definida y sea apropiado mostrarla.

Propuesta de implementación: una máquina de estados para impedir un cuarto intento, acciones dobles y capturas duplicadas. Conservar el estado del encuentro al suspender la aplicación. No resetear automáticamente los intentos al cerrar el juego.

Pendientes que necesitan decisión del creador:

1. Aprobado: las mejoras hacen ambas cosas. Faltan niveles, costes y tablas aprobadas.
2. Aprobado: tras tres fallos, la criatura escapa y termina el encuentro. Puede volver a encontrarse posteriormente; la probabilidad y disponibilidad del reencuentro no están definidas.
3. ¿Existe coste por intento? No se añadirá un consumible por analogía con Monster Galaxy.
4. ¿La captura también es posible durante el combate? El alcance actual implementará solamente la fase posterior a la derrota hasta que se apruebe una alternativa.

No asumir que quedar con cero vida causa muerte narrativa. Debe definirse la representación de la derrota y su compatibilidad con la captura.

## 6. Canon disponible y protección

Fuente actual: Enciclopedia Oficial de Shisai, aportada por el creador. Incluye 75 especies y cinco grupos de biomas: Tierras Bajas de Jade, Bosque del Velo, Altar de Humo y Cavernas Volcánicas, Pantano de los Faroles Ahogados, Ukishima y Costas de Niebla.

La enciclopedia describe ecología, fisiología, comportamiento y resonancia. No ofrece una tabla completa de estadísticas, daño, habilidades, probabilidades ni progresión para este videojuego.

Restricciones relevantes:

- Orochi-Gami no puede sellarse en un Libro sin quebrantar su esencia. No convertirlo automáticamente en una captura ordinaria.
- Las comunidades costeras rechazan el sellado; trasladarlo al juego exige respetar su contexto narrativo.
- Zephyr tiene vínculo lumínico firme con Ezel; el documento indica que su resonancia sombría es inalcanzable por ahora. No generar una variante sombría como si fuera canónica.
- Shisai combina jade, bambú, origami, madera, bronce y máscaras tradicionales. No introducir mutaciones tecnológicas sofisticadas en su arte.
- El documento presenta a Axe como anciano en este contexto. No reutilizar automáticamente su descripción de otra etapa de la historia.
- Faltan referencias visuales aprobadas de Ezel y Axe para este inicio. No fijar edad, vestuario, rostro ni equipo ausentes del material fuente.

Cada dato nuevo deberá distinguirse como propuesta jugable o canónica pendiente de aprobación. Las reglas del juego de mesa no se importan automáticamente.

## 7. UX inicial propuesta

Orientación horizontal recomendada para mostrar criaturas enfrentadas y hasta cuatro habilidades legibles. Pendiente de validación del creador; no exigir rotación durante una sesión.

Pantallas iniciales:

1. Inicio: continuar, nueva partida y ajustes; confirmación antes de sobrescribir partida.
2. Valle Jade: mapa por puntos con acceso y objetivo visibles.
3. Encuentro: información suficiente antes de comenzar.
4. Combate: enemigo, criatura activa, estado y 2–4 acciones; habilidad insignia identificable sin depender solamente del color.
5. Captura: Libro, elegibilidad e intentos restantes.
6. Resultado: captura/recompensas y próximo paso sin pantallas redundantes.
7. Colección y equipo: ficha clara con funciones y habilidades.
8. Libro: mejoras y efectos descritos únicamente con las reglas aprobadas.
9. Diagnóstico: versión, build y exportación de registros.

Botones amplios, contraste suficiente, texto en español, zonas seguras para cámara y barras del sistema. Toda pantalla debe tolerar interrupciones; las animaciones no deben bloquear indefinidamente la interacción. Mostrar motivos cuando una acción no está disponible.

## 8. Flujo remoto y Git

Repositorio aprobado: https://github.com/axenoban/karmany-monsta-android. Visibilidad pública por elección del creador.

- main: versiones publicables.
- dev/karmany-core: última versión completa validada.
- feature/*: bloques pendientes de validación.

Antes de una integración: comprobar HEAD remoto, rama, historia, cambios y checks. No force push ni reescritura de historia; preferir fast-forward cuando sea posible.

El baseline inicial no se marca como validado antes de que el APK sea probado. Cada entrega incluye commit, versión, enlace y prueba breve. Tras «prueba correcta», cerrar documentación del bloque, integrar cuando sea seguro, verificar baseline y continuar con el siguiente bloque sin decisiones pendientes.

Limitación de acceso observada: la conexión GitHub disponible permite trabajar con repositorios existentes, pero no ofrece crear repositorios. El creador ya creó el repositorio. Se verificó acceso de escritura y su estado inicial vacío.

## 9. Primer bloque autorizado y verificable

Objetivo: demostrar el flujo completo repositorio → compilación → APK → instalación → actualización en el POCO X6.

Entregables propuestos:

- Proyecto Godot y configuración Android.
- Workflow reproducible con versión exacta de motor y plantillas.
- Menú, ajustes básicos y navegación de prueba.
- Guardado local y recuperación de respaldo.
- Manejo de suspensión, reanudación y botón Atrás.
- Pantalla de diagnóstico y versión.
- Documento de decisiones y protocolo de prueba.

Prueba física: instalar, abrir, modificar una opción, cerrar, volver a abrir, suspender/reanudar y actualizar con una segunda build. Resultado esperado: sin errores de arranque, sin pérdida de guardado ni de ajustes y con versión correcta.

No declarar combate ni captura implementados en este bloque. Sus reglas siguen pendientes.

## 10. Guía para el chat de ilustración

El generador no sustituye a la dirección artística. Trabajar por criatura o fondo, validar proporciones y materiales, y conservar la referencia aprobada para posteriores variantes. No producir el bestiario completo antes de validar una criatura en pantalla.

### Instrucción maestra para copiar

Actúa como ilustrador de producción del videojuego Android Karmany Monsta. Genera únicamente el activo solicitado; no inventes lore, habilidades, accesorios, anatomía ni variantes ausentes de la ficha. Si falta información indispensable sobre un personaje, solicita su referencia antes de fijar su apariencia.

Dirección visual propuesta: ilustración 2D pintada de fantasía, formas y siluetas legibles en una pantalla pequeña, detalle controlado y materiales claramente diferenciados. Shisai debe expresar humedad, niebla, jade, bambú, madera, bronce y artesanía medieval japonesa. Evita tecnología moderna y motivos zodiacales añadidos. La legibilidad tiene prioridad sobre el detalle ornamental.

Para criaturas de combate: cuerpo entero, sin recortes, pose en tres cuartos orientada hacia la derecha, silueta despejada, fondo transparente real y margen suficiente para apéndices. Lienzo cuadrado de 1024 × 1024 como objetivo de producción; comprobar las dimensiones reales del archivo entregado. No incluyas textos, marcos, interfaz, logotipos ni personajes adicionales. No incrustes un suelo o una sombra ambiental en el recorte. Evita asimetrías que impidan reutilizar la imagen reflejada, salvo que la anatomía canónica las exija.

Para fondos: imagen independiente, horizontal, sin interfaz ni criaturas; reserva el centro de atención para la escena jugable. Usa referencias de composición aprobadas. No diseñes conexiones de mapa ni edificios canónicos nuevos sin una ficha específica.

Cada variante posterior debe usar la imagen aprobada como referencia y conservar anatomía, proporciones y rasgos distintivos. Lumínico y sombrío solo se generan cuando la ficha de la especie los autorice y la dirección solicite esa variante.

### Primera ficha sugerida: Tanugami, apariencia base

Estado: candidato para validar estilo; no confirma su selección jugable ni sus estadísticas.

Fuente canónica: especie común de Tierras Bajas de Jade. Mamífero inspirado en el tanuki; cuerpo esférico de pelaje áspero marrón. Tiene una protuberancia ósea dorsal que al madurar adquiere consistencia de calabaza leñosa hyotan y queda fusionada a su estructura ósea. Es manso y sociable, con garras delanteras que utiliza para remover tierra y buscar raíces.

Solicitud: una ilustración de cuerpo entero con la calabaza dorsal visible como parte anatómica, no como mochila ni objeto con correas. Mantén su carácter sociable sin humanizarlo. No añadas ropa, bastón, monedas, ornamentos, poderes nuevos ni fuego. En esta imagen no actives resonancia lumínica ni sombría; no la etiquetes como una tercera forma canónica. Aplica el formato de criatura de combate de la instrucción maestra.

Validación: silueta reconocible en tamaño reducido; calabaza integrada al cuerpo; pelaje marrón; anatomía consistente; recorte y transparencia correctos. Si hay dudas visuales, ajustar esta referencia antes de producir otras especies.

## 11. Próximas decisiones, en orden

1. Validar el primer APK del repositorio nuevo.
2. Diseñar tablas del Libro y reglas de combate para aprobación.
3. Confirmar orientación y operación sin conexión.
4. Aprobar reglamento breve de combate y primeras especies.
5. Obtener fichas visuales de Ezel y Axe de esta etapa.
6. Probar una ilustración en el APK antes de escalar el arte.

No se fija fecha comercial ni presupuesto final. Medir primero el esfuerzo real de una build Android, una criatura integrada, un encuentro completo y una zona jugable.
