import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final void Function() onClick;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    this.color,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              title,
              style: context.typography.bodyLarge?.copyWith(
                color: color ?? context.colorScheme.onSurface,
              ),
            ),
            Spacer(),
            Icon(icon, color: color),
          ],
        ),
      ),
    );
  }
}
