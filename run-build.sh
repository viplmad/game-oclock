mkdocs serve
dart format .
flutter clean
flutter build apk --debug
flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0 --target lib/main.dart --no-dds
flutter pub outdated
flutter pub upgrade --major-versions
flutter gen-l10n
flutter devices