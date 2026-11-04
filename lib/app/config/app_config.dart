import 'package:flutter/foundation.dart';

/// Build-time configuration for the Quickli Vendor app.
///
/// ## How values are supplied
///
/// Every environment is inlined below and selected with `ENV`, so all of these
/// work on a fresh checkout with no flags and no env file:
///
/// ```
/// flutter run                              # debug -> dev
/// flutter run --dart-define=ENV=uat        # debug -> uat
/// flutter build appbundle --release        # release -> prod, automatically
/// ```
///
/// A build can override any single key, which is how CI injects values without
/// editing this file:
///
/// 1. `--dart-define-from-file=.env.prod`   — read at build time, not bundled.
/// 2. `--dart-define=KEY=value`             — for ad-hoc builds.
///
/// An explicit value always wins over the inlined default.
class AppConfig {
  const AppConfig._();

  /// Set with `--dart-define=ENV=...`. Empty means "decide automatically".
  static const String _envOverride = String.fromEnvironment('ENV');

  /// Which environment this build targets: `dev`, `uat` or `prod`.
  ///
  /// An explicit `ENV` always wins. Otherwise the build mode decides: release
  /// means prod, debug/profile means dev.
  static const String env = _envOverride == ''
      ? (kReleaseMode ? 'prod' : 'dev')
      : _envOverride;

  /// Normalised environment name; an unrecognised [env] becomes `dev`.
  static const String envName = env == 'prod'
      ? 'prod'
      : env == 'uat'
          ? 'uat'
          : 'dev';

  // ── Inlined per-environment defaults ─────────────────────────────────────
  // These are public identifiers / endpoints, not secrets.
  // The trade-off: rotating a URL needs a code change + release, but a plain
  // `flutter run` and a plain `flutter build appbundle --release` both work
  // with zero arguments on a fresh checkout.

  static const Map<String, String> _dev = {
    'BASE_URL':   'https://api-dev.quickliapp.com/v1',
    'SOCKET_URL': 'https://api-dev.quickliapp.com',
  };

  static const Map<String, String> _uat = {
    'BASE_URL':   'https://staging-quicklyapp-com.onrender.com/v1',
    'SOCKET_URL': 'https://staging-quicklyapp-com.onrender.com',
  };

  static const Map<String, String> _prod = {
    'BASE_URL':   'https://api.quickliapp.com/v1',
    'SOCKET_URL': 'https://api.quickliapp.com',
  };

  static Map<String, String> get _profile =>
      envName == 'prod' ? _prod : (envName == 'uat' ? _uat : _dev);

  /// Resolves a key: an explicit build-time define wins, else the inlined
  /// profile value.
  static String _define(String key) {
    final override = String.fromEnvironment(key);
    if (override.isNotEmpty) return override;
    return _profile[key] ?? '';
  }

  // ── API / realtime endpoints ──────────────────────────────────────────────
  static String get baseUrl   => _define('BASE_URL');
  static String get socketUrl => _define('SOCKET_URL');

  // ── Required keys ─────────────────────────────────────────────────────────
  static const List<String> requiredKeys = ['BASE_URL', 'SOCKET_URL'];

  static Map<String, String> get all => {
    'ENV':        env,
    'BASE_URL':   baseUrl,
    'SOCKET_URL': socketUrl,
  };

  static List<String> get missingKeys =>
      requiredKeys.where((k) => (all[k] ?? '').isEmpty).toList();

  static List<String> get problems {
    final issues = <String>[];
    if (missingKeys.isNotEmpty) {
      issues.add('Missing build configuration: ${missingKeys.join(', ')}');
    }
    return issues;
  }

  static List<String> get warnings {
    final notes = <String>[];
    if (kReleaseMode && envName != 'prod') {
      notes.add(
        'This release build targets "$envName" ($baseUrl), not production.',
      );
    }
    return notes;
  }

  static const String missingKeysHelp =
      'Values are inlined in lib/app/config/app_config.dart.\n'
      'No arguments are needed:\n'
      '  flutter run                        # dev\n'
      '  flutter build appbundle --release  # prod\n'
      '\n'
      'To target another environment:\n'
      '  flutter run --dart-define=ENV=uat\n'
      '  flutter run --dart-define-from-file=.env.uat';

  static void validate() {
    final issues = problems;
    if (issues.isEmpty) return;
    throw StateError('${issues.join('\n')}\n$missingKeysHelp');
  }
}
