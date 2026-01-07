import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/feature/connections/domain/model/connection.dart';
import 'package:rook_flutter_demo/feature/connections/presentation/widget/connection_button.dart';

class HealthKitConnectionTile extends StatelessWidget {
  final ConnectionHealthKit connection;
  final bool loading;
  final void Function() onConnect;
  final void Function() onDisconnect;

  const HealthKitConnectionTile({
    super.key,
    required this.connection,
    required this.loading,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipOval(
        child: Image.asset(connection.iconName, width: 40, height: 40),
      ),
      title: Text(connection.name),
      trailing: ConnectionButton(
        enabled: !loading,
        connected: connection.connected,
        onConnect: onConnect,
        onDisconnect: onDisconnect,
      ),
    );
  }
}
