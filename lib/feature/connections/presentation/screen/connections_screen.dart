import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/animated_visibility.dart';
import 'package:rook_flutter_demo/core/presentation/widget/next_button.dart';
import 'package:rook_flutter_demo/feature/connections/domain/enum/health_kit_type.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connection_status.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connections_state.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/disconnection_status.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/screen/connections_cubit.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/widget/api_connection_tile.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/widget/health_kit_connection_tile.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  @override
  Widget build(BuildContext context) {
    final showNextButton = GoRouterState.of(context).extra as bool? ?? true;

    return Scaffold(
      body: Container(
        color: context.colorScheme.surface,
        padding: context.systemPadding + EdgeInsets.only(top: 16),
        child: BlocConsumer<ConnectionsCubit, ConnectionsState>(
          listener: (context, state) {
            switch (state.connectionStatus) {
              case UnknownConnectionStatus():
                context.read<Logger>().d("UnknownConnectionStatus");
                break;
              case AlreadyConnected():
                context.showTextSnackBar(
                  "This data source is already connected, refreshing…",
                );
                break;
              case HealthKitConnectionRequest(type: final type):
                _processHealthKitConnectionRequest(type);
                break;
              case ConnectionError(message: final message):
                context.showTextSnackBar(message);
                break;
            }

            switch (state.disconnectionStatus) {
              case UnknownDisconnectionStatus():
                context.read<Logger>().d("UnknownDisconnectionStatus");
                break;
              case Disconnected():
                context.showTextSnackBar("Data source disconnected!");
                break;
              case DisconnectionNotSupported():
                context.showTextSnackBar(
                  "This data source can only be disconnected from it's web page.",
                );
                break;
              case DisconnectionError(message: String message):
                context.showTextSnackBar(message);
                break;
            }

            if (state.connectionStatus is! UnknownConnectionStatus) {
              context.read<ConnectionsCubit>().onConnectionStatusDisplayed();
            }

            if (state.disconnectionStatus is! UnknownDisconnectionStatus) {
              context.read<ConnectionsCubit>().onDisconnectionStatusDisplayed();
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ConnectionsCubit>().onConnectionsRefresh();
              },
              child: SingleChildScrollView(
                clipBehavior: Clip.antiAlias,
                physics: const AlwaysScrollableScrollPhysics(),
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
                      isVisible: state.loadingHK || state.loadingApi,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    if (state.errorHK)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "One or more Health Kits could not be loaded, try again.",
                        ),
                      ),
                    Column(
                      children: [
                        for (final connection in state.connectionsHK)
                          HealthKitConnectionTile(
                            connection: connection,
                            loading: state.loadingHK,
                            onConnect: () {
                              context.read<ConnectionsCubit>().onConnectClick(
                                connection,
                              );
                            },
                            onDisconnect: () {
                              context
                                  .read<ConnectionsCubit>()
                                  .onDisconnectClick(connection);
                            },
                          ),
                      ],
                    ),
                    if (state.errorApi)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          "Error loading API data sources, try again.",
                        ),
                      ),
                    Column(
                      children: [
                        for (final connection in state.connectionsApi)
                          ApiConnectionTile(
                            connection: connection,
                            loading: state.loadingApi,
                            onConnect: () {
                              context.read<ConnectionsCubit>().onConnectClick(
                                connection,
                              );
                            },
                            onDisconnect: () {
                              context
                                  .read<ConnectionsCubit>()
                                  .onDisconnectClick(connection);
                            },
                          ),
                      ],
                    ),
                    if (showNextButton) SizedBox(height: 16),
                    if (showNextButton)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerRight,
                        child: NextButton(onClick: () {}),
                      ),
                    if (showNextButton) SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _processHealthKitConnectionRequest(HealthKitType type) {
    final navigation = switch (type) {
      HealthKitType.appleHealth => context.push("/connections/apple-health"),
      HealthKitType.healthConnect => context.push(
        "/connections/health-connect",
      ),
      HealthKitType.samsungHealth => context.push(
        "/connections/samsung-health",
      ),
      HealthKitType.androidSteps => context.push("/connections/android-steps"),
    };

    navigation.then((_) {
      final context = this.context;

      if (!context.mounted) {
        return;
      }

      context.read<Logger>().i("Navigation completed, refreshing…");
      context.read<ConnectionsCubit>().onConnectionsRefresh(
        onlyHealthKits: true,
      );
    });
  }
}
