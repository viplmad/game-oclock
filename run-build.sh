mkdocs serve
dart format .
flutter clean
flutter build apk --debug
flutter run -d web-server --web-port 4200 --web-hostname 0.0.0.0 --target lib/main.dart --no-dds
flutter pub outdated
flutter pub upgrade --major-versions
flutter gen-l10n
flutter devices
"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"  --disable-web-security --user-data-dir="C:\tmpChromeSession"