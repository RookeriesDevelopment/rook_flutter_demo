import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/theme/shapes.dart';
import 'package:rook_flutter_demo/core/presentation/widget/configurable.dart';

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
                      decoration: InputDecoration(
                        border: textFieldShape,
                        labelText: "Enter your userID",
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) {
                        print("submitted: $value");
                        context.pushReplacement("/connections", extra: true);
                      },
                    ),
                    SizedBox(height: 20),
                    FilledButton.icon(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(buttonShape),
                      ),
                      onPressed: () {
                        print("submitted: ${_userIDController.text}");
                      },
                      label: Text("Next"),
                      icon: Icon(Icons.arrow_forward),
                      iconAlignment: IconAlignment.end,
                    ),
                  ],
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
                child: SingleChildScrollView(
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
                        decoration: InputDecoration(
                          border: textFieldShape,
                          labelText: "Enter your userID",
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          print("submitted: $value");
                        },
                      ),
                      SizedBox(height: 20),
                      FilledButton.icon(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(buttonShape),
                        ),
                        onPressed: () {
                          print("submitted: ${_userIDController.text}");
                        },
                        label: Text("Next"),
                        icon: Icon(Icons.arrow_forward),
                        iconAlignment: IconAlignment.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
