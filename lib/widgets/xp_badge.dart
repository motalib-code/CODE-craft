import 'package:flutter/material.dart';

class XPBadge extends StatelessWidget {
  const XPBadge({super.key, required this.xp, required this.badge});

  final int xp;
  final String badge;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$badge • $xp XP'));
  }
}
