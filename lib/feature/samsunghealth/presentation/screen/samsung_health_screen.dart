import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/animated_visibility.dart';
import 'package:rook_flutter_demo/core/presentation/widget/data_types_content.dart';
import 'package:rook_flutter_demo/core/presentation/widget/data_types_title.dart';
import 'package:rook_flutter_demo/core/presentation/widget/demo_button.dart';
import 'package:rook_flutter_demo/core/presentation/widget/message_and_button.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/enum/samsung_health_connection_status.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/enum/samsung_health_status.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/domain/model/samsung_health_state.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/presentation/screen/samsung_health_cubit.dart';
import 'package:rook_flutter_demo/rook/repository/rook_samsung_health_repository.dart';
import 'package:rook_sdk_samsung_health/rook_sdk_samsung_health.dart';

class SamsungHealthScreen extends StatefulWidget {
  const SamsungHealthScreen({super.key});

  @override
  State<SamsungHealthScreen> createState() => _SamsungHealthScreenState();
}

class _SamsungHealthScreenState extends State<SamsungHealthScreen> with WidgetsBindingObserver {
  StreamSubscription<SamsungHealthPermissionsSummary>? _streamSubscription;

  bool _dataTypesExpanded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    context.read<SamsungHealthCubit>().onResume();

    _streamSubscription = RookSamsungHealthRepository.permissionsUpdates.listen((
      permissionsSummary,
    ) {
      final context = this.context;

      if (!context.mounted) {
        return;
      }

      context.read<SamsungHealthCubit>().onPermissionsChanged(
        allPermissions: permissionsSummary.dataTypesGranted,
        partialPermissions: permissionsSummary.dataTypesPartiallyGranted,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SamsungHealthCubit>().onResume();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: context.systemPadding + EdgeInsets.all(16),
        child: BlocConsumer<SamsungHealthCubit, SamsungHealthState>(
          listener: (context, state) {
            switch (state.connectionStatus) {
              case SamsungHealthConnectionStatus.unknown:
                context.read<Logger>().d("unknown");
                break;
              case SamsungHealthConnectionStatus.missingPermissions:
                context.showTextSnackBar("Access to at least one data type is required.");
                break;
              case SamsungHealthConnectionStatus.connected:
                context.pop();
                break;
            }

            if (state.connectionStatus != SamsungHealthConnectionStatus.unknown) {
              context.read<SamsungHealthCubit>().onConnectionStatusDisplayed();
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/png_samsung_health.png",
                      fit: BoxFit.cover,
                      width: context.screenSize.width / 3,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Use Samsung Health to synchronize your health data",
                    textAlign: TextAlign.center,
                    style: context.typography.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "ROOK needs the following permissions to continue:",
                    textAlign: TextAlign.center,
                    style: context.typography.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          DataTypesTitle(
                            showCheck: state.permissionsGranted,
                            text: "Read access to one or more data types",
                            expanded: _dataTypesExpanded,
                            onClick: () {
                              setState(() => _dataTypesExpanded = !_dataTypesExpanded);
                            },
                          ),
                          DataTypesContent(expanded: _dataTypesExpanded, dataTypes: _dataTypes),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  switch (state.status) {
                    SamsungHealthStatus.loading => CircularProgressIndicator(),
                    SamsungHealthStatus.error => MessageAndButton(
                      text: "Could not connect with Samsung Health.",
                      buttonText: "Retry",
                      onClick: () {
                        context.read<SamsungHealthCubit>().onResume();
                      },
                    ),
                    SamsungHealthStatus.notInstalled => MessageAndButton(
                      text:
                          "Samsung Health is not installed. Please download it from the Play Store.",
                      buttonText: "Download",
                      onClick: () {
                        context.read<SamsungHealthCubit>().onDownloadClick();
                      },
                    ),
                    SamsungHealthStatus.outdated => MessageAndButton(
                      text:
                          "Your current version of Samsung Health is not supported. Please updated it to the latest version.",
                      buttonText: "Update",
                      onClick: () {
                        context.read<SamsungHealthCubit>().onDownloadClick();
                      },
                    ),
                    SamsungHealthStatus.disabled => MessageAndButton(
                      text:
                          "Your Samsung Health installation is disabled, please enable it and try again.",
                      buttonText: "Open settings",
                      onClick: () {
                        context.read<SamsungHealthCubit>().onOpenSettingsClick();
                      },
                    ),
                    SamsungHealthStatus.notReady => Text(
                      "It seems that you haven't completed the onboarding process. Please complete it and try again.",
                      textAlign: TextAlign.center,
                      style: context.typography.bodyLarge,
                    ),
                    SamsungHealthStatus.ready => Column(
                      children: [
                        AnimatedVisibility(
                          isVisible: state.showAllowAccessButton,
                          child: Center(
                            child: DemoButton(
                              text: "Allow access",
                              onClick: () {
                                context.read<SamsungHealthCubit>().onAllowAccessClick();
                              },
                            ),
                          ),
                        ),
                        AnimatedVisibility(
                          isVisible: state.permissionsGranted,
                          child: Center(
                            child: DemoButton(
                              text: "Connect",
                              onClick: () {
                                context.read<SamsungHealthCubit>().onConnectClick();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

const List<String> _dataTypes = [
  "Activity Summary (Total active calories burned, active time, calories burned and distance)",
  "Blood Glucose",
  "Blood Oxygen",
  "Blood Pressure",
  "Body Composition",
  "Exercise",
  "Exercise Location",
  "Floors Climbed",
  "Heart Rate",
  "Nutrition",
  "Sleep",
  "Steps",
  "Water Intake",
];
