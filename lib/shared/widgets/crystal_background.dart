import 'package:flutter/material.dart';
import 'package:tactix/core/theme/app_colors.dart';

class CrystalBackground extends StatelessWidget {
  final Widget child;

  const CrystalBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A101D),
            Color(0xFF070B14),
            Color(0xFF05080F),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Subtle top-left crystal cyan ambient glow
          Positioned(
            top: -60,
            left: -40,
            child: IgnorePointer(
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: 0.12),
                      AppColors.cyan.withValues(alpha: 0.03),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Subtle mid-right crystal violet/amber glow
          Positioned(
            top: 240,
            right: -60,
            child: IgnorePointer(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.violet.withValues(alpha: 0.08),
                      AppColors.amber.withValues(alpha: 0.02),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Subtle bottom-left emerald glow
          Positioned(
            bottom: -50,
            left: 20,
            child: IgnorePointer(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.emerald.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
          ),

          // Foreground content
          child,
        ],
      ),
    );
  }
}
