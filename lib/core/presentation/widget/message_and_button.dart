import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/demo_button.dart';

class MessageAndButton extends StatelessWidget {
  final String text;
  final String buttonText;
  final void Function() onClick;

  const MessageAndButton({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, textAlign: TextAlign.center, style: context.typography.bodyLarge),
        SizedBox(height: 12),
        DemoButton(text: buttonText, onClick: onClick),
      ],
    );
  }
}
