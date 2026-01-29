import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:receive_intent/receive_intent.dart';
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
import 'package:rook_flutter_demo/feature/privacy/presentation/screen/privacy_policy_screen.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/presentation/screen/samsung_health_cubit.dart';
import 'package:rook_flutter_demo/feature/samsunghealth/presentation/screen/samsung_health_screen.dart';
import 'package:rook_flutter_demo/feature/welcome/presentation/screen/welcome_screen.dart';
import 'package:rook_flutter_demo/main/presentation/screen/main_cubit.dart';
import 'package:rook_flutter_demo/rook/repository/rook_apple_health_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_health_connect_repository.dart';
import 'package:rook_flutter_demo/rook/repository/rook_samsung_health_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  startBackgroundSync();

  runApp(const DemoApp());
}

void startBackgroundSync() {
  final preferences = DefaultAppPreferences();
  final logger = Logger();

  preferences
      .isHealthConnectEnabled()
      .then((healthConnectEnabled) async {
        final available = await RookHealthConnectRepository.isCompatibleWithCurrentPlatform();

        if (!available) {
          logger.i("Health Connect is not available on this device.");
          return;
        }

        if (healthConnectEnabled) {
          logger.i("Starting Health Connect background sync...");
          await RookHealthConnectRepository.enableBackground(kDebugMode);
        }
      })
      .catchError((error) {
        logger.e("Failed to start Health Connect background sync: $error");
      });

  preferences
      .isSamsungHealthEnabled()
      .then((samsungHealthEnabled) async {
        final available = await RookSamsungHealthRepository.isCompatibleWithCurrentPlatform();

        if (!available) {
          logger.i("Samsung Health is not available on this device.");
          return;
        }

        if (samsungHealthEnabled) {
          logger.i("Starting Samsung Health background sync...");
          RookSamsungHealthRepository.enableBackground(kDebugMode);
        }
      })
      .catchError((error) {
        logger.e("Failed to start Samsung Health background sync: $error");
      });

  preferences
      .isAppleHealthEnabled()
      .then((appleHealthEnabled) async {
        final available = await RookAppleHealthRepository.isCompatibleWithCurrentPlatform();

        if (!available) {
          logger.i("Apple Health is not available on this device.");
          return;
        }

        if (appleHealthEnabled) {
          logger.i("Starting Apple Health background sync...");
          RookAppleHealthRepository.enableBackground(kDebugMode);
        }
      })
      .catchError((error) {
        logger.e("Failed to start Apple Health background sync: $error");
      });
}

class DemoApp extends StatefulWidget {
  const DemoApp({super.key});

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  @override
  void initState() {
    super.initState();

    _handleIntent();
  }

  Future<void> _handleIntent() async {
    final receivedIntent = await ReceiveIntent.getInitialIntent();
    final action = receivedIntent?.action;

    if (action == _healthConnectAction || action == _healthConnectActionAndroid14) {
      _router.go("/privacy");
    }
  }

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
          routerConfig: _router,
        ),
      ),
    );
  }
}

final _router = GoRouter(
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
    GoRoute(path: '/privacy', builder: (context, state) => PrivacyPolicyScreen()),
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
);

const String _healthConnectAction = 'androidx.health.ACTION_SHOW_PERMISSIONS_RATIONALE';
const String _healthConnectActionAndroid14 = 'android.intent.action.VIEW_PERMISSION_USAGE';
