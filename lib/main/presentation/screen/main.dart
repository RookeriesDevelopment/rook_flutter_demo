import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:rook_flutter_demo/core/data/preferences/default_app_preferences.dart';
import 'package:rook_flutter_demo/core/data/repository/default_auth_repository.dart';
import 'package:rook_flutter_demo/core/domain/preferences/app_preferences.dart';
import 'package:rook_flutter_demo/core/domain/repository/auth_repository.dart';
import 'package:rook_flutter_demo/core/presentation/theme/theme.dart';
import 'package:rook_flutter_demo/core/presentation/theme/util.dart';
import 'package:rook_flutter_demo/feature/androidsteps/presentation/screen/android_steps_cubit.dart';
import 'package:rook_flutter_demo/feature/androidsteps/presentation/screen/android_steps_screen.dart';
import 'package:rook_flutter_demo/feature/applehealth/presentation/screen/apple_health_cubit.dart';
import 'package:rook_flutter_demo/feature/applehealth/presentation/screen/apple_health_screen.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/screen/connections_cubit.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/screen/connections_screen.dart';
import 'package:rook_flutter_demo/feature/healthconnect/presentation/screen/health_connect_cubit.dart';
import 'package:rook_flutter_demo/feature/healthconnect/presentation/screen/health_connect_screen.dart';
import 'package:rook_flutter_demo/feature/login/presentation/screen/login_cubit.dart';
import 'package:rook_flutter_demo/feature/login/presentation/screen/login_screen.dart';
import 'package:rook_flutter_demo/feature/postsplash/presentation/screen/post_splash_screen.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/presentation/screen/samsung_health_cubit.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/presentation/screen/samsung_health_screen.dart';
import 'package:rook_flutter_demo/feature/welcome/presentation/screen/welcome_screen.dart';
import 'package:rook_flutter_demo/main/presentation/screen/main_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Poppins", "Poppins");
    final materialTheme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: [
        Provider<Logger>(create: (context) => Logger()),
        Provider<AppPreferences>(create: (context) => DefaultAppPreferences()),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(create: (context) => DefaultAuthRepository()),
        ],
        child: MaterialApp.router(
          title: 'DemoApp',
          theme: brightness == Brightness.light ? materialTheme.light() : materialTheme.dark(),
          routerConfig: GoRouter(
            initialLocation: "/",
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => BlocProvider<MainCubit>(
                  create: (context) {
                    return MainCubit(
                      logger: context.read<Logger>(),
                      authRepository: context.read<AuthRepository>(),
                    );
                  },
                  child: PostSplashScreen(),
                ),
              ),
              GoRoute(path: '/welcome', builder: (context, state) => WelcomeScreen()),
              GoRoute(
                path: '/login',
                builder: (context, state) => BlocProvider(
                  create: (context) {
                    return LoginCubit(
                      logger: context.read<Logger>(),
                      authRepository: context.read<AuthRepository>(),
                    );
                  },
                  child: LoginScreen(),
                ),
              ),
              GoRoute(
                path: '/connections',
                builder: (context, state) => BlocProvider(
                  create: (context) {
                    return ConnectionsCubit(preferences: context.read<AppPreferences>());
                  },
                  child: ConnectionsScreen(),
                ),
              ),
              GoRoute(
                path: '/connections/android-steps',
                builder: (context, state) => BlocProvider(
                  create: (context) {
                    return AndroidStepsCubit();
                  },
                  child: AndroidStepsScreen(),
                ),
              ),
              GoRoute(
                path: '/connections/health-connect',
                builder: (context, state) => BlocProvider(
                  create: (context) {
                    return HealthConnectCubit(preferences: context.read<AppPreferences>());
                  },
                  child: HealthConnectScreen(),
                ),
              ),
              GoRoute(
                path: '/connections/samsung-health',
                builder: (context, state) => BlocProvider(
                  create: (context) {
                    return SamsungHealthCubit(preferences: context.read<AppPreferences>());
                  },
                  child: SamsungHealthScreen(),
                ),
              ),
              GoRoute(
                path: '/connections/apple-health',
                builder: (context, state) => BlocProvider(
                  create: (context) {
                    return AppleHealthCubit(
                      preferences: context.read<AppPreferences>(),
                      logger: context.read<Logger>(),
                    );
                  },
                  child: AppleHealthScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
