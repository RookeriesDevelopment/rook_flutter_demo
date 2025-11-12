import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rook_flutter_demo/core/presentation/theme/theme.dart';
import 'package:rook_flutter_demo/core/presentation/theme/util.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/screen/connections_screen.dart';
import 'package:rook_flutter_demo/feature/login/presentation/screen/login_screen.dart';
import 'package:rook_flutter_demo/feature/welcome/presentation/screen/welcome_screen.dart';

void main() {
  runApp(const RookFlutterDemo());
}

class RookFlutterDemo extends StatelessWidget {
  const RookFlutterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Poppins", "Poppins");
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'RookFlutter',
      theme: brightness == Brightness.light
          ? materialTheme.light()
          : materialTheme.dark(),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: "/welcome",
  routes: [
    GoRoute(path: '/welcome', builder: (context, state) => WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(
      path: '/connections',
      builder: (context, state) => ConnectionsScreen(),
    ),
  ],
);
