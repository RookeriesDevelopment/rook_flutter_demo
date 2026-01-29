import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/main/domain/enum/AuthenticationStatus.dart';
import 'package:rook_flutter_demo/main/domain/model/main_state.dart';
import 'package:rook_flutter_demo/main/presentation/screen/main_cubit.dart';

class PostSplashScreen extends StatelessWidget {
  const PostSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MainCubit, MainState>(
        listener: (context, state) {
          switch (state.authenticationStatus) {
            case AuthenticationStatus.unknown:
              context.read<Logger>().d("Loading authentication status...");
            case AuthenticationStatus.authenticated:
              context.go("/home");
            case AuthenticationStatus.unauthenticated:
              context.go("/welcome");
          }
        },
        child: Container(
          padding: context.systemPadding + EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monitor_heart_rounded, size: 80),
              SizedBox(height: 32),
              LinearProgressIndicator(
                minHeight: 12,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
