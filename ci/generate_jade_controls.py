"""Editable candidate controls derived from Preview104 geometry and palette.
No PR24 assets. Run from repository root. Approval pending.
"""
from pathlib import Path
OUT = Path('assets/ui/jade/controls_v2')
OUT.mkdir(parents=True, exist_ok=True)
STYLES = {
    'normal': ('103c34', '648d78'), 'hover': ('195446', '83ddb3'),
    'pressed': ('082522', 'd8c18b'), 'disabled': ('20352f', '52665b'),
    'primary': ('344a32', 'd8c18b'), 'primary_hover': ('344a32', 'f4efdf'),
    'primary_pressed': ('082522', 'd8c18b'),
    'selected': ('205441', '83ddb3'), 'selected_hover': ('27624c', '83ddb3'),
    'selected_pressed': ('082522', '83ddb3'),
}
SHAPE = 'M12 1H116L127 12V52L116 63H12L1 52V12Z'
for name, (fill, edge) in STYLES.items():
    inactive = name == 'disabled'
    pressed = 'pressed' in name
    primary = name.startswith('primary')
    selected = name.startswith('selected')
    ornament = ''
    if not inactive:
        # All decorative corners remain in the fixed 14px nine-patch margins.
        ornament = f'<path d="M3 14L14 3M114 3L125 14M3 50L14 61M114 61L125 50" stroke="#{edge}" stroke-opacity=".55" fill="none"/>'
    if primary or selected:
        ornament += f'<path d="M7 25L10 32L7 39L4 32Z M121 25L124 32L121 39L118 32Z" fill="#{edge}"/>'
    if selected:
        ornament += f'<path d="M17 57H111" stroke="#{edge}" stroke-width="2"/>'
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="128" height="64" viewBox="0 0 128 64">
<path d="{SHAPE}" fill="#{fill}" stroke="#{edge}" stroke-width="1.5"/>
<path d="M14 4H114L124 14H4Z" fill="#{'082522' if pressed else 'f4efdf'}" opacity="{'.22' if pressed else '.07'}"/>
<path d="M4 50H124L114 60H14Z" fill="#082522" opacity=".28"/>
<path d="M16 5H112M16 59H112" fill="none" stroke="#{edge}" stroke-opacity=".25"/>
{ornament}
</svg>
'''
    (OUT / f'{name}.svg').write_text(svg)
(OUT / 'focus.svg').write_text(f'<svg xmlns="http://www.w3.org/2000/svg" width="128" height="64" viewBox="0 0 128 64"><path d="M13 3H115L125 13V51L115 61H13L3 51V13Z" fill="none" stroke="#d8c18b" stroke-width="2"/></svg>\n')
print('11 candidate textures generated; shared geometry, not 11 distinct designs')
