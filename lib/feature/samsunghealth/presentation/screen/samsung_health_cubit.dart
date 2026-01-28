import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rook_flutter_demo/core/domain/extension/future_extensions.dart';
import 'package:rook_flutter_demo/core/domain/preferences/app_preferences.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/enum/samsung_health_connection_status.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/enum/samsung_health_status.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/model/samsung_health_state.dart';
import 'package:rook_flutter_demo/rook/repository/rook_samsung_health_repository.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_samsung_health/rook_sdk_samsung_health.dart';
import 'package:url_launcher/url_launcher.dart';

class SamsungHealthCubit extends Cubit<SamsungHealthState> {
  final AppPreferences _preferences;

  SamsungHealthCubit({required AppPreferences preferences})
    : _preferences = preferences,
      super(SamsungHealthState());

  void onConnectionStatusDisplayed() {
    emit(state.copyWith(connectionStatus: SamsungHealthConnectionStatus.unknown));
  }

  void onResume() {
    _initSamsungHealth();
  }

  void onDownloadClick() {
    launchUrl(
      Uri.parse("https://play.google.com/store/apps/details?id=com.sec.android.app.shealth"),
    );
  }

  void onOpenSettingsClick() {
    AppSettings.openAppSettings(type: AppSettingsType.generalSettings);
  }

  void onPermissionsChanged({required bool allPermissions, required bool partialPermissions}) {
    final permissionsGranted = allPermissions || partialPermissions;
    SamsungHealthConnectionStatus? connectionStatus;

    if (!permissionsGranted) {
      connectionStatus = SamsungHealthConnectionStatus.missingPermissions;
    }

    emit(
      state.copyWith(
        permissionsGranted: permissionsGranted,
        showAllowAccessButton: !permissionsGranted,
        connectionStatus: connectionStatus,
      ),
    );
  }

  void onAllowAccessClick() {
    _requestPermissions();
  }

  void onConnectClick() {
    _enableSamsungHealth();
  }

  Future<void> _initSamsungHealth() async {
    emit(state.copyWith(status: SamsungHealthStatus.loading));

    final availability = await RookSamsungHealthRepository.checkSamsungHealthAvailability();
    final samsungHealthStatus = SamsungHealthStatus.fromAvailability(availability: availability);

    if (samsungHealthStatus == SamsungHealthStatus.ready) {
      final allPermissions = await RookSamsungHealthRepository.checkSamsungHealthPermissions(
        _samsungPermissions,
      ).getOrDefault(false);
      final partialPermissions =
          await RookSamsungHealthRepository.checkSamsungHealthPermissionsPartially(
            _samsungPermissions,
          ).getOrDefault(false);

      emit(
        state.copyWith(
          status: samsungHealthStatus,
          permissionsGranted: allPermissions || partialPermissions,
          showAllowAccessButton: !allPermissions,
        ),
      );
    } else {
      emit(state.copyWith(status: samsungHealthStatus));
    }
  }

  Future<void> _requestPermissions() async {
    final result = await RookSamsungHealthRepository.requestSamsungHealthPermissions(
      _samsungPermissions,
    ).getOrDefault(RequestPermissionsStatus.requestSent);

    if (result == RequestPermissionsStatus.alreadyGranted) {
      emit(state.copyWith(permissionsGranted: true, showAllowAccessButton: false));
    }
  }

  Future<void> _enableSamsungHealth() async {
    await RookSamsungHealthRepository.enableBackground(kDebugMode);
    await _preferences.toggleSamsungHealth(true);

    emit(state.copyWith(connectionStatus: SamsungHealthConnectionStatus.connected));
  }
}

const List<SamsungHealthPermission> _samsungPermissions = [
  SamsungHealthPermission.activitySummary,
  SamsungHealthPermission.bloodGlucose,
  SamsungHealthPermission.bloodOxygen,
  SamsungHealthPermission.bloodPressure,
  SamsungHealthPermission.bodyComposition,
  SamsungHealthPermission.exercise,
  SamsungHealthPermission.exerciseLocation,
  SamsungHealthPermission.floorsClimbed,
  SamsungHealthPermission.heartRate,
  SamsungHealthPermission.nutrition,
  SamsungHealthPermission.sleep,
  SamsungHealthPermission.steps,
  SamsungHealthPermission.waterIntake,
];
