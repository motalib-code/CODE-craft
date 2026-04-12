import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final bool small;
  final bool loading;
  final bool disabled;
  final IconData? icon;
  final Gradient? gradient;
  final double? width;

  const GradientButton({
    super.key,
    required this.label,
    this.onTap,
    this.small = false,
    this.loading = false,
    this.disabled = false,
    this.icon,
    this.gradient,
    this.width,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.disabled || widget.loading;
    return GestureDetector(
      onTapDown: (_) {
        if (!isDisabled) _ctrl.forward();
      },
      onTapUp: (_) {
        _ctrl.reverse();
        if (!isDisabled) widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.width,
          padding: EdgeInsets.symmetric(
            horizontal: widget.small ? 16 : 24,
            vertical: widget.small ? 10 : 14,
          ),
          decoration: BoxDecoration(
            gradient: isDisabled
                ? const LinearGradient(
                    colors: [Color(0xFF475569), Color(0xFF334155)])
                : (widget.gradient ?? AppColors.gradPurpleBlue),
            borderRadius: BorderRadius.circular(14),
            boxShadow: isDisabled
                ? []
                : [
                    BoxShadow(
                      color: AppColors.purple.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: widget.loading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon,
                          color: Colors.white,
                          size: widget.small ? 14 : 18),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      widget.label,
                      style:
                          widget.small ? AppTextStyles.btnSm : AppTextStyles.btn,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
