# Skills locales · Karmany Monsta Android

Estas cinco skills instruyen a Codex y a agentes con acceso al repositorio; **no** instalan plugins ni modifican Godot. Cada carpeta contiene un `SKILL.md` con frontmatter válido. Codex puede descubrir automáticamente las skills del proyecto en `.agents/skills/`; ChatGPT Work puede leerlas explícitamente cuando tiene acceso a esta rama/repo. No se garantiza activación automática en todos los clientes.

| Skill | Activar para |
|---|---|
| [godot-ui-ux](godot-ui-ux/SKILL.md) | flujos, HUD, navegación y experiencia táctil |
| [game-visual-system](game-visual-system/SKILL.md) | componentes, identidad Jade Nocturno, estados e iconografía |
| [godot-ui-implementation](godot-ui-implementation/SKILL.md) | Control/Theme/StyleBox, escenas y recursos |
| [android-game-qa](android-game-qa/SKILL.md) | capturas, CI/APK, pruebas físicas y regresiones |
| [godot-gameplay](godot-gameplay/SKILL.md) | reglas autorizadas, GDScript, estado y persistencia |

**Precedencia:** instrucciones del creador y `AGENTS.md` > contratos/canon aprobados > skills > propuestas pendientes. En conflicto, no adivinar ni modificar contenido canónico.

**Jade Nocturno:** dirección propuesta 02 escogida por el creador. El PR24 contiene un kit propuesto pero no se considera íntegramente aprobado; el PR23 y otras ramas de UX no están incorporados al baseline `dev/karmany-core`. Revisar estado real de cada PR antes de aprovechar archivos. Nunca asumir rutas de arte que aún no están en la rama actual.

Validar estructura: `python ci/validate_skills.py`.

[Guía para Chat, Work y Codex](../../docs/SKILLS_DESARROLLO.md).
