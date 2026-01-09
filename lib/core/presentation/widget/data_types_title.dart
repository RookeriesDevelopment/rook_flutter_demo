import 'package:flutter/material.dart';

class DataTypesTitle extends StatelessWidget {
  final bool showCheck;
  final String text;
  final bool expanded;
  final void Function() onClick;

  const DataTypesTitle({
    super.key,
    required this.showCheck,
    required this.text,
    required this.expanded,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      child: Row(
        children: [
          if (showCheck) Icon(Icons.check_sharp),
          if (showCheck) SizedBox(width: 8),
          Expanded(child: Text(text)),
          if (expanded) Icon(Icons.keyboard_arrow_up_sharp),
          if (!expanded) Icon(Icons.keyboard_arrow_down_sharp),
        ],
      ),
    );
  }
}
