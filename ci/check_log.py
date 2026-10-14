"""Fail checks on Godot errors even when its process exits successfully."""
from pathlib import Path
import re
import sys

lines = Path(sys.argv[1]).read_text(errors="replace").splitlines()
errors = [line for line in lines if re.search(r"SCRIPT ERROR:|Parse Error:|Failed to load script|ERROR:", line)]
if errors:
    print("Godot errors detected:\n" + "\n".join(errors))
    raise SystemExit(1)
print("Godot log checked: no errors")
