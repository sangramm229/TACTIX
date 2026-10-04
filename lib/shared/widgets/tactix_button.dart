import 'package:flutter/material.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';

enum ButtonVariant { primary, secondary, danger, outline }

class TactixButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool isFullWidth;
  final bool isLoading;

  const TactixButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.isFullWidth = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Gradient? bgGradient;
    Color bg;
    Color fg;
    Color border;
    List<BoxShadow>? shadows;

    switch (variant) {
      case ButtonVariant.primary:
        bg = AppColors.amber;
        bgGradient = const LinearGradient(
          colors: [Color(0xFFFFC043), Color(0xFFFF9E00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        fg = const Color(0xFF070B14);
        border = const Color(0xFFFFD580).withValues(alpha: 0.6);
        shadows = onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.amber.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null;
        break;
      case ButtonVariant.secondary:
        bg = AppColors.glassCard;
        bgGradient = LinearGradient(
          colors: [
            AppColors.cyan.withValues(alpha: 0.18),
            AppColors.glassElevated,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        fg = AppColors.cyan;
        border = AppColors.cyan.withValues(alpha: 0.5);
        shadows = onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ]
            : null;
        break;
      case ButtonVariant.danger:
        bg = AppColors.crimson;
        bgGradient = const LinearGradient(
          colors: [Color(0xFFFF5277), Color(0xFFE11D48)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        fg = Colors.white;
        border = Colors.white.withValues(alpha: 0.4);
        shadows = onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.crimson.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null;
        break;
      case ButtonVariant.outline:
        bg = Colors.transparent;
        fg = AppColors.textPrimary;
        border = AppColors.crystalBorder;
        shadows = null;
        break;
    }

    final buttonChild = InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: onPressed == null ? AppColors.surfaceVariant : bg,
          gradient: onPressed == null ? null : bgGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onPressed == null ? AppColors.borderMuted : border,
            width: 1.2,
          ),
          boxShadow: shadows,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: fg,
                ),
              )
            else if (icon != null) ...[
              Icon(icon, size: 18, color: onPressed == null ? AppColors.textTertiary : fg),
              const SizedBox(width: 8),
            ],
            Text(
              label.toUpperCase(),
              style: AppTypography.displaySmall.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: onPressed == null ? AppColors.textTertiary : fg,
              ),
            ),
          ],
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: buttonChild,
      );
    }
    return buttonChild;
  }
}
