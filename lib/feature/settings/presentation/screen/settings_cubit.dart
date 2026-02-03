import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/domain/preferences/app_preferences.dart';
import 'package:rook_flutter_demo/core/domain/repository/auth_repository.dart';
import 'package:rook_flutter_demo/feature/settings/domain/enum/logout_status.dart';
import 'package:rook_flutter_demo/feature/settings/domain/model/settings_state.dart';
import 'package:rook_flutter_demo/rook/repository/rook_api_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_apple_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_connect_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_samsung_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_steps_repository.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final Logger _logger;
  final AppPreferences _preferences;
  final AuthRepository _authRepository;

  SettingsCubit({
    required Logger logger,
    required AppPreferences preferences,
    required AuthRepository authRepository,
  }) : _logger = logger,
       _preferences = preferences,
       _authRepository = authRepository,
       super(SettingsState());

  void onLogOutClick() {
    _logOut().catchError((error) {
      _logger.e("Failed to logout", error: error);
      emit(state.copyWith(loggingOut: false, logoutStatus: LogoutStatus.error));
    });
  }

  Future<void> _logOut() async {
    emit(state.copyWith(loggingOut: true));

    // Logout from api data sources
    //
    // You should call revoke only on data sources that are actually connected
    for (final dataSource in disconnectableApiDataSources) {
      await RookApiHealthRepository.revokeDataSource(dataSource);
    }

    // Logout from health kits
    //
    // Calling RookHealthConnectRepository.disableBackground(), RookStepsRepository.disableBackground(),
    // RookSamsungHealthRepository.disableBackground() and RookAppleHealthRepository.disableBackground()
    // is enough to stop sending data (assuming you don't perform any manual sync).

    if (Platform.isAndroid) {
      // Disable background sync for Health Connect
      await RookHealthConnectRepository.disableBackground();

      // Disable background sync for Android Steps
      await RookStepsRepository.disableBackground();

      // Disable background sync for Samsung Health
      await RookSamsungHealthRepository.disableBackground();
    }

    if (Platform.isIOS) {
      // Disable background sync for Apple Health
      await RookAppleHealthRepository.disableBackground();
    }

    // Logout from all SDKs
    await RookHealthRepository.deleteUserFromRook();

    // Logout from application only if all SDKs are logged out
    //
    // The onboarding flow in this demo will override (see updateUserID behaviour in docs) any
    // previous/remaining userID before any data/connection is send/processed,
    // however is recommended to check that the userIDs were completely removed

    await _authRepository.logout();
    await _preferences.clear();

    emit(state.copyWith(loggingOut: false, logoutStatus: LogoutStatus.loggedOut));
  }
}

const List<String> disconnectableApiDataSources = [
  "Oura",
  "Polar",
  "Whoop",
  "Fitbit",
  "Garmin",
  "Withings",
];
