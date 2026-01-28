import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/healthconnect/domain/enum/health_connect_connection_status.dart';
import 'package:rook_flutter_demo/feature/healthconnect/domain/enum/health_connect_status.dart';

final class HealthConnectState extends Equatable {
  final bool dataTypesGranted;
  final bool backgroundGranted;
  final bool showAllowAccessButton;
  final bool showOpenSettingsButton;

  final HealthConnectStatus status;
  final HealthConnectConnectionStatus connectionStatus;

  const HealthConnectState({
    this.dataTypesGranted = false,
    this.backgroundGranted = false,
    this.showAllowAccessButton = true,
    this.showOpenSettingsButton = false,
    this.status = HealthConnectStatus.loading,
    this.connectionStatus = HealthConnectConnectionStatus.unknown,
  });

  HealthConnectState copyWith({
    bool? dataTypesGranted,
    bool? backgroundGranted,
    bool? showAllowAccessButton,
    bool? showOpenSettingsButton,
    HealthConnectStatus? status,
    HealthConnectConnectionStatus? connectionStatus,
  }) {
    return HealthConnectState(
      dataTypesGranted: dataTypesGranted ?? this.dataTypesGranted,
      backgroundGranted: backgroundGranted ?? this.backgroundGranted,
      showAllowAccessButton: showAllowAccessButton ?? this.showAllowAccessButton,
      showOpenSettingsButton: showOpenSettingsButton ?? this.showOpenSettingsButton,
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [
    dataTypesGranted,
    backgroundGranted,
    showAllowAccessButton,
    showOpenSettingsButton,
    status,
    connectionStatus,
  ];
}
