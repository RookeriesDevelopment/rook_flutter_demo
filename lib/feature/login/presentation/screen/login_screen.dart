import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/theme/shapes.dart';
import 'package:rook_flutter_demo/core/presentation/widget/configurable.dart';
import 'package:rook_flutter_demo/core/presentation/widget/next_button.dart';
import 'package:rook_flutter_demo/feature/login/domain/enum/login_error.dart';
import 'package:rook_flutter_demo/feature/login/domain/model/login_state.dart';
import 'package:rook_flutter_demo/feature/login/presentation/screen/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _userIDController;

  @override
  void initState() {
    super.initState();
    _userIDController = TextEditingController();
  }

  @override
  void dispose() {
    _userIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Configurable(
        portraitBuilder: (context) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Image.asset(
                "assets/images/png_login_background.png",
                fit: BoxFit.cover,
              ),
            ),
            Card(
              shape: bottomSheetShape,
              margin: EdgeInsets.zero,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    final error = state.error;

                    if (error != null) {
                      switch (error.type) {
                        case LoginErrorType.userInvalid:
                          context.showTextSnackBar("The userID is not valid");
                          break;
                        case LoginErrorType.custom:
                          context.showTextSnackBar(error.messageOrDefault);
                          break;
                      }
                    }

                    if (state.loggedIn) {
                      context.pushReplacement("/connections", extra: true);
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Get started",
                          style: context.typography.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        TextField(
                          controller: _userIDController,
                          enabled: !state.loading,
                          decoration: InputDecoration(
                            border: textFieldShape,
                            labelText: "Enter your userID",
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            context.read<LoginCubit>().onNextClick(value);
                          },
                        ),
                        SizedBox(height: 20),
                        NextTextButton(
                          enabled: !state.loading,
                          onClick: () {
                            context.read<LoginCubit>().onNextClick(
                              _userIDController.text,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        landscapeBuilder: (context) => Row(
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/png_login_background.png",
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.only(right: context.systemPadding.right) +
                    EdgeInsets.all(20),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    final error = state.error;

                    if (error != null) {
                      switch (error.type) {
                        case LoginErrorType.userInvalid:
                          context.showTextSnackBar("The userID is not valid");
                          break;
                        case LoginErrorType.custom:
                          context.showTextSnackBar(error.messageOrDefault);
                          break;
                      }
                    }

                    if (state.loggedIn) {
                      context.pushReplacement("/connections", extra: true);
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Get started",
                            style: context.typography.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 24),
                          TextField(
                            controller: _userIDController,
                            enabled: !state.loading,
                            decoration: InputDecoration(
                              border: textFieldShape,
                              labelText: "Enter your userID",
                            ),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) {
                              context.read<LoginCubit>().onNextClick(value);
                            },
                          ),
                          SizedBox(height: 20),
                          NextTextButton(
                            enabled: !state.loading,
                            onClick: () {
                              context.read<LoginCubit>().onNextClick(
                                _userIDController.text,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
