import 'package:flutter/material.dart';
import '../models/dsa_pattern.dart';

class PatternCard extends StatelessWidget {
  const PatternCard({super.key, required this.pattern});

  final DSAPattern pattern;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(pattern.name),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(pattern.whenToUse),
        )
      ],
    );
  }
}
