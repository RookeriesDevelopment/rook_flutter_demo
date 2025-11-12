import 'package:flutter/widgets.dart';

/// DISCLAIMER: This component was generated with the assistance of an AI tool.
/// Review for correctness, security, performance, and licensing before use.
class AnimatedVisibility extends StatelessWidget {
  const AnimatedVisibility({
    super.key,
    required this.isVisible,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
  });

  final bool isVisible;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      // Setting transitionBuilder is the key!
      transitionBuilder: (Widget child, Animation<double> animation) {
        // FadeTransition handles the fade in/out
        // SizeTransition handles the vertical expansion/shrink
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.vertical, // Ensures vertical expansion/shrink
            child: child,
          ),
        );
      },
      // The key is essential for AnimatedSwitcher to recognize
      // when the widget content changes (or disappears).
      // We use a different key for the visible and invisible states.
      child: isVisible
          ? KeyedSubtree(key: const ValueKey('visible'), child: child)
          : const SizedBox.shrink(key: ValueKey('invisible')),
    );
  }
}
