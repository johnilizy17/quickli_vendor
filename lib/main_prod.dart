import 'package:quickli_vendor/main.dart' as app;

/// Production entry point.
///
/// flutter build appbundle --release -t lib/main_prod.dart
Future<void> main() async {
  await app.bootstrap();
}
