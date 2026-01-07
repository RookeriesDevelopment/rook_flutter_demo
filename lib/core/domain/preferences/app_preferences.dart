abstract interface class AppPreferences {
  Future<void> toggleAppleHealth(bool enabled);
  Future<bool> isAppleHealthEnabled();
  Future<void> toggleHealthConnect(bool enabled);
  Future<bool> isHealthConnectEnabled();
  Future<void> toggleSamsungHealth(bool enabled);
  Future<bool> isSamsungHealthEnabled();
  Future<void> clear();
}
