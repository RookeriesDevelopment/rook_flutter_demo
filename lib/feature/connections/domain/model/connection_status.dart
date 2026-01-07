import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/connections/domain/enum/health_kit_type.dart';

sealed class ConnectionStatus extends Equatable {
  const ConnectionStatus();
}

final class UnknownConnectionStatus extends ConnectionStatus {
  const UnknownConnectionStatus();

  @override
  List<Object?> get props => [];
}

final class AlreadyConnected extends ConnectionStatus {
  const AlreadyConnected();

  @override
  List<Object?> get props => [];
}

final class HealthKitConnectionRequest extends ConnectionStatus {
  final HealthKitType type;

  const HealthKitConnectionRequest(this.type);

  @override
  List<Object?> get props => [];
}

final class ConnectionError extends ConnectionStatus {
  final String message;

  const ConnectionError(this.message) : super();

  @override
  List<Object?> get props => [message];
}
