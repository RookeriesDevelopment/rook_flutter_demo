import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_samsung_health/rook_sdk_samsung_health.dart';

class RookSamsungHealthRepository {
  RookSamsungHealthRepository._();

  static Future<bool> isCompatibleWithCurrentPlatform() async {
    if (Platform.isIOS) {
      return false;
    } else {
      try {
        return await isCompatible();
      } catch (ignored) {
        return false;
      }
    }
  }

  static Future<bool> isCompatible() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidVersion = androidInfo.version;

    return androidVersion.sdkInt >= 29;
  }

  static Future<SamsungHealthAvailability> checkSamsungHealthAvailability() {
    return RookSamsung.checkSamsungHealthAvailability();
  }

  static Future<bool> checkSamsungHealthPermissions(
    List<SamsungHealthPermission> permissions,
  ) {
    return RookSamsung.checkSamsungHealthPermissions(permissions);
  }

  static Future<bool> checkSamsungHealthPermissionsPartially(
    List<SamsungHealthPermission> permissions,
  ) {
    return RookSamsung.checkSamsungHealthPermissionsPartially(permissions);
  }

  static Future<RequestPermissionsStatus> requestSamsungHealthPermissions(
    List<SamsungHealthPermission> permissions,
  ) {
    return RookSamsung.requestSamsungHealthPermissions(permissions);
  }

  static Stream<SamsungHealthPermissionsSummary> get permissionsUpdates {
    return RookSamsung.requestSamsungHealthPermissionsUpdates;
  }

  static Future<void> syncHistoricSummaries(bool enableLogs) {
    return RookSamsung.sync(enableLogs: enableLogs);
  }

  static Future<void> syncSummariesByDate(DateTime date) {
    return RookSamsung.sync(date: date);
  }

  static Future<void> syncByDateAndSummary(
    DateTime date,
    SHSummarySyncType summary,
  ) {
    return RookSamsung.sync(date: date, summary: summary);
  }

  static Future<void> syncByDateAndEvent(DateTime date, SHEventSyncType event) {
    return RookSamsung.syncEvents(date, event);
  }

  static Future<List<SleepSummary>> getSleepSummary(DateTime date) {
    return RookSamsung.getSleepSummary(date);
  }

  static Future<PhysicalSummary?> getPhysicalSummary(DateTime date) {
    return RookSamsung.getPhysicalSummary(date);
  }

  static Future<BodySummary?> getBodySummary(DateTime date) {
    return RookSamsung.getBodySummary(date);
  }

  static Future<List<ActivityEvent>> getActivityEvents(DateTime date) {
    return RookSamsung.getActivityEvents(date);
  }

  static Future<int?> getTodayStepsCount() {
    return RookSamsung.getTodayStepsCount().then((syncStatus) {
      return switch (syncStatus) {
        Synced(data: final int value) => value,
        _ => null,
      };
    });
  }

  static Future<DailyCalories?> getTodayCaloriesCount() {
    return RookSamsung.getTodayCaloriesCount().then((syncStatus) {
      return switch (syncStatus) {
        Synced(data: final DailyCalories value) => value,
        _ => null,
      };
    });
  }

  static Stream<bool> get isScheduledUpdates {
    return RookSamsung.isScheduledUpdates;
  }

  static Future<bool> isBackgroundEnabled() {
    return RookSamsung.isScheduled();
  }

  static Future<void> enableBackground(
    bool enableNativeLogs, {
    bool cancelAndReschedule = false,
  }) {
    return RookSamsung.enableBackground(
      enableNativeLogs: enableNativeLogs,
      cancelAndReschedule: cancelAndReschedule,
    );
  }

  static Future<void> disableBackground() {
    return RookSamsung.disableBackground();
  }
}
