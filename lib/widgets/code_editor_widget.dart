import 'package:flutter/material.dart';

class CodeEditorWidget extends StatelessWidget {
  const CodeEditorWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
