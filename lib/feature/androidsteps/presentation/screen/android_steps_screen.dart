import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/animated_visibility.dart';
import 'package:rook_flutter_demo/core/presentation/widget/demo_button.dart';
import 'package:rook_flutter_demo/feature/androidsteps/domain/enum/android_steps_connection_status.dart';
import 'package:rook_flutter_demo/feature/androidsteps/domain/model/android_steps_state.dart';
import 'package:rook_flutter_demo/feature/androidsteps/presentation/screen/android_steps_cubit.dart';
import 'package:rook_flutter_demo/rook/repository/rook_steps_repository.dart';
import 'package:rook_sdk_health_connect/rook_sdk_health_connect.dart';

class AndroidStepsScreen extends StatefulWidget {
  const AndroidStepsScreen({super.key});

  @override
  State<AndroidStepsScreen> createState() => _AndroidStepsScreenState();
}

class _AndroidStepsScreenState extends State<AndroidStepsScreen> with WidgetsBindingObserver {
  StreamSubscription<AndroidPermissionsSummary>? _streamSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    context.read<AndroidStepsCubit>().onResume();

    _streamSubscription = RookStepsRepository.permissionsUpdates.listen((permissionsSummary) {
      final context = this.context;

      if (!context.mounted) {
        return;
      }

      context.read<AndroidStepsCubit>().onPermissionsChanged(
        permissionsGranted: permissionsSummary.permissionsGranted,
        shouldRequestPermissions: permissionsSummary.dialogDisplayed,
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
      context.read<AndroidStepsCubit>().onResume();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: context.systemPadding + EdgeInsets.all(16),
        child: BlocConsumer<AndroidStepsCubit, AndroidStepsState>(
          listener: (context, state) {
            switch (state.connectionStatus) {
              case AndroidStepsConnectionStatus.unknown:
                context.read<Logger>().d("unknown");
                break;
              case AndroidStepsConnectionStatus.missingPermissions:
                context.showTextSnackBar("Try again and grant the required permissions.");
                break;
              case AndroidStepsConnectionStatus.connected:
                context.pop();
                break;
            }

            if (state.connectionStatus != AndroidStepsConnectionStatus.unknown) {
              context.read<AndroidStepsCubit>().onConnectionStatusDisplayed();
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
                      "assets/images/png_android_steps.png",
                      fit: BoxFit.cover,
                      width: context.screenSize.width / 3,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Use the built in steps sensor of your device to synchronize your daily steps count",
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
                  Text(
                    "• Notifications",
                    textAlign: TextAlign.center,
                    style: context.typography.bodySmall,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "• Physical activity",
                    textAlign: TextAlign.center,
                    style: context.typography.bodySmall,
                  ),
                  SizedBox(height: 24),
                  AnimatedVisibility(
                    isVisible: state.showGrantPermissionsButton,
                    child: Center(
                      child: DemoButton(
                        text: "Grant permissions",
                        onClick: () {
                          context.read<AndroidStepsCubit>().onGrantPermissionsClick();
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
                          context.read<AndroidStepsCubit>().onConnectClick();
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
                          "Since you have previously denied some permissions you need to go to ROOK settings to grant them again.",
                          textAlign: TextAlign.center,
                          style: context.typography.bodyMedium,
                        ),
                        SizedBox(height: 12),
                        DemoButton(
                          text: "Open settings",
                          onClick: () {
                            context.read<AndroidStepsCubit>().onOpenSettingsClick();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
