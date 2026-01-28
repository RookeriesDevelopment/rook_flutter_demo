import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

enum HealthConnectStatus {
  loading,
  notSupported,
  notInstalled,
  backgroundNotSupported,
  ready;

  static HealthConnectStatus fromAvailabilityAndBackgroundStatus({
    required HCAvailabilityStatus availability,
    required HCBackgroundReadStatus backgroundStatus,
  }) {
    if (availability == HCAvailabilityStatus.notSupported) {
      return notSupported;
    }

    if (availability == HCAvailabilityStatus.notInstalled) {
      return notInstalled;
    }

    // Installed but background read is not supported
    if (backgroundStatus == HCBackgroundReadStatus.unavailable) {
      return backgroundNotSupported;
    }

    // Installed and background read is supported but could not be granted
    return ready;
  }
}
