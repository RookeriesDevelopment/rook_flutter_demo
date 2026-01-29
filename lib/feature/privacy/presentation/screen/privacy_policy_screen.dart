import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Privacy Policy')),
      body: Container(
        padding: context.systemPadding + EdgeInsets.all(16),
        height: double.infinity,
        alignment: Alignment.center,
        child: Text(
          'Your app should display an appropriate privacy policy for how you will handle and use Health Connect data.',
          textAlign: TextAlign.center,
          style: context.typography.bodyLarge,
        ),
      ),
    );
  }
}
