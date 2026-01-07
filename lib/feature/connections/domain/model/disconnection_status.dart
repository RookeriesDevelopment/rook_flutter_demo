import 'package:equatable/equatable.dart';

sealed class DisconnectionStatus extends Equatable {
  const DisconnectionStatus();
}

final class UnknownDisconnectionStatus extends DisconnectionStatus {
  const UnknownDisconnectionStatus();

  @override
  List<Object?> get props => [];
}

final class Disconnected extends DisconnectionStatus {
  @override
  List<Object?> get props => [];
}

final class DisconnectionNotSupported extends DisconnectionStatus {
  @override
  List<Object?> get props => [];
}

final class DisconnectionError extends DisconnectionStatus {
  final String message;

  const DisconnectionError(this.message) : super();

  @override
  List<Object?> get props => [message];
}
