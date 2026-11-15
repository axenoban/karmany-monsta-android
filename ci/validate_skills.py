#!/usr/bin/env python3
"""Validador sin dependencias para manifests de skills locales de Karmany."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
SKILLS = ROOT / ".agents" / "skills"
EXPECTED = {
    "godot-ui-ux",
    "game-visual-system",
    "godot-ui-implementation",
    "android-game-qa",
    "godot-gameplay",
}

def validate() -> list[str]:
    errors: list[str] = []
    names: set[str] = set()
    folders = {p.name for p in SKILLS.iterdir() if p.is_dir()} if SKILLS.is_dir() else set()
    if folders != EXPECTED:
        errors.append(f"Skills encontradas {sorted(folders)}; esperadas {sorted(EXPECTED)}")
    for folder in sorted(folders):
        manifest = SKILLS / folder / "SKILL.md"
        if not manifest.is_file():
            errors.append(f"{folder}: falta SKILL.md")
            continue
        content = manifest.read_text(encoding="utf-8")
        match = re.match(r"\A---\s*\n(.*?)\n---\s*\n", content, flags=re.S)
        if not match:
            errors.append(f"{folder}: YAML frontmatter ausente o incompleto")
            continue
        header = match.group(1)
        name = re.search(r"^name:\s*[\"']?([a-z0-9-]+)[\"']?\s*$", header, re.M)
        description = re.search(r"^description:\s*(.+)\s*$", header, re.M)
        if not name or name.group(1) != folder:
            errors.append(f"{folder}: name no coincide con el directorio")
        elif name.group(1) in names:
            errors.append(f"{folder}: name duplicado")
        else:
            names.add(name.group(1))
        if not description or len(description.group(1).strip().strip('\"\'')) < 30:
            errors.append(f"{folder}: description ausente o demasiado genérica")
        if not content[match.end():].strip():
            errors.append(f"{folder}: instrucciones vacías")
    return errors

if __name__ == "__main__":
    findings = validate()
    if findings:
        print("\n".join("ERROR: " + issue for issue in findings))
        sys.exit(1)
    print(f"OK: {len(EXPECTED)} skills con metadatos y contenido comprobados")
