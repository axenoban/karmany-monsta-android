import importlib.util
from pathlib import Path
import tempfile
import unittest
import zipfile

spec = importlib.util.spec_from_file_location('apk_audit', Path(__file__).parents[1] / 'ci/check_apk_privacy.py')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

class PrivacyChecks(unittest.TestCase):
    def make_apk(self, directory, manifest=b'', extra=None):
        path = Path(directory) / 'test.apk'
        with zipfile.ZipFile(path, 'w') as archive:
            archive.writestr('AndroidManifest.xml', manifest)
            archive.writestr('assets/scenes/main.tscn', 'scene')
            if extra:
                archive.writestr(extra, 'test code')
        return path

    def test_game_without_capture_artifacts(self):
        with tempfile.TemporaryDirectory() as directory:
            self.assertEqual(module.audit(self.make_apk(directory, b'android.permission.VIBRATE')), ['android.permission.VIBRATE'])

    def test_reject_packaged_capture_test(self):
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(ValueError):
                module.audit(self.make_apk(directory, extra='assets/tests/render_smoke.gd'))

    def test_reject_capture_permission_in_binary_string_pool(self):
        for encoding in ['utf-8', 'utf-16-le']:
            with self.subTest(encoding=encoding), tempfile.TemporaryDirectory() as directory:
                with self.assertRaises(ValueError):
                    module.audit(self.make_apk(directory, 'android.permission.DETECT_SCREEN_CAPTURE'.encode(encoding)))
