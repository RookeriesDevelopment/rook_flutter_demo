import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/domain/preferences/app_preferences.dart';
import 'package:rook_flutter_demo/feature/applehealth/domain/enum/apple_health_connection_status.dart';
import 'package:rook_flutter_demo/feature/applehealth/domain/model/apple_health_state.dart';
import 'package:rook_flutter_demo/rook/repository/rook_apple_health_repository.dart';
import 'package:rook_sdk_apple_health/rook_sdk_apple_health.dart';

class AppleHealthCubit extends Cubit<AppleHealthState> {
  final AppPreferences _preferences;
  final Logger _logger;

  AppleHealthCubit({required AppPreferences preferences, required Logger logger})
    : _preferences = preferences,
      _logger = logger,
      super(AppleHealthState());

  void onConnectionStatusDisplayed() {
    emit(state.copyWith(connectionStatus: AppleHealthConnectionStatus.unknown));
  }

  void onAllowAccessClick() {
    RookAppleHealthRepository.requestPermissions([])
        .then((_) {
          emit(state.copyWith(hasAskedForPermissions: true));
        })
        .catchError((error) {
          _logger.e("Failed to request Apple Health permissions", error: error);
        });
  }

  void onConnectClick() {
    _enableAppleHealth();
  }

  Future<void> _enableAppleHealth() async {
    if (state.hasAskedForPermissions) {
      await RookAppleHealthRepository.enableBackground(kDebugMode);
      await _preferences.toggleAppleHealth(true);

      emit(state.copyWith(connectionStatus: AppleHealthConnectionStatus.connected));
    } else {
      emit(state.copyWith(connectionStatus: AppleHealthConnectionStatus.missingPermissions));
    }
  }
}

const List<AppleHealthPermission> _applePermissions = [
  AppleHealthPermission.appleExerciseTime,
  AppleHealthPermission.appleMoveTime,
  AppleHealthPermission.appleStandTime,
  AppleHealthPermission.basalEnergyBurned,
  AppleHealthPermission.activeEnergyBurned,
  AppleHealthPermission.stepCount,
  AppleHealthPermission.distanceCycling,
  AppleHealthPermission.distanceWalkingRunning,
  AppleHealthPermission.distanceSwimming,
  AppleHealthPermission.swimmingStrokeCount,
  AppleHealthPermission.flightsClimbed,
  AppleHealthPermission.walkingSpeed,
  AppleHealthPermission.walkingStepLength,
  AppleHealthPermission.runningPower,
  AppleHealthPermission.runningSpeed,
  AppleHealthPermission.height,
  AppleHealthPermission.bodyMass,
  AppleHealthPermission.bodyMassIndex,
  AppleHealthPermission.waistCircumference,
  AppleHealthPermission.bodyFatPercentage,
  AppleHealthPermission.bodyTemperature,
  AppleHealthPermission.basalBodyTemperature,
  AppleHealthPermission.appleSleepingWristTemperature,
  AppleHealthPermission.heartRate,
  AppleHealthPermission.restingHeartRate,
  AppleHealthPermission.walkingHeartRateAverage,
  AppleHealthPermission.heartRateVariabilitySDNN,
  AppleHealthPermission.electrocardiogram,
  AppleHealthPermission.workout,
  AppleHealthPermission.sleepAnalysis,
  AppleHealthPermission.sleepApneaEvent,
  AppleHealthPermission.vo2Max,
  AppleHealthPermission.oxygenSaturation,
  AppleHealthPermission.respiratoryRate,
  AppleHealthPermission.uvExposure,
  AppleHealthPermission.biologicalSex,
  AppleHealthPermission.dateOfBirth,
  AppleHealthPermission.bloodPressureSystolic,
  AppleHealthPermission.bloodPressureDiastolic,
  AppleHealthPermission.bloodGlucose,
  AppleHealthPermission.dietaryEnergyConsumed,
  AppleHealthPermission.dietaryProtein,
  AppleHealthPermission.dietarySugar,
  AppleHealthPermission.dietaryFatTotal,
  AppleHealthPermission.dietaryCarbohydrates,
  AppleHealthPermission.dietaryFiber,
  AppleHealthPermission.dietarySodium,
  AppleHealthPermission.dietaryCholesterol,
];
