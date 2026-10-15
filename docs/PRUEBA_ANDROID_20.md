# Bloque20 · Ventana de experiencia y subida de nivel

Versión0.17.0. Instalar sobre la preview anterior sin borrar datos.

1. Ganar un combate de localización. Antes del vínculo aparece «EXPERIENCIA ADQUIRIDA»: entrenador y cada Karmany del equipo principal, retrato, XP obtenida, nivel y barra. La colección fuera del equipo no aparece.
2. Con progreso inicial Nv1/XP0, la cuarta victoria de localización llena100XP y sube aNv2. La barra llega al máximo, cambia de nivel y muestra el sobrante si existe. Verificar que coincide con Equipo y mapa tras cerrar.
3. Al subir un Karmany, revisar Vida/Ataque/Defensa anteriores → nuevas y sus incrementos; Velocidad se conserva. Ejemplo Zephyr Nv1→2: Vida80→84, Ataque20→21, Defensa8→8, Velocidad10→10.
4. Con equipo mixto y un integrante enNv10, ese integrante recibe0XP y muestra barra completa/límite regional; los inferiores siguen recibiendoXP. Al pasar de9 a10 solo se informa la XP aplicada hasta el límite.
5. Pulsar Continuar antes de terminar la animación y usar Atrás de Android en otra victoria. Ambos cierran el resumen sin perderXP y mantienen la pantalla de vínculo.
6. Capturar, salir/volver al combate, reabrir menús y reiniciar la aplicación: no se repite la ventana como nueva recompensa ni se concedeXP adicional. El resumen compacto anterior permanece disponible en el combate. Si se interrumpe antes de ver la ventana, la recompensa ya está guardada.
7. Entrenamiento libre no abre esta ventana ni concedeXP. Derrota/retirada conservan su comportamiento.
8. Activar Movimiento reducido: se muestran inmediatamente las barras finales y cambios de estadísticas. Probar también Texto grande, equipo de3, desplazamiento vertical y botón Continuar accesible. Volumen/silencio siguen aplicándose al aviso de nivel.

Pendiente: validación física del creador; las pruebas automatizadas/escritorio no la sustituyen. Las reglas y pruebas del bloque19 siguen vigentes.
