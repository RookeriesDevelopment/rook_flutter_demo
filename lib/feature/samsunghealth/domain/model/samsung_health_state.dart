import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/enum/samsung_health_connection_status.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/enum/samsung_health_status.dart';

final class SamsungHealthState extends Equatable {
  final bool permissionsGranted;
  final bool showAllowAccessButton;

  final SamsungHealthStatus status;
  final SamsungHealthConnectionStatus connectionStatus;

  const SamsungHealthState({
    this.permissionsGranted = false,
    this.showAllowAccessButton = true,
    this.status = SamsungHealthStatus.loading,
    this.connectionStatus = SamsungHealthConnectionStatus.unknown,
  });

  SamsungHealthState copyWith({
    bool? permissionsGranted,
    bool? showAllowAccessButton,
    SamsungHealthStatus? status,
    SamsungHealthConnectionStatus? connectionStatus,
  }) {
    return SamsungHealthState(
      permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      showAllowAccessButton: showAllowAccessButton ?? this.showAllowAccessButton,
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [
    permissionsGranted,
    showAllowAccessButton,
    status,
    connectionStatus,
  ];
}
