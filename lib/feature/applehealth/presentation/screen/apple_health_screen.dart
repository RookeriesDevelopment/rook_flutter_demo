import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/data_types_content.dart';
import 'package:rook_flutter_demo/core/presentation/widget/data_types_title.dart';
import 'package:rook_flutter_demo/core/presentation/widget/demo_button.dart';
import 'package:rook_flutter_demo/feature/applehealth/domain/enum/apple_health_connection_status.dart';
import 'package:rook_flutter_demo/feature/applehealth/domain/model/apple_health_state.dart';
import 'package:rook_flutter_demo/feature/applehealth/presentation/screen/apple_health_cubit.dart';

class AppleHealthScreen extends StatefulWidget {
  const AppleHealthScreen({super.key});

  @override
  State<AppleHealthScreen> createState() => _AppleHealthScreenState();
}

class _AppleHealthScreenState extends State<AppleHealthScreen> {
  bool _dataTypesExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: context.systemPadding + EdgeInsets.all(16),
        child: BlocConsumer<AppleHealthCubit, AppleHealthState>(
          listener: (context, state) {
            switch (state.connectionStatus) {
              case AppleHealthConnectionStatus.unknown:
                context.read<Logger>().d("unknown");
                break;
              case AppleHealthConnectionStatus.missingPermissions:
                context.showTextSnackBar("Access to at least one data type is required.");
                break;
              case AppleHealthConnectionStatus.connected:
                context.pop();
                break;
            }

            if (state.connectionStatus != AppleHealthConnectionStatus.unknown) {
              context.read<AppleHealthCubit>().onConnectionStatusDisplayed();
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
                      "assets/images/png_apple_health.png",
                      fit: BoxFit.cover,
                      width: context.screenSize.width / 3,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Use Apple Health to synchronize your health data",
                    textAlign: TextAlign.center,
                    style: context.typography.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _permissionsDeclaration,
                    textAlign: TextAlign.center,
                    style: context.typography.bodyLarge,
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
                            showCheck: state.hasAskedForPermissions,
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
                  DemoButton(
                    text: "Allow access",
                    onClick: () {
                      context.read<AppleHealthCubit>().onAllowAccessClick();
                    },
                  ),
                  DemoButton(
                    text: "Connect",
                    onClick: () {
                      context.read<AppleHealthCubit>().onConnectClick();
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    _manualPermissionsInstructions,
                    textAlign: TextAlign.center,
                    style: context.typography.labelSmall,
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

const List<String> _dataTypes = [
  "Apple Exercise Time",
  "Apple Move Time",
  "Apple Stand Time",
  "Basal Energy Burned",
  "Active Energy Burned",
  "Step Count",
  "Distance Cycling",
  "Distance Walking Running",
  "Distance Swimming",
  "Swimming Stroke Count",
  "Flights Climbed",
  "Walking Speed",
  "Walking Step Length",
  "Running Power",
  "Running Speed",
  "Height",
  "Body Mass",
  "Body Mass Index",
  "Waist Circumference",
  "Body Fat Percentage",
  "Body Temperature ",
  "Basal Body Temperature",
  "Apple Sleeping WristTemperature",
  "Heart Rate",
  "Resting Heart Rate",
  "Walking Heart RateAverage",
  "Heart Rate Variability SDNN",
  "Electrocardiogram",
  "Workout",
  "Sleep Analysis",
  "Sleep Apnea Event",
  "Vo2 Max",
  "Oxygen Saturation",
  "Respiratory Rate",
  "Uv Exposure",
  "Biological Sex",
  "Date Of Birth",
  "Blood Pressure Systolic",
  "Blood Pressure Diastolic",
  "Blood Glucose",
  "Dietary Energy Consumed",
  "Dietary Protein",
  "Dietary Sugar",
  "Dietary Fat Total",
  "Dietary Carbohydrates",
  "Dietary Fiber",
  "Dietary Sodium",
  "Dietary Cholesterol",
];

const String _permissionsDeclaration = """
Our app integrates with Apple Health to gather various health metrics that help us provide users 
with personalized insights and a comprehensive Health Score.

By analyzing multiple data points from daily steps, distance traveled and calories burned to sleep 
quality, hear rate blood pressure and more we create a holistic picture of each user's overall 
well-being.  
""";

const String _manualPermissionsInstructions = """
If you have previously granted or denied permissions, the permission prompt will not appear again.

To manage access, go to the Settings app and navigate to Settings > Privacy > Health. 
""";
