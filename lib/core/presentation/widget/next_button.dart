import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/theme/shapes.dart';

class NextButton extends StatelessWidget {
  final void Function() onClick;

  const NextButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: context.colorScheme.inverseSurface,
        shape: iconButtonShape,
        child: InkWell(
          onTap: onClick,
          child: Icon(
            Icons.arrow_forward_ios,
            color: context.colorScheme.onInverseSurface,
          ),
        ),
      ),
    );
  }
}

class NextTextButton extends StatelessWidget {
  final bool enabled;
  final void Function() onClick;

  const NextTextButton({
    super.key,
    this.enabled = true,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      style: ButtonStyle(shape: WidgetStatePropertyAll(buttonShape)),
      onPressed: enabled ? onClick : null,
      label: Text("Next"),
      icon: Icon(Icons.arrow_forward),
      iconAlignment: IconAlignment.end,
    );
  }
}
