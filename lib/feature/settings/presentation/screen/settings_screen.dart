import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/animated_visibility.dart';
import 'package:rook_flutter_demo/feature/settings/domain/enum/logout_status.dart';
import 'package:rook_flutter_demo/feature/settings/domain/model/settings_state.dart';
import 'package:rook_flutter_demo/feature/settings/presentation/screen/settings_cubit.dart';
import 'package:rook_flutter_demo/feature/settings/presentation/widget/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: context.systemPadding + EdgeInsets.only(top: 16, left: 16, right: 16),
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (context, state) {
            switch (state.logoutStatus) {
              case LogoutStatus.unknown:
                context.read<Logger>().d("LogoutStatus.unknown");
                break;
              case LogoutStatus.error:
                context.showTextSnackBar("Error logging out, try again");
                break;
              case LogoutStatus.loggedOut:
                context.showTextSnackBar("Good bye!");
                context.pushReplacement("/welcome");
                break;
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                AnimatedVisibility(
                  isVisible: state.loggingOut,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4),
                    child: CircularProgressIndicator(),
                  ),
                ),
                SettingsTile(
                  title: "Manage Connections",
                  icon: Icons.chevron_right_rounded,
                  onClick: () {
                    context.push("/connections", extra: false);
                  },
                ),
                Divider(),
                SettingsTile(
                  title: "Log out",
                  icon: Icons.logout_outlined,
                  color: context.colorScheme.error,
                  onClick: () {
                    context.read<SettingsCubit>().onLogOutClick();
                  },
                ),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
