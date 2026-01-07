import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/connections/domain/enum/health_kit_type.dart';

abstract interface class Connection {}

final class ConnectionApi extends Equatable implements Connection {
  final String name;
  final bool connected;
  final String iconUrl;

  String? get disconnectionType {
    return switch (name) {
      "Oura" => "Oura",
      "Polar" => "Polar",
      "Whoop" => "Whoop",
      "Fitbit" => "Fitbit",
      "Garmin" => "Garmin",
      "Withings" => "Withings",
      _ => null,
    };
  }

  const ConnectionApi({
    required this.name,
    required this.connected,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [name, connected, iconUrl];
}

final class ConnectionHealthKit extends Equatable implements Connection {
  final HealthKitType type;
  final String name;
  final bool connected;
  final String iconName;

  const ConnectionHealthKit._({
    required this.type,
    required this.name,
    required this.connected,
    required this.iconName,
  });

  const ConnectionHealthKit.appleHealth({required bool connected})
    : this._(
        type: HealthKitType.appleHealth,
        name: 'Apple Health',
        connected: connected,
        iconName: "assets/images/png_apple_health.png",
      );

  const ConnectionHealthKit.healthConnect({required bool connected})
    : this._(
        type: HealthKitType.healthConnect,
        name: 'Health Connect',
        connected: connected,
        iconName: "assets/images/png_health_connect.png",
      );

  const ConnectionHealthKit.samsungHealth({required bool connected})
    : this._(
        type: HealthKitType.samsungHealth,
        name: 'Samsung Health',
        connected: connected,
        iconName: "assets/images/png_samsung_health.png",
      );

  const ConnectionHealthKit.androidSteps({required bool connected})
    : this._(
        type: HealthKitType.androidSteps,
        name: 'Android Steps',
        connected: connected,
        iconName: "assets/images/png_android_steps.png",
      );

  @override
  List<Object?> get props => [type, name, connected, iconName];
}
