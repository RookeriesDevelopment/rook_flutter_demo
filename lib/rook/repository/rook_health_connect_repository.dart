import 'package:rook_sdk_core/rook_sdk_core.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

class RookHealthConnectRepository {
  RookHealthConnectRepository._();

  static Future<HCAvailabilityStatus> checkHealthConnectAvailability() {
    return HCRookHealthPermissionsManager.checkHealthConnectAvailability();
  }

  static Future<void> openHealthConnectSettings() {
    return HCRookHealthPermissionsManager.openHealthConnectSettings();
  }

  static Future<bool> checkHealthConnectPermissions() {
    return HCRookHealthPermissionsManager.checkHealthConnectPermissions();
  }

  static Future<bool> checkHealthConnectPermissionsPartially() {
    return HCRookHealthPermissionsManager.checkHealthConnectPermissionsPartially();
  }

  static Future<HCBackgroundReadStatus> checkBackgroundReadStatus() {
    return HCRookHealthPermissionsManager.checkBackgroundReadStatus();
  }

  static Future<RequestPermissionsStatus> requestHealthConnectPermissions() {
    return HCRookHealthPermissionsManager.requestHealthConnectPermissions();
  }

  static Future<void> revokeHealthConnectPermissions() {
    return HCRookHealthPermissionsManager.revokeHealthConnectPermissions();
  }

  static Stream<HealthConnectPermissionsSummary> get permissionsUpdates {
    return HCRookHealthPermissionsManager
        .requestHealthConnectPermissionsUpdates;
  }

  static Future<void> syncHistoricSummaries(bool enableLogs) {
    return HCRookSyncManager.sync(enableLogs: enableLogs);
  }

  static Future<void> syncSummariesByDate(DateTime date) {
    return HCRookSyncManager.sync(date: date);
  }

  static Future<void> syncByDateAndSummary(
    DateTime date,
    HCSummarySyncType summary,
  ) {
    return HCRookSyncManager.sync(date: date, summary: summary);
  }

  static Future<void> syncByDateAndEvent(DateTime date, HCEventSyncType event) {
    return HCRookSyncManager.syncEvents(date, event);
  }

  static Future<List<SleepSummary>> getSleepSummary(DateTime date) {
    return HCRookSyncManager.getSleepSummary(date);
  }

  static Future<PhysicalSummary?> getPhysicalSummary(DateTime date) {
    return HCRookSyncManager.getPhysicalSummary(date);
  }

  static Future<BodySummary?> getBodySummary(DateTime date) {
    return HCRookSyncManager.getBodySummary(date);
  }

  static Future<List<ActivityEvent>> getActivityEvents(DateTime date) {
    return HCRookSyncManager.getActivityEvents(date);
  }

  static Future<int?> getTodayStepsCount() {
    return HCRookSyncManager.getTodayStepsCount().then((syncStatus) {
      return switch (syncStatus) {
        Synced(data: final int value) => value,
        _ => null,
      };
    });
  }

  static Future<DailyCalories?> getTodayCaloriesCount() {
    return HCRookSyncManager.getTodayCaloriesCount().then((syncStatus) {
      return switch (syncStatus) {
        Synced(data: final DailyCalories value) => value,
        _ => null,
      };
    });
  }

  static Stream<bool> get isScheduledUpdates {
    return HCRookBackgroundSync.isScheduledUpdates;
  }

  static Future<bool> isBackgroundEnabled() {
    return HCRookBackgroundSync.isScheduled();
  }

  static Future<void> enableBackground(
    bool enableNativeLogs, {
    bool cancelAndReschedule = false,
  }) {
    return HCRookBackgroundSync.enableBackground(
      enableNativeLogs: enableNativeLogs,
      cancelAndReschedule: cancelAndReschedule,
    );
  }

  static Future<void> disableBackground() {
    return HCRookBackgroundSync.disableBackground();
  }
}
