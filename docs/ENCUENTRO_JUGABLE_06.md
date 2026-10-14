# Primer encuentro jugable · Preview 0.5.0

## Autorización y alcance

El creador aprobó el avance 0.4.0 y pidió mejorar touch y una entrega jugable con personajes, paisaje y Karmany. En el cuestionario de esta fase seleccionó fichas experimentales y Ezel/Zephyr frente a Tanugami. No se importan reglas del juego de mesa ni se presentan las cifras como canon.

Fichas de prueba de ambos combatientes: Vida 80, Ataque 20, Defensa 8, Velocidad 10. Daño = máximo de 1 y redondeo(Ataque × potencia × bonificación − Defensa). Golpe 100%; protección reduce 50% del próximo ataque; insignia 150%, dos turnos completos de recarga. Esta prueba usa la fase del jugador y después la del rival; no introduce todavía iniciativa por Velocidad ni afinidades. El rival alterna dos golpes básicos con una insignia cada tercer turno.

Un turno permite una acción del Karmany y una resonancia opcional, en orden libre. Cerrar turno requiere haber actuado con Zephyr; resuelve al rival. Potenciación usada después de Zephyr se conserva para su siguiente golpe. Al derrotar al rival, la captura comienza inmediatamente y no admite acciones de combate posteriores.

Efectos experimentales, fuera del canon: Curación recupera 18 de Vida; Escudo reduce 50% del próximo daño; Potenciación suma 25% al próximo golpe; Control reduce 30% el próximo daño rival; Raíces (nodo propio provisional) reduce 40%. Rangos escalan el valor por 100/110/120%; las reducciones defensivas se combinan multiplicativamente. Recarga general de dos turnos completos, Raíces tres. La curación a Vida completa no consume acción. El equipamiento se copia al comenzar el encuentro; los cambios posteriores en el árbol se aplican al siguiente.

La victoria concede un nivel experimental al entrenador, hasta el máximo 10; no se establece todavía una curva definitiva de XP. Derrota o abandono no conceden progreso. Cada encuentro nuevo comienza recuperado para facilitar pruebas, sin crear un sistema de economía o penalizaciones final.

## Libro y persistencia

Tanugami es Común y admite el Libro inicial aprobado: 45% por intento, máximo tres, éxito terminal y escape al fallar todos. Los tres resultados aleatorios se generan al crear el encuentro y se conservan: cerrar/reabrir no reinicia intentos ni permite volver a sortearlos. Un nuevo encuentro solo se crea tras terminar o abandonar el anterior.

La captura incorpora un único individuo identificado por encuentro. Capturas repetidas de Tanugami añaden individuos diferentes, sin repetir su bonificación de especie. Zephyr aparece como compañero vinculado desde su nacimiento y no como captura ordinaria.

El esquema del perfil avanza a 3 para guardar encuentro, colección y progreso. Migra esquemas 1 y 2 conservando viaje, ajustes, puntos, rangos y equipamiento. Cada acción guarda encuentro y recompensa en una sola transacción; una escritura fallida no cambia el perfil visible. Revisión esperada y contrato de turno impiden acciones repetidas por doble toque. Atrás/Mapa conservan el encuentro; Abandonar termina sin recompensa.

## Fuentes visuales y narrativa

- Enciclopedia Oficial de Shisai (PDF aportado), páginas 1–4 y entrada 66, página 23: valle agrícola húmedo, arroz/lino, Montaña Prohibida, Axe aislado, Tanugami, Zephyr negro con vetas doradas y ojos de plata; sin variante sombría.
- KARMANY MONSTA(1).docx, enciclopedia consolidada 3.0: ficha de Ezel, ~14 años tras eclosión, cicatriz en ceja izquierda, lino remendado y estilo defensivo; Axe ~75 años. El texto gráfico antiguo de 11 años se subordina a la corrección explícita de edad de la misma edición.
- La introducción usa la cita de pensamiento de Ezel «Si mis manos pueden hacer crecer una flor en la piedra, ¿por qué no pueden sostener el mundo?». No se inventa diálogo de Axe ni un nuevo episodio del argumento.
- Arte creado con ImageGen e integrado en assets/trial; instrucciones completas en assets/trial/prompts.json. Rasgos no documentados de Axe son interpretación visual provisional para validar, no una nueva ficha canónica.

No se requiere Blender para esta entrega 2D. Ilustraciones transparentes y fondo se componen en Godot. No hay aún animación esquelética, campaña narrativa completa, cambios de criatura activa o compra de mejoras del Libro.

## Touch del árbol

Los gestos que superan 16 unidades de desplazamiento no seleccionan nodos. La zona de scroll tiene umbral de 18. Seleccionar un nodo conserva la posición vertical del árbol, sin devolver al jugador al comienzo. Los botones de aprender/equipar permanecen fuera del área desplazable. La compra conserva la protección contra doble toque.
