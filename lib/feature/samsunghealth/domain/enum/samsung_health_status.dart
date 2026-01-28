import 'package:rook_sdk_samsung_health/rook_sdk_samsung_health.dart';

enum SamsungHealthStatus {
  loading,
  error,
  notInstalled,
  outdated,
  disabled,
  notReady,
  ready;

  static SamsungHealthStatus fromAvailability({required SamsungHealthAvailability availability}) {
    return switch (availability) {
      SamsungHealthAvailability.notInstalled => notInstalled,
      SamsungHealthAvailability.outdated => outdated,
      SamsungHealthAvailability.disabled => disabled,
      SamsungHealthAvailability.notReady => notReady,
      SamsungHealthAvailability.installed => ready,
    };
  }
}
