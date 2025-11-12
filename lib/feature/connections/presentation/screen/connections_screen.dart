import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/animated_visibility.dart';
import 'package:rook_flutter_demo/core/presentation/widget/next_button.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/widget/connection_button.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final showNextButton = GoRouterState.of(context).extra as bool? ?? true;

    return Scaffold(
      body: Container(
        color: context.colorScheme.surface,
        padding:
            context.systemPadding +
            EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Column(
          children: [
            Text(
              "Get the value of your data",
              style: context.typography.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            AnimatedVisibility(
              isVisible: _visible,
              duration: const Duration(milliseconds: 300),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(4),
                child: CircularProgressIndicator(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.apple),
              title: Text("Oura"),
              trailing: ConnectionButton(
                enabled: true,
                connected: true,
                onConnect: () {},
                onDisconnect: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
              ),
            ),
            if (showNextButton) SizedBox(height: 16),
            if (showNextButton)
              Container(
                alignment: Alignment.centerRight,
                child: NextButton(onClick: () {}),
              ),
            if (showNextButton) SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
