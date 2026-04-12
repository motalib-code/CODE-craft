import 'package:flutter/material.dart';

class CoinBadge extends StatelessWidget {
  final int coins;
  final bool large;

  const CoinBadge({super.key, required this.coins, this.large = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 14 : 10,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x33F59E0B), Color(0x1AF59E0B)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x44F59E0B)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🪙', style: TextStyle(fontSize: large ? 16 : 12)),
          const SizedBox(width: 4),
          Text(
            '$coins',
            style: TextStyle(
              color: const Color(0xFFF59E0B),
              fontSize: large ? 16 : 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
