import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/androidsteps/domain/enum/android_steps_connection_status.dart';

final class AndroidStepsState extends Equatable {
  final bool permissionsGranted;
  final bool shouldRequestPermissions;
  final bool showGrantPermissionsButton;
  final bool showOpenSettingsButton;

  final AndroidStepsConnectionStatus connectionStatus;

  const AndroidStepsState({
    this.permissionsGranted = false,
    this.shouldRequestPermissions = false,
    this.showGrantPermissionsButton = false,
    this.showOpenSettingsButton = false,
    this.connectionStatus = AndroidStepsConnectionStatus.unknown,
  });

  AndroidStepsState copyWith({
    bool? permissionsGranted,
    bool? shouldRequestPermissions,
    bool? showGrantPermissionsButton,
    bool? showOpenSettingsButton,
    AndroidStepsConnectionStatus? connectionStatus,
  }) {
    return AndroidStepsState(
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      shouldRequestPermissions: shouldRequestPermissions ?? this.shouldRequestPermissions,
      showGrantPermissionsButton: showGrantPermissionsButton ?? this.showGrantPermissionsButton,
      showOpenSettingsButton: showOpenSettingsButton ?? this.showOpenSettingsButton,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [
    permissionsGranted,
    shouldRequestPermissions,
    showGrantPermissionsButton,
    showOpenSettingsButton,
    connectionStatus,
  ];
}
