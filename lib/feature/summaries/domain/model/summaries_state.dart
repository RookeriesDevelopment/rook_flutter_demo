import 'package:equatable/equatable.dart';
import 'package:rook_flutter_demo/feature/summaries/domain/model/summary.dart';

final class SummariesState extends Equatable {
  final bool loading;
  final Summary? healthConnectSummary;
  final Summary? samsungHealthSummary;
  final Summary? appleHealthSummary;
  final int? androidStepsCount;

  const SummariesState({
    this.loading = false,
    this.healthConnectSummary,
    this.samsungHealthSummary,
    this.appleHealthSummary,
    this.androidStepsCount,
  });

  @override
  List<Object?> get props => [
    loading,
    healthConnectSummary,
    samsungHealthSummary,
    appleHealthSummary,
    androidStepsCount,
  ];
}
