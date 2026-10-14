"""Reject test/capture artifacts and screen-capture permissions in shipped APKs."""
import re
import sys
import zipfile
from pathlib import Path

FORBIDDEN_PERMISSIONS = {
    'android.permission.DETECT_SCREEN_CAPTURE',
    'android.permission.DETECT_SCREEN_RECORDING',
    'android.permission.CAPTURE_VIDEO_OUTPUT',
    'android.permission.CAPTURE_SECURE_VIDEO_OUTPUT',
    'android.permission.MANAGE_MEDIA_PROJECTION',
}

def audit(apk_path):
    with zipfile.ZipFile(apk_path) as apk:
        names = apk.namelist()
        forbidden = [name for name in names if name.startswith(('assets/tests/', 'assets/ci/'))
                     or any(part in name.lower() for part in ('render_smoke', 'screenshots/', 'ui-review.zip'))]
        if forbidden:
            raise ValueError('Non-game capture/test artifacts packaged: ' + ', '.join(forbidden))
        manifest = apk.read('AndroidManifest.xml')
        permissions = set()
        # Android binary XML string pools use UTF-8 or UTF-16LE.
        for encoding in ('utf-8', 'utf-16-le'):
            permissions.update(re.findall(r'android\.permission\.[A-Z_]+', manifest.decode(encoding, errors='ignore')))
        rejected = permissions & FORBIDDEN_PERMISSIONS
        if rejected:
            raise ValueError('Screen capture permission packaged: ' + ', '.join(sorted(rejected)))
        return sorted(permissions)

if __name__ == '__main__':
    permissions = audit(Path(sys.argv[1]))
    print('APK PRIVACY CHECK: no test/capture artifacts or screen-capture permissions; declared:', ', '.join(permissions))
