"""Arithmetic screening of a design proposal, NOT the production Godot combat.

Run: python3 docs/proposals/simulate_combat_10.py
No trainer, switching, targeting reserves, capture or random outcomes modeled.
Both sides use a ready signature; Tanugami only if at least 12 life is missing.
Sakuromushi applies support to itself. Basic attack otherwise. Player acts first.
The 60-round bound reports inconclusive outcomes rather than declaring victory.
"""
import json
import math
from pathlib import Path

ROOT = Path(__file__).parent
SPECIES = json.loads((ROOT / 'combat_10.json').read_text())['species']

def rounded(number):
    return math.floor(number + 0.5)  # Godot roundi for positive combat values

def actor(key):
    return dict(key=key, hp=SPECIES[key]['life'], ready=1, guard=0, boost=0, weaken=0)

def action(source, target, turn):
    stats = SPECIES[source['key']]
    signature = stats['signature']
    usable = turn >= source['ready']
    if 'heal' in signature:
        usable = usable and stats['life'] - source['hp'] >= signature['heal']
    effect = signature if usable else {'power': 1}
    if usable:
        source['ready'] = turn + signature['cooldown'] + 1
    if 'power' in effect:
        raw = max(1, rounded(stats['attack'] * effect['power'] * (1 + source['boost']) - SPECIES[target['key']]['defense']))
        damage = max(1, rounded(raw * (1 - target['guard']) * (1 - source['weaken'])))
        target['hp'] = max(0, target['hp'] - damage)
        target['guard'] = 0
        source['boost'] = 0
        source['weaken'] = 0
    if 'heal' in effect:
        source['hp'] = min(stats['life'], source['hp'] + effect['heal'])
    source['guard'] = max(source['guard'], effect.get('guard', 0))
    target['weaken'] = max(target['weaken'], effect.get('weaken', 0))
    source['boost'] = max(source['boost'], effect.get('grant_boost', 0))

def duel(player, enemy):
    a, b = actor(player), actor(enemy)
    for turn in range(1, 61):
        action(a, b, turn)
        if b['hp'] == 0:
            return ('victoria', turn, a['hp'], b['hp'])
        action(b, a, turn)
        if a['hp'] == 0:
            return ('derrota', turn, a['hp'], b['hp'])
    return ('inconcluso', 60, a['hp'], b['hp'])

def report():
    lines = ['# Cribado aritmético · propuesta 10', '',
             'Generado por `python3 docs/proposals/simulate_combat_10.py`.', '',
             'No es una prueba del juego ni una aprobación de balance. Política fija: insignia disponible, salvo curación sin 12 de Vida perdidos; ataque básico en el resto. Sin entrenador ni cambios, apoyo a sí mismo. Jugador primero. Rival usa las mismas reglas. Límite de 60 turnos: se informa inconcluso si se alcanza.', '',
             '| Jugador | Rival | Resultado | Turno | Vida jugador | Vida rival |',
             '|---|---|---|---:|---:|---:|']
    for player in SPECIES:
        for enemy in SPECIES:
            if enemy == 'zephyr':
                continue  # Zephyr remains starter; no wild encounter is proposed.
            result, turn, player_hp, enemy_hp = duel(player, enemy)
            lines.append(f'| {player} | {enemy} | {result} | {turn} | {player_hp} | {enemy_hp} |')
    return '\n'.join(lines) + '\n'

if __name__ == '__main__':
    print(report(), end='')
