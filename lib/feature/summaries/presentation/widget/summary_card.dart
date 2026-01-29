import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/theme/shapes.dart';

class SummaryCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String value;

  const SummaryCard({super.key, required this.width, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 3,
        shape: cardShape,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: context.colorScheme.onSurface),
              SizedBox(height: 8),
              Text(value),
            ],
          ),
        ),
      ),
    );
  }
}
