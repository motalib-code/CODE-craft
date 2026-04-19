import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class VoiceButton extends StatelessWidget {
  final bool isListening;
  final VoidCallback onPressed;
  final double size;

  const VoiceButton({
    super.key,
    required this.isListening,
    required this.onPressed,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(size * 0.25),
        decoration: BoxDecoration(
          color: isListening ? Colors.red : AppColors.purple,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isListening)
              BoxShadow(
                color: Colors.red.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Icon(
          isListening ? Icons.mic : Icons.mic_none,
          color: Colors.white,
          size: size * 0.5,
        ),
      ),
    );
  }
}
