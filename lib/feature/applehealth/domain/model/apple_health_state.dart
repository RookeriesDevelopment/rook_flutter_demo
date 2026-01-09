import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/applehealth/domain/enum/apple_health_connection_status.dart';

final class AppleHealthState extends Equatable {
  final bool hasAskedForPermissions;

  final AppleHealthConnectionStatus connectionStatus;

  const AppleHealthState({
    this.hasAskedForPermissions = false,
    this.connectionStatus = AppleHealthConnectionStatus.unknown,
  });

  AppleHealthState copyWith({
    bool? hasAskedForPermissions,
    AppleHealthConnectionStatus? connectionStatus,
  }) {
    return AppleHealthState(
      hasAskedForPermissions: hasAskedForPermissions ?? this.hasAskedForPermissions,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [
    hasAskedForPermissions,
    connectionStatus,
  ];
}
