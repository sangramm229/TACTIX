import 'package:flutter/material.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';

class TrainingProgressCard extends StatelessWidget {
  final int completedScenarios;
  final int totalScenarios;
  final double averageResponseSeconds;
  final int decisionPerformancePercentage;

  const TrainingProgressCard({
    super.key,
    required this.completedScenarios,
    required this.totalScenarios,
    required this.averageResponseSeconds,
    required this.decisionPerformancePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final progress =
        totalScenarios > 0 ? (completedScenarios / totalScenarios) : 0.0;

    return CrystalCard(
      accentColor: AppColors.cyan,
      isHighlighted: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.cyan,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan,
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'OPERATOR READINESS INDEX',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.cyan,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: AppColors.emerald.withValues(alpha: 0.4)),
                ),
                child: Text(
                  'COMMAND READY',
                  style: AppTypography.badge.copyWith(
                    color: AppColors.emerald,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$completedScenarios of $totalScenarios Drills Qualified',
                      style: AppTypography.headlineSmall.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Multi-sector incident command qualification',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 28,
                  color: AppColors.amber,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Liquid Progress bar with glowing gradient
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
              ),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.borderMuted),
          const SizedBox(height: 14),

          // Sub-metrics row: Average Response & Decision Performance
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DECISION LATENCY',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          averageResponseSeconds.toStringAsFixed(1),
                          style: AppTypography.monoLarge.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.cyan,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'sec',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Target: <20s under stress',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 42,
                color: AppColors.crystalBorder,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TACTICAL ACCURACY',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$decisionPerformancePercentage%',
                          style: AppTypography.monoLarge.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.emerald,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Grade: Superior',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
