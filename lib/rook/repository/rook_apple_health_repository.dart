import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rook_sdk_apple_health/rook_sdk_apple_health.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';

class RookAppleHealthRepository {
  RookAppleHealthRepository._();

  static Future<bool> isCompatibleWithCurrentPlatform() async {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> requestPermissions(List<AppleHealthPermission> permissions) {
    return AHRookHealthPermissionsManager.requestPermissions(permissions);
  }

  static Future<void> syncHistoricSummaries(bool enableLogs) {
    return AHRookSyncManager.sync(enableLogs: enableLogs);
  }

  static Future<void> syncSummariesByDate(DateTime date) {
    return AHRookSyncManager.sync(date: date);
  }

  static Future<void> syncByDateAndSummary(DateTime date, AHSummarySyncType summary) {
    return AHRookSyncManager.sync(date: date, summary: summary);
  }

  static Future<void> syncByDateAndEvent(DateTime date, AHEventSyncType event) {
    return AHRookSyncManager.syncEvents(date, event);
  }

  static Future<List<SleepSummary>> getSleepSummary(DateTime date) {
    return AHRookSyncManager.getSleepSummary(date);
  }

  static Future<PhysicalSummary?> getPhysicalSummary(DateTime date) {
    return AHRookSyncManager.getPhysicalSummary(date);
  }

  static Future<BodySummary?> getBodySummary(DateTime date) {
    return AHRookSyncManager.getBodySummary(date);
  }

  static Future<List<ActivityEvent>> getActivityEvents(DateTime date) {
    return AHRookSyncManager.getActivityEvents(date);
  }

  static Future<int?> getTodayStepsCount() {
    return AHRookSyncManager.getTodayStepsCount();
  }

  static Future<DailyCalories?> getTodayCaloriesCount() {
    return AHRookSyncManager.getTodayCaloriesCount();
  }

  static Future<bool> isBackgroundEnabled() {
    return AHRookBackgroundSync.isScheduled();
  }

  static Future<void> enableBackground(bool enableNativeLogs) async {
    await dotenv.load();
    final clientUUID = dotenv.env['clientUUID'];
    final secretKey = dotenv.env['secretKey'];
    final environment = RookEnvironment.sandbox;

    if (clientUUID == null || secretKey == null) {
      throw Exception("Missing environment variables: clientUUID, secretKey");
    }

    return AHRookBackgroundSync.enableBackground(
      enableNativeLogs: enableNativeLogs,
      clientUUID: clientUUID,
      secretKey: secretKey,
      environment: environment,
    );
  }

  static Future<void> disableBackground() {
    return AHRookBackgroundSync.disableBackground();
  }
}
