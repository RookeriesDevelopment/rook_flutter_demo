import 'package:flutter/material.dart';
import 'package:rook_flutter_demo/core/presentation/extension/build_context_extensions.dart';
import 'package:rook_flutter_demo/core/presentation/widget/animated_visibility.dart';

class DataTypesContent extends StatelessWidget {
  final bool expanded;
  final List<String> dataTypes;

  const DataTypesContent({super.key, required this.expanded, required this.dataTypes});

  @override
  Widget build(BuildContext context) {
    return AnimatedVisibility(
      isVisible: expanded,
      child: Column(
        children: [
          for (final dataType in dataTypes)
            Container(
              padding: const EdgeInsets.only(bottom: 4),
              width: double.infinity,
              child: Text(
                dataType,
                textAlign: TextAlign.center,
                style: context.typography.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
