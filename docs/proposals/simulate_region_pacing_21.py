"""Arithmetic review of a proposed curve, not a combat/balance test of the game.
Run from any directory; no save files or runtime configuration are modified.
"""
import json
import math
from pathlib import Path


def advance(level, xp, amount, cap):
    if level >= cap:
        return level, xp
    xp += amount
    while level < cap and xp >= 100 * level:
        xp -= 100 * level
        level += 1
    return (level, 0) if level >= cap else (level, xp)


def review():
    spec = json.loads(Path(__file__).with_name('region_pacing_21.json').read_text())
    assert spec['status'] == 'proposal_not_implemented'
    assert spec['xp_per_level'] == 100
    lines = ['# Revisión aritmética de progresión · propuesta21', '',
             'No simula daño, turnos, capturas, derrotas ni stamina. Supone un individuo',
             'presente en el equipo desde el inicio de cada región, nivel de entrada y XP0.',
             'Las cifras son propuestas, no configuración del APK.', '']
    for region in spec['regions']:
        stages = region['stages']
        assert 5 <= len(stages) <= 9
        assert len({s['primary'] for s in stages}) == len(stages)
        assert all(b['enemy_level'] >= a['enemy_level'] + 1
                   for a, b in zip(stages, stages[1:]))
        assert all(b['first_xp'] >= a['first_xp'] and b['repeat_xp'] >= a['repeat_xp']
                   for a, b in zip(stages, stages[1:]))
        assert all(0 < s['repeat_xp'] < s['first_xp'] for s in stages)
        assert len(stages[-1]['final_roster']) in [2, 3]
        assert stages[-1]['primary'] in stages[-1]['final_roster']
        required = sum(100 * level for level in range(region['entry_level'], region['cap']))
        assert sum(s['first_xp'] for s in stages) == required
        level, xp = region['entry_level'], 0
        lines += [f"## {region['id']}: {level} → {region['cap']}", '',
                  '| Etapa | Nivel rival | XP primera victoria | XP repetición | Nivel/XP al salir |',
                  '| --- | --- | --- | --- | --- |']
        for i, stage in enumerate(stages, 1):
            level, xp = advance(level, xp, stage['first_xp'], region['cap'])
            lines.append(f"| {i} | {stage['enemy_level']} | {stage['first_xp']} | {stage['repeat_xp']} | {level}/{xp} |")
        assert (level, xp) == (region['cap'], 0)
        # Cap is individual: a capped trainer does not prevent a lower teammate gaining.
        assert advance(region['cap'], 0, stages[0]['first_xp'], region['cap']) == (region['cap'], 0)
        assert advance(1, 0, stages[0]['first_xp'], region['cap'])[0] > 1
        lines += ['', f'Total: {required}XP en {len(stages)} encuentros ganados por primera vez.',
                  f'Con 25XP constantes: {math.ceil(required / 25)} victorias.',
                  f'Con 100XP constantes: {math.ceil(required / 100)} victorias.',
                  'La final entrega una recompensa de etapa; no se multiplica por número de rivales.', '']
    return '\n'.join(lines)


if __name__ == '__main__':
    print(review())
