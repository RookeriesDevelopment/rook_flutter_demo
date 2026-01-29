import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/animated_visibility.dart';
import 'package:rook_flutter_demo/feature/summaries/domain/model/summaries_state.dart';
import 'package:rook_flutter_demo/feature/summaries/domain/model/summary.dart';
import 'package:rook_flutter_demo/feature/summaries/presentation/screen/summaries_cubit.dart';
import 'package:rook_flutter_demo/feature/summaries/presentation/widget/summary_card.dart';

class SummariesScreen extends StatelessWidget {
  const SummariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = context.isPortrait
        ? (context.screenSize.width / 2) - 32
        : (context.screenSize.width / 4) - 32;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: context.systemPadding + EdgeInsets.only(top: 16, left: 16, right: 16),
        child: BlocBuilder<SummariesCubit, SummariesState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SummariesCubit>().onSummariesRefresh();
              },
              child: SingleChildScrollView(
                clipBehavior: Clip.antiAlias,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How your journey goes…",
                      style: context.typography.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Move, rest, recharge and Repeat every day.",
                      style: context.typography.bodyLarge,
                    ),
                    AnimatedVisibility(
                      isVisible: state.loading,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4),
                        child: CircularProgressIndicator(),
                      ),
                    ),

                    // Health Connect
                    SizedBox(height: 20),
                    if (state.healthConnectSummary != null)
                      ..._buildSummaryCards(
                        context: context,
                        width: width,
                        title: "Health Connect summary",
                        summary: state.healthConnectSummary,
                      ),
                    if (state.healthConnectSummary == null)
                      Text(
                        "Connect with Health Connect to see your summary",
                        style: context.typography.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),

                    // Samsung Health
                    SizedBox(height: 20),
                    if (state.samsungHealthSummary != null)
                      ..._buildSummaryCards(
                        context: context,
                        width: width,
                        title: "Samsung Health summary",
                        summary: state.samsungHealthSummary,
                      ),
                    if (state.samsungHealthSummary == null)
                      Text(
                        "Connect with Samsung Health to see your summary",
                        style: context.typography.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),

                    // Apple Health
                    SizedBox(height: 20),
                    if (state.appleHealthSummary != null)
                      ..._buildSummaryCards(
                        context: context,
                        width: width,
                        title: "Apple Health summary",
                        summary: state.appleHealthSummary,
                      ),
                    if (state.appleHealthSummary == null)
                      Text(
                        "Connect with Apple Health to see your summary",
                        style: context.typography.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),

                    // Android Steps
                    SizedBox(height: 20),
                    if (state.androidStepsCount != null)
                      Text(
                        "Android summary",
                        style: context.typography.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    if (state.androidStepsCount != null)
                      SummaryCard(
                        width: width,
                        icon: Symbols.steps_rounded,
                        value: "${state.androidStepsCount}",
                      ),
                    if (state.androidStepsCount == null)
                      Text(
                        "Connect with Android to see your summary",
                        style: context.typography.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSummaryCards({
    required BuildContext context,
    required double width,
    required String title,
    required Summary? summary,
  }) {
    return [
      Text(title, style: context.typography.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          SummaryCard(width: width, icon: Symbols.steps_rounded, value: "${summary?.stepsCount}"),
          SummaryCard(
            width: width,
            icon: Symbols.mode_heat_rounded,
            value: "${summary?.caloriesCount}",
          ),
          SummaryCard(
            width: width,
            icon: Symbols.bedtime_rounded,
            value: "${summary?.sleepDurationInHours} hrs",
          ),
        ],
      ),
    ];
  }
}
