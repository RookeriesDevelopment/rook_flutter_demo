import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/theme/shapes.dart';

class ConnectionButton extends StatelessWidget {
  final bool enabled;
  final bool connected;
  final void Function() onConnect;
  final void Function() onDisconnect;

  const ConnectionButton({
    super.key,
    this.enabled = false,
    required this.connected,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(buttonShape),
        backgroundColor: enabled
            ? connected
                  ? WidgetStatePropertyAll(context.colorScheme.errorContainer)
                  : WidgetStatePropertyAll(Color(0xFFA0E984))
            : WidgetStatePropertyAll(context.colorScheme.outlineVariant),
        foregroundColor: enabled
            ? connected
                  ? WidgetStatePropertyAll(context.colorScheme.onErrorContainer)
                  : WidgetStatePropertyAll(Colors.black)
            : WidgetStatePropertyAll(context.colorScheme.outline),
      ),
      onPressed: enabled ? (connected ? onDisconnect : onConnect) : null,
      child: connected ? const Text('Disconnect') : const Text('Connect'),
    );
  }
}
