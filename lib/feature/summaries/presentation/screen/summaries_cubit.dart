import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rook_flutter_demo/core/domain/extension/future_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/extension/double_extensions.dart';
import 'package:rook_flutter_demo/feature/summaries/domain/model/summaries_state.dart';
import 'package:rook_flutter_demo/feature/summaries/domain/model/summary.dart';
import 'package:rook_flutter_demo/rook/repository/rook_apple_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_connect_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_samsung_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_steps_repository.dart';

final class SummariesCubit extends Cubit<SummariesState> {
  SummariesCubit() : super(SummariesState()) {
    onRefreshSummaries();
  }

  void onRefreshSummaries() {
    _loadSummaries();
  }

  Future<void> _loadSummaries() async {
    emit(
      SummariesState(
        loading: true,
        healthConnectSummary: state.healthConnectSummary,
        samsungHealthSummary: state.samsungHealthSummary,
        appleHealthSummary: state.appleHealthSummary,
        androidStepsCount: state.androidStepsCount,
      ),
    );

    final healthConnectSummary = await _getHealthConnectSummary().getOrDefault(null);
    final samsungHealthSummary = await _getSamsungHealthSummary().getOrDefault(null);
    final appleHealthSummary = await _getAppleHealthSummary().getOrDefault(null);
    final androidStepsCount = await _getAndroidStepsCount().getOrDefault(null);

    emit(
      SummariesState(
        loading: false,
        healthConnectSummary: healthConnectSummary,
        samsungHealthSummary: samsungHealthSummary,
        appleHealthSummary: appleHealthSummary,
        androidStepsCount: androidStepsCount,
      ),
    );
  }

  Future<Summary?> _getHealthConnectSummary() async {
    final available = await RookHealthConnectRepository.isCompatibleWithCurrentPlatform();

    if (!available) {
      // Health Connect is not available on this platform
      return null;
    }

    final connected = await RookHealthConnectRepository.isBackgroundEnabled();

    if (!connected) {
      // Health Connect is not connected (or user has disconnected it),
      // even if permissions are granted we should not access the data.
      return null;
    }

    final today = DateTime.now();

    final stepsCount = (await RookHealthConnectRepository.getTodayStepsCount()) ?? 0;

    final caloriesCount = await RookHealthConnectRepository.getTodayCaloriesCount().then((
      calories,
    ) {
      if (calories == null) {
        return 0;
      }

      // Get total calories by adding active and basal calories
      return (calories.active + calories.basal).round();
    });

    final sleepDurationInHours = await RookHealthConnectRepository.getSleepSummary(today).then((
      summaries,
    ) {
// Get total sleep duration by adding all sleep durations
      final totalDurationInHours = summaries.fold(0.0, (previousValue, element) {
        final durationInSeconds = element.sleepDurationSeconds?.toDouble() ?? 0.0;
        final durationInHours = durationInSeconds / _secondsInAnHour;
        return previousValue + durationInHours;
      });

      return totalDurationInHours.to2Decimals();
    });

    return Summary(
      stepsCount: stepsCount,
      caloriesCount: caloriesCount,
      sleepDurationInHours: sleepDurationInHours,
    );
  }

  Future<Summary?> _getSamsungHealthSummary() async {
    final available = await RookSamsungHealthRepository.isCompatibleWithCurrentPlatform();

    if (!available) {
      // Samsung Health is not available on this platform
      return null;
    }

    final connected = await RookSamsungHealthRepository.isBackgroundEnabled();

    if (!connected) {
      // Samsung Health is not connected (or user has disconnected it),
      // even if permissions are granted we should not access the data.
      return null;
    }

    final today = DateTime.now();

    final stepsCount = (await RookSamsungHealthRepository.getTodayStepsCount()) ?? 0;

    final caloriesCount = await RookSamsungHealthRepository.getTodayCaloriesCount().then((
      calories,
    ) {
      if (calories == null) {
        return 0;
      }

      // Get total calories by adding active and basal calories
      return (calories.active + calories.basal).round();
    });

    final sleepDurationInHours = await RookSamsungHealthRepository.getSleepSummary(today).then((
      summaries,
    ) {
// Get total sleep duration by adding all sleep durations
      final totalDurationInHours = summaries.fold(0.0, (previousValue, element) {
        final durationInSeconds = element.sleepDurationSeconds?.toDouble() ?? 0.0;
        final durationInHours = durationInSeconds / _secondsInAnHour;
        return previousValue + durationInHours;
      });

      return totalDurationInHours.to2Decimals();
    });

    return Summary(
      stepsCount: stepsCount,
      caloriesCount: caloriesCount,
      sleepDurationInHours: sleepDurationInHours,
    );
  }

  Future<Summary?> _getAppleHealthSummary() async {
    final available = await RookAppleHealthRepository.isCompatibleWithCurrentPlatform();

    if (!available) {
      // Apple Health is not available on this platform
      return null;
    }

    final connected = await RookAppleHealthRepository.isBackgroundEnabled();

    if (!connected) {
      // Apple Health is not connected (or user has disconnected it),
      // even if permissions are granted we should not access the data.
      return null;
    }

    final today = DateTime.now();

    final stepsCount = (await RookAppleHealthRepository.getTodayStepsCount()) ?? 0;

    final caloriesCount = await RookAppleHealthRepository.getTodayCaloriesCount().then((calories) {
      if (calories == null) {
        return 0;
      }

      // Get total calories by adding active and basal calories
      return (calories.active + calories.basal).round();
    });

    final sleepDurationInHours = await RookAppleHealthRepository.getSleepSummary(today).then((
      summaries,
    ) {
      // Get total sleep duration by adding all sleep durations
      final totalDurationInHours = summaries.fold(0.0, (previousValue, element) {
        final durationInSeconds = element.sleepDurationSeconds?.toDouble() ?? 0.0;
        final durationInHours = durationInSeconds / _secondsInAnHour;
        return previousValue + durationInHours;
      });

      return totalDurationInHours.to2Decimals();
    });

    return Summary(
      stepsCount: stepsCount,
      caloriesCount: caloriesCount,
      sleepDurationInHours: sleepDurationInHours,
    );
  }

  Future<int?> _getAndroidStepsCount() async {
    final available = await RookStepsRepository.isCompatibleWithCurrentPlatform();

    if (!available) {
      // Android Steps are not available on this platform
      return null;
    }

    final connected = await RookStepsRepository.isBackgroundEnabled();

    if (!connected) {
      // Android Steps are not connected (or user has disconnected it),
      // even if permissions are granted we should not access the data.
      return null;
    }

    final stepsCount = await RookStepsRepository.getTodayStepsCount();

    return stepsCount;
  }
}

const _secondsInAnHour = 3600;
