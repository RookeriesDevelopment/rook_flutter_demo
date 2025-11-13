import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/configurable.dart';
import 'package:rook_flutter_demo/core/presentation/widget/next_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.colorScheme.primaryContainer,
        padding: context.systemPadding + EdgeInsets.all(16),
        width: double.infinity,
        child: Configurable(
          portraitBuilder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(flex: 75),
              Text(
                "Unlock your",
                style: context.typography.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "potential",
                style: context.typography.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Take control of your health journey with the right tools at your fingertips.",
                style: context.typography.bodyLarge,
              ),
              SizedBox(height: 24),
              NextButton(
                onClick: () {
                  context.pushReplacement("/login");
                },
              ),
              Spacer(flex: 25),
            ],
          ),
          landscapeBuilder: (context) => Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Unlock your",
                      style: context.typography.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "potential",
                      style: context.typography.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Take control of your health journey with the right tools at your fingertips.",
                      style: context.typography.bodyLarge,
                    ),
                    SizedBox(height: 24),
                    NextButton(
                      onClick: () {
                        context.pushReplacement("/login");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
