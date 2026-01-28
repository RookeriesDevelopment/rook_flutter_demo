import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rook_flutter_demo/core/domain/extension/future_extensions.dart';
import 'package:rook_flutter_demo/core/domain/preferences/app_preferences.dart';
import 'package:rook_flutter_demo/feature/healthconnect/domain/enum/health_connect_connection_status.dart';
import 'package:rook_flutter_demo/feature/healthconnect/domain/enum/health_connect_status.dart';
import 'package:rook_flutter_demo/feature/healthconnect/domain/model/health_connect_state.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_connect_repository.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthConnectCubit extends Cubit<HealthConnectState> {
  final AppPreferences _preferences;

  HealthConnectCubit({required AppPreferences preferences})
    : _preferences = preferences,
      super(HealthConnectState());

  void onConnectionStatusDisplayed() {
    emit(state.copyWith(connectionStatus: HealthConnectConnectionStatus.unknown));
  }

  void onResume() {
    _initHealthConnect();
  }

  void onDownloadClick() {
    launchUrl(
      Uri.parse("https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata"),
    );
  }

  void onOpenSettingsClick() {
    RookHealthConnectRepository.openHealthConnectSettings();
  }

  void onPermissionsChanged({
    required bool dataTypesPermissions,
    required bool backgroundPermissions,
  }) {
    final permissionsGranted = dataTypesPermissions && backgroundPermissions;
    HealthConnectConnectionStatus? connectionStatus;

    if (!backgroundPermissions && !dataTypesPermissions) {
      connectionStatus = HealthConnectConnectionStatus.missingPermissions;
    } else if (!backgroundPermissions) {
      connectionStatus = HealthConnectConnectionStatus.missingBackgroundPermissions;
    } else if (!dataTypesPermissions) {
      connectionStatus = HealthConnectConnectionStatus.missingDataTypesPermissions;
    } else {
      connectionStatus = null;
    }

    emit(
      state.copyWith(
        dataTypesGranted: dataTypesPermissions,
        backgroundGranted: backgroundPermissions,
        showAllowAccessButton: !permissionsGranted,
        showOpenSettingsButton: !permissionsGranted,
        connectionStatus: connectionStatus,
      ),
    );
  }

  void onAllowAccessClick() {
    _requestPermissions();
  }

  void onConnectClick() {
    _enableHealthConnect();
  }

  Future<void> _initHealthConnect() async {
    emit(state.copyWith(status: HealthConnectStatus.loading));

    final availability = await RookHealthConnectRepository.checkHealthConnectAvailability();
    final backgroundStatus = await RookHealthConnectRepository.checkBackgroundReadStatus()
        .getOrDefault(HCBackgroundReadStatus.unavailable);

    final healthConnectStatus = HealthConnectStatus.fromAvailabilityAndBackgroundStatus(
      availability: availability,
      backgroundStatus: backgroundStatus,
    );

    if (healthConnectStatus == HealthConnectStatus.ready) {
      final allPermissions = await RookHealthConnectRepository.checkHealthConnectPermissions()
          .getOrDefault(false);
      final partialPermissions =
          await RookHealthConnectRepository.checkHealthConnectPermissionsPartially().getOrDefault(
            false,
          );

      final dataTypesGranted = allPermissions || partialPermissions;
      final backgroundGranted = backgroundStatus == HCBackgroundReadStatus.permissionGranted;
      final permissionsGranted = dataTypesGranted && backgroundGranted;

      emit(
        state.copyWith(
          status: healthConnectStatus,
          dataTypesGranted: dataTypesGranted,
          backgroundGranted: backgroundGranted,
          showAllowAccessButton: !permissionsGranted,
        ),
      );
    } else {
      emit(state.copyWith(status: healthConnectStatus));
    }
  }

  Future<void> _requestPermissions() async {
    final result = await RookHealthConnectRepository.requestHealthConnectPermissions().getOrDefault(
      RequestPermissionsStatus.requestSent,
    );

    if (result == RequestPermissionsStatus.alreadyGranted) {
      emit(
        state.copyWith(
          dataTypesGranted: true,
          backgroundGranted: true,
          showAllowAccessButton: false,
          showOpenSettingsButton: false,
        ),
      );
    } else {
      emit(state.copyWith(showOpenSettingsButton: true));
    }
  }

  Future<void> _enableHealthConnect() async {
    await RookHealthConnectRepository.enableBackground(kDebugMode);
    await _preferences.toggleHealthConnect(true);

    emit(state.copyWith(connectionStatus: HealthConnectConnectionStatus.connected));
  }
}
