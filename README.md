> Antes de desarrollar: leer [Continuidad](docs/CONTINUIDAD.md) y [AGENTS.md](AGENTS.md).

# Karmany Monsta Android

Videojuego Android del universo Karmany Monsta. Baseline validado: Preview 19 (0.10.0), con exploración, stamina y combate. La nueva Preview 0.11.0 añade fichas de localización antes de gastar, cuatro fondos de combate y dirección artística renovada de mapa, cinco Karmany, dos personajes e interfaz. Conserva partida, Libro, árbol, equipo, balance y animaciones. Pendiente de validación física.

Ramas previstas: main (publicable), dev/karmany-core (baseline validado), feature/* (trabajo pendiente de validación).

## Probar desde Android

Descargar el APK de la preview más reciente en [Releases](https://github.com/axenoban/karmany-monsta-android/releases). Para la nueva entrega, seguir [Prueba Android 14](docs/PRUEBA_ANDROID_14.md). Cada entrega permite instalación y actualización sobre la preview anterior.

## Documentación

- [Localizaciones y dirección artística](docs/LOCALIZACIONES_ARTE_14.md), pendiente de validación.
- [Exploración, stamina e interfaz](docs/EXPLORACION_STAMINA_UI_13.md), validada en Preview 19.

- [Recorrido guiado de Valle Jade](docs/RECORRIDO_JADE_12.md), validado en Preview 18 (0.9.0).

- [Decisiones, arquitectura y guía del chat de ilustración](docs/BASE_DESARROLLO.md).
- [Compilación y firma pública de pruebas](ci/README.md).
- [Workflow Android](.github/workflows/android-preview.yml).
- [Prueba Android 02](docs/PRUEBA_ANDROID_02.md).
- [Propuesta de combate para aprobación](docs/COMBATE_PROPUESTA_01.md).
- [Decisiones de entrenadores](docs/DECISIONES_ENTRENADORES_03.md).
- [Prueba Android 03](docs/PRUEBA_ANDROID_03.md).
- [Turno automático](docs/TURNO_AUTOMATICO_09.md).
- [Prueba Android 07](docs/PRUEBA_ANDROID_07.md).
- [Corrección sin resonancias y revisión de imágenes](docs/CORRECCION_SIN_RESONANCIAS_08.md).
- [Última acción](docs/CORRECCION_ULTIMA_ACCION.md).
- [Equipo jugable](docs/EQUIPO_JUGABLE_07.md).
- [Prueba Android 06](docs/PRUEBA_ANDROID_06.md).
- [Encuentro jugable y fuentes](docs/ENCUENTRO_JUGABLE_06.md).
- [Prueba Android 05](docs/PRUEBA_ANDROID_05.md).
- [Análisis y decisiones del árbol](docs/ARBOL_RESONANCIAS_05.md).
- [Prueba Android 04](docs/PRUEBA_ANDROID_04.md).

Godot 4.7.2 · GDScript · 2D · mapa por puntos · combate táctico jugable. Inicio: Ezel y Axe en Valle Jade. Libro: mejoras desbloquean rarezas y aumentan probabilidades; tres intentos tras derrota y escape al agotarlos, con posibilidad de reencuentro.
