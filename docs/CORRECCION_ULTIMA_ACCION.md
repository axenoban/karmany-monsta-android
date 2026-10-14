# Corrección del mensaje de combate

Solicitud: mostrar solo la última acción ejecutada, sin historial. Se encontraron textos genéricos para resonancias distintas y un aviso de transición a captura que reemplazaba el último golpe.

El encuentro conserva un solo last_action. El mensaje incluye actor, habilidad y resultado, y se sustituye únicamente al resolver una nueva acción válida. La transición de fase no lo reemplaza. Una acción rechazada no modifica el mensaje; el error se muestra aparte. Los guardados antiguos recuperan la última acción identificable de su historial, que se reduce a un solo registro sin alterar Vida, turnos, recargas, capturas o recompensas.

Verificación: 277 comprobaciones locales. Las 14 nuevas cubren mensajes de golpe, escudo, curación, rival, golpe final y Libro, persistencia y migración. Se pulsan además los botones reales de la pantalla y se verifica el texto después de reconstruirla. CI incluye el render de battle-last-action.png.
