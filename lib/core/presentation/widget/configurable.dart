import 'package:flutter/widgets.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';

class Configurable extends StatelessWidget {
  final Widget Function(BuildContext context) portraitBuilder;
  final Widget Function(BuildContext context) landscapeBuilder;

  const Configurable({
    super.key,
    required this.portraitBuilder,
    required this.landscapeBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return context.isPortrait
        ? portraitBuilder(context)
        : landscapeBuilder(context);
  }
}
