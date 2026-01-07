import 'package:rook_flutter_demo/core/domain/preferences/app_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class DefaultAppPreferences implements AppPreferences {
  final SharedPreferencesAsync _sharedPreferences = SharedPreferencesAsync();

  @override
  Future<void> toggleAppleHealth(bool enabled) {
    return _sharedPreferences.setBool(appleHealthKey, enabled);
  }

  @override
  Future<bool> isAppleHealthEnabled() async {
    return (await _sharedPreferences.getBool(appleHealthKey)) ?? false;
  }

  @override
  Future<void> toggleHealthConnect(bool enabled) {
    return _sharedPreferences.setBool(healthConnectKey, enabled);
  }

  @override
  Future<bool> isHealthConnectEnabled() async {
    return (await _sharedPreferences.getBool(healthConnectKey)) ?? false;
  }

  @override
  Future<void> toggleSamsungHealth(bool enabled) {
    return _sharedPreferences.setBool(samsungHealthKey, enabled);
  }

  @override
  Future<bool> isSamsungHealthEnabled() async {
    return (await _sharedPreferences.getBool(samsungHealthKey)) ?? false;
  }

  @override
  Future<void> clear() {
    return _sharedPreferences.clear(
      allowList: {appleHealthKey, healthConnectKey, samsungHealthKey},
    );
  }
}

const appleHealthKey = "apple_health";
const healthConnectKey = "health_connect";
const samsungHealthKey = "samsung_health";
