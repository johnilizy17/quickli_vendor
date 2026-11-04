import 'package:get_storage/get_storage.dart';

class MainStorage {
  static final _box = GetStorage();

  static bool get getIsOnboarded => _box.read<bool>('onboarded') ?? false;
  static void saveOnboardingCompleted(bool val) => _box.write('onboarded', val);

  static String? get accessToken => _box.read<String>('vendor_access_token');
  static String? get refreshToken => _box.read<String>('vendor_refresh_token');
}
