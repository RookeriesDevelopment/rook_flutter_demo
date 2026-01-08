import 'package:app_settings/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rook_flutter_demo/feature/androidsteps/domain/enum/android_steps_connection_status.dart';
import 'package:rook_flutter_demo/feature/androidsteps/domain/model/android_steps_state.dart';
import 'package:rook_flutter_demo/rook/repository/rook_steps_repository.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

class AndroidStepsCubit extends Cubit<AndroidStepsState> {
  AndroidStepsCubit() : super(AndroidStepsState());

  void onConnectionStatusDisplayed() {
    emit(state.copyWith(connectionStatus: AndroidStepsConnectionStatus.unknown));
  }

  void onResume() {
    _initAndroidSteps();
  }

  void onOpenSettingsClick() {
    AppSettings.openAppSettings(type: AppSettingsType.settings);
  }

  void onPermissionsChanged({
    required bool permissionsGranted,
    required bool shouldRequestPermissions,
  }) {
    emit(
      state.copyWith(
        permissionsGranted: permissionsGranted,
        shouldRequestPermissions: shouldRequestPermissions,
        showGrantPermissionsButton: shouldRequestPermissions ? !permissionsGranted : false,
        showOpenSettingsButton: !permissionsGranted && !shouldRequestPermissions,
      ),
    );

    if (!permissionsGranted) {
      emit(state.copyWith(connectionStatus: AndroidStepsConnectionStatus.missingPermissions));
    }
  }

  void onGrantPermissionsClick() {
    HCRookHealthPermissionsManager.requestAndroidPermissions().then((result) {
      if (result == RequestPermissionsStatus.alreadyGranted) {
        emit(state.copyWith(permissionsGranted: true, showGrantPermissionsButton: false));
      }
    });
  }

  void onConnectClick() {
    AndroidStepsManager.enableBackgroundAndroidSteps().then((_) {
      emit(state.copyWith(connectionStatus: AndroidStepsConnectionStatus.connected));
    });
  }

  Future<void> _initAndroidSteps() async {
    final permissionsGranted = await RookStepsRepository.checkAndroidPermissions();

    emit(
      state.copyWith(
        permissionsGranted: permissionsGranted,
        showGrantPermissionsButton: !permissionsGranted,
      ),
    );
  }
}
