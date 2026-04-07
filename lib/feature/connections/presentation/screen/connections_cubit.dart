import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/domain/future/delay.dart';
import 'package:rook_flutter_demo/core/domain/preferences/app_preferences.dart';
import 'package:rook_flutter_demo/feature/connections/domain/enum/health_kit_type.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connection.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connection_status.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connections_state.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/disconnection_status.dart';
import 'package:rook_flutter_demo/rook/repository/rook_api_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_apple_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_connect_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_samsung_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_steps_repository.dart';

class ConnectionsCubit extends Cubit<ConnectionsState> {
  final Logger _logger;
  final AppPreferences _preferences;
  final RookApiHealthRepository _apiHealthRepository;

  ConnectionsCubit({
    required Logger logger,
    required AppPreferences preferences,
    required RookApiHealthRepository apiHealthRepository,
  }) : _logger = logger,
       _preferences = preferences,
       _apiHealthRepository = apiHealthRepository,
       super(ConnectionsState()) {
    onConnectionsRefresh();
  }

  void onConnectionStatusDisplayed() {
    emit(state.copyWith(connectionStatus: UnknownConnectionStatus()));
  }

  void onDisconnectionStatusDisplayed() {
    emit(state.copyWith(disconnectionStatus: UnknownDisconnectionStatus()));
  }

  void onConnectionsRefresh({bool onlyHealthKits = false}) {
    if (!onlyHealthKits) {
      _loadApiConnections();
    }

    _loadHealthKitConnections();
  }

  Future<void> onConnectClick(Connection connection) async {
    if (connection is ConnectionApi) {
      _connectApi(connection).catchError((error) {
        emit(
          state.copyWith(
            connectionStatus: ConnectionError("Failed to connect ${connection.name}: $error"),
          ),
        );
      });
    }

    if (connection is ConnectionHealthKit) {
      emit(
        state.copyWith(
          // connectionNavigation: ConnectionNavigation(type: connection.type),
          connectionStatus: HealthKitConnectionRequest(connection.type),
        ),
      );
    }
  }

  Future<void> onDisconnectClick(Connection connection) async {
    if (connection is ConnectionApi) {
      _disconnectApi(connection).catchError((error) {
        emit(
          state.copyWith(
            disconnectionStatus: DisconnectionError(
              "Failed to disconnect ${connection.name}: $error",
            ),
          ),
        );
      });
    }

    if (connection is ConnectionHealthKit) {
      _disconnectHealthKit(connection).catchError((error) {
        emit(
          state.copyWith(
            disconnectionStatus: DisconnectionError(
              "Failed to disconnect ${connection.name}: $error",
            ),
          ),
        );
      });
    }
  }

  Future<void> _loadApiConnections({int? delaySeconds}) async {
    emit(state.copyWith(loadingApi: true, errorApi: false));

    if (delaySeconds != null) {
      await delay(seconds: delaySeconds);
    }

    try {
      final dataSources = await _apiHealthRepository.getAuthorizedDataSourcesV2();

      final connections = <String, ConnectionApi>{};

      for (final dataSource in dataSources) {
        if (invalidApiDataSources.contains(dataSource.name)) {
          continue;
        }

        connections[dataSource.name] = ConnectionApi(
          name: dataSource.name,
          connected: dataSource.authorized,
          iconUrl: dataSource.imageUrl,
        );
      }

      emit(state.copyWith(loadingApi: false, connectionsApi: connections.values.toList()));
    } catch (error) {
      _logger.e("Failed to load API connections: $error");
      emit(state.copyWith(errorApi: true, loadingApi: false));
    }
  }

  Future<void> _connectApi(ConnectionApi connection) async {
    emit(state.copyWith(loadingApi: true));

    final authorizer = await _apiHealthRepository.getDataSourceAuthorizer(
      connection.name,
      homePageUrl,
    );

    final connectionUrl = authorizer.authorizationUrl;

    if (connectionUrl != null) {
      emit(state.copyWith(loadingApi: false));

      await launchUrl(
        Uri.parse(connectionUrl),
        customTabsOptions: CustomTabsOptions(
          urlBarHidingEnabled: true,
          shareState: CustomTabsShareState.off,
          downloadButtonEnabled: false,
          bookmarksButtonEnabled: false,
        ),
      );
    } else {
      emit(state.copyWith(connectionStatus: AlreadyConnected(), loadingApi: false));

      // Data source is already connected, refresh to fetch latest changes.
      _loadApiConnections();
    }
  }

  Future<void> _disconnectApi(ConnectionApi connection) async {
    final disconnectionType = connection.disconnectionType;

    if (disconnectionType == null) {
      emit(state.copyWith(disconnectionStatus: DisconnectionNotSupported()));
      return;
    }

    emit(state.copyWith(loadingApi: true));

    await _apiHealthRepository.revokeDataSource(disconnectionType);

    emit(state.copyWith(disconnectionStatus: Disconnected()));

    _loadApiConnections(delaySeconds: 10);
  }

  Future<void> _loadHealthKitConnections() async {
    emit(state.copyWith(loadingHK: true, errorHK: false));

    final appleHealthAvailable = await RookAppleHealthRepository.isCompatibleWithCurrentPlatform();
    final healthConnectAvailable =
        await RookHealthConnectRepository.isCompatibleWithCurrentPlatform();
    final samsungHealthAvailable =
        await RookSamsungHealthRepository.isCompatibleWithCurrentPlatform();
    final androidStepsAvailable = await RookStepsRepository.isCompatibleWithCurrentPlatform();

    bool appleHealthEnabled = false;

    if (appleHealthAvailable) {
      try {
        appleHealthEnabled = await RookAppleHealthRepository.isBackgroundEnabled();
      } catch (error) {
        _logger.e("Failed to check Apple Health connections: $error");
        emit(state.copyWith(errorHK: true));
      }
    }

    bool healthConnectEnabled = false;

    if (healthConnectAvailable) {
      try {
        healthConnectEnabled = await RookHealthConnectRepository.isBackgroundEnabled();
      } catch (error) {
        _logger.e("Failed to check Health Connect connection: $error");
        emit(state.copyWith(errorHK: true));
      }
    }

    bool samsungHealthEnabled = false;

    if (samsungHealthAvailable) {
      try {
        samsungHealthEnabled = await RookSamsungHealthRepository.isBackgroundEnabled();
      } catch (error) {
        _logger.e("Failed to check Samsung Health connection: $error");
        emit(state.copyWith(errorHK: true));
      }
    }

    bool androidStepsEnabled = false;

    if (androidStepsAvailable) {
      try {
        androidStepsEnabled = await RookStepsRepository.isBackgroundEnabled();
      } catch (error) {
        _logger.e("Failed to check Android Steps connection: $error");
        emit(state.copyWith(errorHK: true));
      }
    }

    final connections = <String, ConnectionHealthKit>{};

    if (appleHealthAvailable) {
      connections["Apple Health"] = ConnectionHealthKit.appleHealth(connected: appleHealthEnabled);
    }

    if (healthConnectAvailable) {
      connections["Health Connect"] = ConnectionHealthKit.healthConnect(
        connected: healthConnectEnabled,
      );
    }

    if (samsungHealthAvailable) {
      connections["Samsung Health"] = ConnectionHealthKit.samsungHealth(
        connected: samsungHealthEnabled,
      );
    }

    if (androidStepsAvailable) {
      connections["Android Steps"] = ConnectionHealthKit.androidSteps(
        connected: androidStepsEnabled,
      );
    }

    emit(state.copyWith(loadingHK: false, connectionsHK: connections.values.toList()));
  }

  Future<void> _disconnectHealthKit(ConnectionHealthKit connection) async {
    switch (connection.type) {
      case HealthKitType.appleHealth:
        await RookAppleHealthRepository.disableBackground();
        await _preferences.toggleAppleHealth(false);
        break;
      case HealthKitType.healthConnect:
        await RookHealthConnectRepository.disableBackground();
        await _preferences.toggleHealthConnect(false);
        break;
      case HealthKitType.samsungHealth:
        await RookSamsungHealthRepository.disableBackground();
        await _preferences.toggleSamsungHealth(false);
        break;
      case HealthKitType.androidSteps:
        await RookStepsRepository.disableBackground();
        break;
    }

    _loadHealthKitConnections();
  }
}

final invalidApiDataSources = {
  "Health Connect",
  "Samsung Health",
  "Android",
  "Apple Health",
  // This data source requires additional set up, check our docs for more details
  "Dexcom",
  // This data source requires additional set up, check our docs for more details
  "Strava",
  // This data source requires additional set up, check our docs for more details
  "Whoop",
};

const homePageUrl = "https://main.d1kx6n00xlijg7.amplifyapp.com/open-app";
