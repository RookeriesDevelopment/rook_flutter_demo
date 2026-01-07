import 'dart:io';

import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

class RookStepsRepository {
  RookStepsRepository._();

  static Future<bool> isCompatibleWithCurrentPlatform() async {
    if (Platform.isIOS) {
      return false;
    } else {
      try {
        return await AndroidStepsManager.isAvailable();
      } catch (ignored) {
        return false;
      }
    }
  }

  static Future<bool> checkAndroidPermissions() {
    return HCRookHealthPermissionsManager.checkAndroidPermissions();
  }

  static Future<bool> shouldRequestAndroidPermissions() {
    return HCRookHealthPermissionsManager.shouldRequestAndroidPermissions();
  }

  static Future<RequestPermissionsStatus> requestAndroidPermissions() {
    return HCRookHealthPermissionsManager.requestAndroidPermissions();
  }

  static Stream<AndroidPermissionsSummary> get permissionsUpdates {
    return HCRookHealthPermissionsManager.requestAndroidPermissionsUpdates;
  }

  static Future<bool> isAvailable() {
    return AndroidStepsManager.isAvailable();
  }

  static Future<bool> isBackgroundEnabled() {
    return AndroidStepsManager.isBackgroundAndroidStepsActive();
  }

  static Future<void> enableBackground() {
    return AndroidStepsManager.enableBackgroundAndroidSteps();
  }

  static Future<void> disableBackground() {
    return AndroidStepsManager.disableBackgroundAndroidSteps();
  }

  static Future<int> getTodayStepsCount() {
    return AndroidStepsManager.syncTodayAndroidStepsCount();
  }
}
