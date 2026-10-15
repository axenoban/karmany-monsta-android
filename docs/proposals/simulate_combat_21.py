"""Design screening only. Reuses the documented Python combat approximation.
Not the production Godot engine. No trainer, capture, stamina or randomness.
Run python3 docs/proposals/simulate_combat_21.py; reads no player saves.
"""
import importlib.util
import json
from copy import deepcopy
from pathlib import Path

HERE = Path(__file__).parent
ROOT = HERE.parents[1]
spec = importlib.util.spec_from_file_location('combat_screening', HERE / 'simulate_combat_10.py')
pilot = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pilot)
base = json.loads((ROOT / 'data/tactical_combat.json').read_text())['species']
proposal = json.loads((HERE / 'combat_21.json').read_text())
assert proposal['status'] == 'experimental_proposal_pending_creator'
new = proposal['species']


def scaled(stats, level):
    result = deepcopy(stats)
    for key in ['life', 'attack', 'defense']:
        result[key] = pilot.rounded(stats[key] * (1 + .05 * (level - 1)))
    return result


def final_screen(player_level, enemy_level, enemies):
    # Separate IDs allow an allied and enemy Ushigane to have different levels.
    pilot.SPECIES = {f'ally_{i}': scaled(base[key], player_level)
                     for i, key in enumerate(['zephyr', 'ushigane', 'kitsunibi'])}
    pilot.SPECIES.update({f'enemy_{i}': scaled(new.get(key, base.get(key)), enemy_level)
                          for i, key in enumerate(enemies)})
    allies = [pilot.actor(f'ally_{i}') for i in range(3)]
    rivals = [pilot.actor(f'enemy_{i}') for i in range(len(enemies))]
    active, enemy = 0, 0
    for turn in range(1, 61):
        pilot.action(allies[active], rivals[enemy], turn)
        if rivals[enemy]['hp'] <= 0:
            enemy += 1
            if enemy == len(rivals):
                return 'victoria', turn, sum(a['hp'] for a in allies)
            # No attack from the incoming reserve. No free heal or extra ally action.
            continue
        pilot.action(rivals[enemy], allies[active], turn)
        if allies[active]['hp'] <= 0:
            active += 1
            if active == len(allies):
                return 'derrota', turn, 0
    return 'inconcluso', 60, sum(a['hp'] for a in allies)


def report():
    lines = ['# Cribado de cifras experimentales · bloque21', '',
             'No es una prueba del APK ni valida balance. Usa la aproximación Python del bloque10:',
             'insignia disponible, cura cuando falta su cantidad de Vida; apoyo a sí mismo;',
             'jugador primero, sin entrenador, sin azar ni decisiones tácticas alternativas.',
             'Escalado de estadísticas aprobado (+5% base/nivel); curación y recargas no escalan.', '',
             '| Nivel | Rival nuevo | Victoria de Zephyr | Turnos |',
             '| --- | --- | --- | --- |']
    counts = {'victoria': 0, 'derrota': 0, 'inconcluso': 0}
    turns = []
    for level in [1, 8, 10, 15]:
        pilot.SPECIES = {key: scaled(value, level) for key, value in {**base, **new}.items()}
        for rival in new:
            result, turn, _, _ = pilot.duel('zephyr', rival)
            lines.append(f'| {level} | {rival} | {result} | {turn} |')
        for player in base:
            for rival in new:
                result, turn, _, _ = pilot.duel(player, rival)
                counts[result] += 1
                turns.append(turn)
    assert sum(counts.values()) == 160
    lines += ['', f'Cribado completo:160 duelos (5 aliados conocidos ×8 candidatos ×4 niveles).',
              f'Resultados:{counts}; duración observada:{min(turns)}–{max(turns)} turnos.', '',
              '## Finales consecutivas con equipo de tres', '',
              'Equipo fijo Zephyr/Ushigane/Kitsunibi, cambio solo al caer el activo;',
              'sin restaurar Vida entre rivales. El límite60 informa inconcluso; no se amplía.', '',
              '| Final | Nivel aliado/rival | Resultado | Turnos | Vida total restante |',
              '| --- | --- | --- | --- | --- |']
    for name, a, b, enemies in [('Jade', 8, 10, ['inubari', 'ushigane']),
                               ('Bosque', 13, 15, ['karasu_origami', 'mujina_kage'])]:
        result, turn, hp = final_screen(a, b, enemies)
        lines.append(f'| {name} | {a}/{b} | {result} | {turn} | {hp} |')
    lines += ['', 'Es evidencia exploratoria, no garantía de dificultad o diversión.',
              'Antes de publicar: aprobar cifras y probar con el motor Godot real,',
              'equipos mixtos, resonancias, derrotas, guardado y captura.']
    return '\n'.join(lines) + '\n'


if __name__ == '__main__':
    print(report(), end='')
