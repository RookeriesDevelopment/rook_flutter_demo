import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connection.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connection_status.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/disconnection_status.dart';

final class ConnectionsState extends Equatable {
  final bool loadingHK;
  final List<ConnectionHealthKit> connectionsHK;
  final bool errorHK;

  final bool loadingApi;
  final List<ConnectionApi> connectionsApi;
  final bool errorApi;

  final ConnectionStatus connectionStatus;
  final DisconnectionStatus disconnectionStatus;

  const ConnectionsState({
    this.loadingHK = false,
    this.connectionsHK = const [],
    this.errorHK = false,
    this.loadingApi = false,
    this.connectionsApi = const [],
    this.errorApi = false,
    this.connectionStatus = const UnknownConnectionStatus(),
    this.disconnectionStatus = const UnknownDisconnectionStatus(),
  });

  ConnectionsState copyWith({
    bool? loadingHK,
    List<ConnectionHealthKit>? connectionsHK,
    bool? errorHK,
    bool? loadingApi,
    List<ConnectionApi>? connectionsApi,
    bool? errorApi,
    ConnectionStatus? connectionStatus,
    DisconnectionStatus? disconnectionStatus,
  }) {
    return ConnectionsState(
      loadingHK: loadingHK ?? this.loadingHK,
      connectionsHK: connectionsHK ?? this.connectionsHK,
      errorHK: errorHK ?? this.errorHK,
      loadingApi: loadingApi ?? this.loadingApi,
      connectionsApi: connectionsApi ?? this.connectionsApi,
      errorApi: errorApi ?? this.errorApi,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      disconnectionStatus: disconnectionStatus ?? this.disconnectionStatus,
    );
  }

  @override
  List<Object?> get props => [
    loadingHK,
    connectionsHK,
    errorHK,
    loadingApi,
    connectionsApi,
    errorApi,
    connectionStatus,
    disconnectionStatus,
  ];
}
