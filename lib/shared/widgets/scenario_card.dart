import 'package:flutter/material.dart';
import 'package:tactix/core/constants/app_enums.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/data/models/scenario_summary.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';
import 'package:tactix/shared/widgets/status_indicator.dart';
import 'package:tactix/shared/widgets/tactix_button.dart';

class ScenarioCard extends StatelessWidget {
  final ScenarioSummary scenario;
  final VoidCallback onViewScenario;
  final bool isHighlighted;

  const ScenarioCard({
    super.key,
    required this.scenario,
    required this.onViewScenario,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final diffColor = AppColors.getDifficultyColor(scenario.difficulty);

    return CrystalCard(
      margin: const EdgeInsets.only(bottom: 16),
      isHighlighted: isHighlighted,
      accentColor: isHighlighted ? AppColors.amber : AppColors.blue,
      onTap: onViewScenario,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header: Code, Sector, Difficulty, Score/Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.cyan.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      scenario.code,
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.crystalBorder),
                    ),
                    child: Text(
                      scenario.sector.toUpperCase(),
                      style: AppTypography.badge.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: diffColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: diffColor.withValues(alpha: 0.5)),
                    ),
                    child: Text(
                      scenario.difficulty.label,
                      style: AppTypography.badge.copyWith(
                        color: diffColor,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
              if (scenario.status == ScenarioStatus.completed)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.emerald.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 12, color: AppColors.emerald),
                      const SizedBox(width: 4),
                      Text(
                        'COMPLETED',
                        style: AppTypography.badge.copyWith(
                          color: AppColors.emerald,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                )
              else if (scenario.bestScore != null)
                Text(
                  'Best: ${(scenario.bestScore! * 100).toInt()}%',
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.amber,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Scenario Title
          Text(
            scenario.title,
            style: AppTypography.headlineSmall.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            scenario.category,
            style: AppTypography.monoSmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11,
            ),
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            scenario.description,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Operational Meta specs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.crystalBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer_outlined,
                        size: 14, color: AppColors.cyan),
                    const SizedBox(width: 6),
                    Text(
                      '${scenario.durationMinutes} min runtime',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 14,
                  color: AppColors.crystalBorder,
                ),
                Row(
                  children: [
                    const Icon(Icons.alt_route,
                        size: 14, color: AppColors.amber),
                    const SizedBox(width: 6),
                    Text(
                      '${scenario.decisionCount} checkpoints',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Degradation tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: scenario.degradationTypes.map((type) {
              return StatusIndicator(type: type, compact: true);
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Button
          TactixButton(
            label: isHighlighted ? 'START RECOMMENDED SIMULATION' : 'VIEW SCENARIO DETAILS',
            icon: Icons.play_arrow_rounded,
            variant: isHighlighted ? ButtonVariant.primary : ButtonVariant.secondary,
            onPressed: onViewScenario,
          ),
        ],
      ),
    );
  }
}
