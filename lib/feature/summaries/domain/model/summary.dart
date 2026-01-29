import 'package:equatable/equatable.dart';

final class Summary extends Equatable {
  final int stepsCount;
  final int caloriesCount;
  final double sleepDurationInHours;

  const Summary({
    required this.stepsCount,
    required this.caloriesCount,
    required this.sleepDurationInHours,
  });

  @override
  List<Object?> get props => [stepsCount, caloriesCount, sleepDurationInHours];
}
