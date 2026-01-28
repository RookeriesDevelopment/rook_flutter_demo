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
import 'package:rook_flutter_demo/feature/healthconnect/domain/enum/health_connect_connection_status.dart';
import 'package:rook_flutter_demo/feature/healthconnect/domain/enum/health_connect_status.dart';
import 'package:rook_flutter_demo/feature/healthconnect/domain/model/health_connect_state.dart';
import 'package:rook_flutter_demo/feature/healthconnect/presentation/screen/health_connect_cubit.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_connect_repository.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

class HealthConnectScreen extends StatefulWidget {
  const HealthConnectScreen({super.key});

  @override
  State<HealthConnectScreen> createState() => _HealthConnectScreenState();
}

class _HealthConnectScreenState extends State<HealthConnectScreen> with WidgetsBindingObserver {
  StreamSubscription<HealthConnectPermissionsSummary>? _streamSubscription;

  bool _dataTypesExpanded = false;
  bool _backgroundExpanded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    context.read<HealthConnectCubit>().onResume();

    _streamSubscription = RookHealthConnectRepository.permissionsUpdates.listen((
      permissionsSummary,
    ) {
      final context = this.context;

      if (!context.mounted) {
        return;
      }

      final dataTypesPermissions =
          permissionsSummary.dataTypesGranted || permissionsSummary.dataTypesPartiallyGranted;

      context.read<HealthConnectCubit>().onPermissionsChanged(
        dataTypesPermissions: dataTypesPermissions,
        backgroundPermissions: permissionsSummary.backgroundReadGranted,
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
      context.read<HealthConnectCubit>().onResume();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: context.systemPadding + EdgeInsets.all(16),
        child: BlocConsumer<HealthConnectCubit, HealthConnectState>(
          listener: (context, state) {
            switch (state.connectionStatus) {
              case HealthConnectConnectionStatus.unknown:
                context.read<Logger>().d("unknown");
                break;
              case HealthConnectConnectionStatus.missingPermissions:
                context.showTextSnackBar(
                  "Background data access and at least one data type are required.",
                );
                break;
              case HealthConnectConnectionStatus.missingDataTypesPermissions:
                context.showTextSnackBar("Access to at least one data type is required.");
                break;
              case HealthConnectConnectionStatus.missingBackgroundPermissions:
                context.showTextSnackBar("Background data access is required.");
                break;
              case HealthConnectConnectionStatus.connected:
                context.pop();
                break;
            }

            if (state.connectionStatus != HealthConnectConnectionStatus.unknown) {
              context.read<HealthConnectCubit>().onConnectionStatusDisplayed();
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
                      "assets/images/png_health_connect.png",
                      fit: BoxFit.cover,
                      width: context.screenSize.width / 3,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Use Health Connect to synchronize your health data",
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
                            showCheck: state.dataTypesGranted,
                            text: "Read access to one or more data types",
                            expanded: _dataTypesExpanded,
                            onClick: () {
                              setState(() => _dataTypesExpanded = !_dataTypesExpanded);
                            },
                          ),
                          DataTypesContent(expanded: _dataTypesExpanded, dataTypes: _dataTypes),
                          DataTypesTitle(
                            showCheck: state.backgroundGranted,
                            text: "Background data access (required)",
                            expanded: _backgroundExpanded,
                            onClick: () {
                              setState(() => _backgroundExpanded = !_backgroundExpanded);
                            },
                          ),
                          AnimatedVisibility(
                            isVisible: _backgroundExpanded,
                            child: Text(
                              _backgroundReadInstructions,
                              textAlign: TextAlign.center,
                              style: context.typography.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  switch (state.status) {
                    HealthConnectStatus.loading => CircularProgressIndicator(),
                    HealthConnectStatus.notSupported => Text(
                      "Health Connect is not supported on this device",
                      textAlign: TextAlign.center,
                      style: context.typography.bodyLarge,
                    ),
                    HealthConnectStatus.notInstalled => MessageAndButton(
                      text:
                          "Health Connect is not installed. Please download it from the Play Store.",
                      buttonText: "Download",
                      onClick: () {
                        context.read<HealthConnectCubit>().onDownloadClick();
                      },
                    ),
                    HealthConnectStatus.backgroundNotSupported => Text(
                      "Your version of Health Connect can't share data with our app in the background right now. Try updating the Health Connect app or your phone (system updates); if that doesn't help, background sharing may not be available on your device.",
                    ),
                    HealthConnectStatus.ready => Column(
                      children: [
                        AnimatedVisibility(
                          isVisible: state.showAllowAccessButton,
                          child: Center(
                            child: DemoButton(
                              text: "Allow access",
                              onClick: () {
                                context.read<HealthConnectCubit>().onAllowAccessClick();
                              },
                            ),
                          ),
                        ),
                        AnimatedVisibility(
                          isVisible: state.dataTypesGranted && state.backgroundGranted,
                          child: Center(
                            child: DemoButton(
                              text: "Connect",
                              onClick: () {
                                context.read<HealthConnectCubit>().onConnectClick();
                              },
                            ),
                          ),
                        ),
                        AnimatedVisibility(
                          isVisible: state.showOpenSettingsButton,
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Text(
                                "If you previously denied permissions, you can give access by going to Health Connect Settings → App Permissions → ROOK.",
                                textAlign: TextAlign.center,
                                style: context.typography.labelSmall,
                              ),
                              SizedBox(height: 12),
                              DemoButton(
                                text: "Health Connect Settings",
                                onClick: () {
                                  context.read<HealthConnectCubit>().onOpenSettingsClick();
                                },
                              ),
                            ],
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
  "Active Calories Burned",
  "Basal body temperature",
  "Blood Glucose",
  "Blood Pressure",
  "Body fat",
  "Body Temperature",
  "Body water mass",
  "Bone mass",
  "Distance",
  "Elevation Gained",
  "Exercise",
  "Floors Climbed",
  "Heart Rate",
  "Heart Rate Variability",
  "Height",
  "Hydration",
  "Lean body mass",
  "Nutrition",
  "Oxygen Saturation",
  "Power",
  "Respiratory Rate",
  "Resting Heart Rate",
  "Sleep",
  "Speed",
  "Steps",
  "Total Calories Burned",
  "VO2 Max",
  "Weight",
];

const String _backgroundReadInstructions = """
ROOK runs in the background to always keep your data up to date, Health Connect restricts background access unless the user gives it's permission.

After you give access to all the data types of your choice a second screen will be displayed, click on 'Allow' to grant background access.

If you previously denied permissions, you can give access in Health Connect Settings by going to App Permissions → ROOK → Additional Access → Turn on 'Access data in the background'.
""";
