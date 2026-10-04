import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tactix/core/theme/app_colors.dart';

class CrystalCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color? accentColor;
  final bool isHighlighted;
  final double blurAmount;
  final Color? customBackground;

  const CrystalCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.onTap,
    this.accentColor,
    this.isHighlighted = false,
    this.blurAmount = 10.0,
    this.customBackground,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = isHighlighted
        ? (accentColor ?? AppColors.cyan).withValues(alpha: 0.7)
        : (accentColor != null
            ? accentColor!.withValues(alpha: 0.35)
            : AppColors.crystalBorder);

    final cardContent = Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customBackground ?? AppColors.glassCard,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: isHighlighted ? 1.5 : 1.0,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.white.withValues(alpha: 0.02),
            (accentColor ?? AppColors.blue).withValues(alpha: 0.04),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
        boxShadow: [
          // Soft ambient crystal shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          if (isHighlighted || accentColor != null)
            BoxShadow(
              color: (accentColor ?? AppColors.cyan).withValues(
                alpha: isHighlighted ? 0.22 : 0.10,
              ),
              blurRadius: isHighlighted ? 22 : 12,
              spreadRadius: isHighlighted ? 1 : 0,
            ),
        ],
      ),
      child: child,
    );

    Widget result = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: cardContent,
      ),
    );

    if (margin != null) {
      result = Padding(padding: margin!, child: result);
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: (accentColor ?? AppColors.cyan).withValues(alpha: 0.15),
          highlightColor: (accentColor ?? AppColors.cyan).withValues(alpha: 0.08),
          child: result,
        ),
      );
    }

    return result;
  }
}
