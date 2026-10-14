"""Configure export metadata and SDK without storing production credentials."""
import base64
import json
import os
from pathlib import Path

root = Path(__file__).resolve().parents[1]
build = int(os.environ.get("GITHUB_RUN_NUMBER", "1"))
commit = os.environ.get("BUILD_COMMIT", "local")
info = json.loads((root / "data/build_info.json").read_text())
info.update({"commit": commit, "build": build})
(root / "data/build_info.json").write_text(json.dumps(info))
preset = root / "export_presets.cfg"
text = preset.read_text().replace("version/code=1\n", f"version/code={1000 + build}\n")
preset.write_text(text)
(root / "ci/preview.keystore").write_bytes(base64.b64decode((root / "ci/preview.keystore.b64").read_text()))
config_dir = Path.home() / ".config/godot"
config_dir.mkdir(parents=True, exist_ok=True)
config_path = config_dir / "editor_settings-4.7.tres"
config_path.write_text('[gd_resource type="EditorSettings" format=3]\n\n[resource]\n'
    + 'export/android/android_sdk_path = ' + json.dumps(os.environ["ANDROID_HOME"]) + '\n'
    + 'export/android/java_sdk_path = ' + json.dumps(os.environ["JAVA_HOME"]) + '\n')
(root / "build").mkdir(exist_ok=True)
print(f"Prepared Android preview build {build}, commit {commit}")
