"""Install the exact Godot release, checking official SHA-512 sums."""
import hashlib
import os
from pathlib import Path
import urllib.request
import zipfile

VERSION = "4.7.2"
BASE = f"https://github.com/godotengine/godot-builds/releases/download/{VERSION}-stable"
destination = Path(os.environ.get("GODOT_INSTALL_DIR", "/tmp/karmany-godot"))
destination.mkdir(parents=True, exist_ok=True)
sums = urllib.request.urlopen(f"{BASE}/SHA512-SUMS.txt", timeout=60).read().decode()
checksums = {line.split()[-1].lstrip("*"): line.split()[0] for line in sums.splitlines() if line.strip()}

def download(name):
    archive = destination / name
    if not archive.exists():
        with urllib.request.urlopen(f"{BASE}/{name}", timeout=180) as source, archive.open("wb") as target:
            while chunk := source.read(1024 * 1024):
                target.write(chunk)
    digest = hashlib.sha512()
    with archive.open("rb") as source:
        while chunk := source.read(1024 * 1024):
            digest.update(chunk)
    if digest.hexdigest() != checksums[name]:
        archive.unlink()
        raise RuntimeError(f"Checksum mismatch: {name}")
    return archive

engine_name = f"Godot_v{VERSION}-stable_linux.x86_64"
with zipfile.ZipFile(download(engine_name + ".zip")) as archive:
    archive.extract(engine_name, destination)
engine = destination / engine_name
engine.chmod(0o755)
templates_dir = Path.home() / ".local/share/godot/export_templates" / f"{VERSION}.stable"
templates_dir.mkdir(parents=True, exist_ok=True)
with zipfile.ZipFile(download(f"Godot_v{VERSION}-stable_export_templates.tpz")) as archive:
    for name in ("android_debug.apk", "android_release.apk"):
        with archive.open("templates/" + name) as source, (templates_dir / name).open("wb") as target:
            while chunk := source.read(1024 * 1024):
                target.write(chunk)
with open(os.environ["GITHUB_PATH"], "a") as handle:
    handle.write(str(destination) + "\n")
(destination / "godot").symlink_to(engine.name) if not (destination / "godot").exists() else None
print(f"Godot {VERSION} and Android templates installed and verified")
