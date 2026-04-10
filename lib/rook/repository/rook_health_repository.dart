import 'dart:io';

import 'package:rook_sdk_apple_health/rook_sdk_apple_health.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';
import 'package:rook_sdk_samsung_health/rook_sdk_samsung_health.dart';

class RookHealthRepository {
  RookHealthRepository._();

  static Future<void> enableNativeLogs() async {
    if (Platform.isIOS) {
      // Will be fixed in next v4 release
      AHRookConfigurationManager.enableNativeLogs();
    } else {
      await HCRookConfigurationManager.enableNativeLogs();
      await RookSamsung.enableNativeLogs();
    }
  }

  static Future<void> initRook(
    String clientUUID,
    String secret,
    RookEnvironment environment,
    String packageName,
    String bundleId,
  ) async {
    if (Platform.isIOS) {
      final configuration = RookConfiguration(
        clientUUID: clientUUID,
        secret: secret,
        environment: environment,
        appId: bundleId,
        enableBackgroundSync: false,
      );

      await AHRookConfigurationManager.setConfiguration(configuration);
      await AHRookConfigurationManager.initRook();
    } else {
      final configuration = RookConfiguration(
        clientUUID: clientUUID,
        secret: secret,
        environment: environment,
        appId: packageName,
        enableBackgroundSync: false,
      );

      await HCRookConfigurationManager.setConfiguration(configuration);
      await HCRookConfigurationManager.initRook();
      await RookSamsung.initRook(configuration);
    }
  }

  static Future<String?> getUserID() async {
    if (Platform.isIOS) {
      return AHRookConfigurationManager.getUserID();
    } else {
      final healthConnectUser = await HCRookConfigurationManager.getUserID();
      final samsungHealthUser = await RookSamsung.getUserID();

      if (healthConnectUser != null && samsungHealthUser != null) {
        if (healthConnectUser == samsungHealthUser) {
          return healthConnectUser;
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  static Future<void> updateUserID(String userID) async {
    if (Platform.isIOS) {
      await AHRookConfigurationManager.updateUserID(userID);
    } else {
      await HCRookConfigurationManager.updateUserID(userID);
      await RookSamsung.updateUserID(userID);
    }
  }

  static Future<void> syncUserTimeZone() async {
    if (Platform.isIOS) {
      await AHRookConfigurationManager.syncUserTimeZone();
    } else {
      await HCRookConfigurationManager.syncUserTimeZone();
      await RookSamsung.syncUserTimeZone();
    }
  }

  static Future<void> deleteUserFromRook() async {
    if (Platform.isIOS) {
      await AHRookConfigurationManager.deleteUserFromRook();
    } else {
      await HCRookConfigurationManager.deleteUserFromRook();
      await RookSamsung.deleteUserFromRook();
    }
  }
}
