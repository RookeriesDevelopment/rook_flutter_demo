import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/theme/shapes.dart';

class DemoButton extends StatelessWidget {
  final String text;
  final void Function() onClick;

  const DemoButton({super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(shape: WidgetStatePropertyAll(buttonShape)),
      onPressed: onClick,
      child: Text(text),
    );
  }
}
