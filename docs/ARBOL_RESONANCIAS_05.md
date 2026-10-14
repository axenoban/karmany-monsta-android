# Árbol de resonancias · Preview 0.4.0

## Análisis y decisión aplicada

| Alternativa | Ventaja | Problema |
| --- | --- | --- |
| Solo niveles del entrenador | Progreso continuo y predecible | Capturar aporta poco al aprendizaje |
| Solo número de capturas | Premia la colección | Repetir criaturas puede dominar la progresión; dificulta estilos centrados en combate |
| Niveles + hitos de especies distintas | Progreso continuo y premio a explorar | Requiere controlar duplicados |

Se aplica la opción híbrida. Cada nivel concede un punto, incluido el nivel inicial 1. Capturar 5, 10 y 15 especies distintas concede un punto adicional por hito. Las capturas repetidas no aportan puntos. Los hitos no sustituyen los requisitos de nivel. Los valores son balance experimental para esta prueba, no una economía final.

## Árbol y equipamiento

- Cuatro espacios en total, incluida la resonancia propia. Tres limitarían las combinaciones; cinco permitirían equipar todo el repertorio inicial y eliminarían la decisión de equipamiento.
- Aprender y equipar son acciones distintas. Retirar una resonancia conserva su aprendizaje y rango.
- Ramas generales: Curación → Potenciación y Protección → Control. Las raíces requieren nivel 1 y las segundas ramas nivel 2 y su raíz aprendida.
- Rama personal: Resonancia propia. Es un nodo provisional para probar mejoras y equipamiento; no asigna a Ezel un tipo, personalidad o poder canónico.
- Aprender y cada mejora cuestan un punto. Tres rangos por nodo: 100%, 110% y 120% de potencia. Mejorar exige dos niveles adicionales por rango sobre el requisito inicial. Nivel máximo de esta prueba: 10.
- No se añaden efectos de combate, costes de energía ni recargas. Los porcentajes son parámetros almacenados para la futura resolución de efectos. Las habilidades exclusivas/especiales/explosivas conservarán requisitos de tipo y personalidad cuando sus fichas estén definidas.
- El turno sigue siendo compartido: una acción del Karmany y una resonancia opcional del entrenador en orden libre. Equipar cuatro no habilita cuatro usos por turno.

## Alcance funcional y guardado

La interfaz permite seleccionar nodos, consultar requisitos, aprender, mejorar, equipar, retirar y revisar los cuatro espacios. Cada cambio se guarda de forma atómica; si falla la escritura, no se aplica al perfil visible. La compra comprueba el rango esperado para evitar que un doble toque consuma dos puntos.

El perfil migra de esquema 1 a 2 conservando la visita a Valle Jade y los ajustes. Añade el árbol a los perfiles anteriores. Leer el perfil no reescribe los bytes; una acción posterior guarda el esquema nuevo. Se mantienen copia de seguridad y recuperación existentes. Comenzar viaje nuevo reinicia árbol y viaje, conservando ajustes, previa confirmación.

Diagnóstico → Laboratorio del árbol permite simular niveles y especies diferentes. La simulación modifica únicamente el progreso experimental del árbol, no crea criaturas en una colección ni representa un encuentro real. Redistribuir puntos elimina rangos y equipamiento, conserva niveles e hitos y devuelve todos los puntos gastados. Esta función es exclusiva del laboratorio de pruebas.

## Validación

221 comprobaciones locales: base 40, catálogo/captura 38, Libro/entrenadores 33, turno/aprendizaje 54 y árbol/migración 56. Se verifican niveles y prerrequisitos, hitos únicos, costes y rangos, límite de cuatro, intercambio de equipamiento, persistencia, migración, rechazo de datos inválidos, doble toque y reversión ante fallo de escritura.

CI exporta y verifica la firma del APK y renderiza pantallas del árbol, equipamiento y laboratorio, incluyendo texto grande y cuatro espacios ocupados. La aprobación en el POCO X6 sigue pendiente; no integrar a dev/karmany-core antes de esa prueba.
