import 'package:flutter/material.dart';
import 'package:tactix/core/constants/app_enums.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/data/models/scenario_summary.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';

class MissionObjectiveCard extends StatelessWidget {
  final ObjectiveItem objective;

  const MissionObjectiveCard({
    super.key,
    required this.objective,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor;
    IconData iconData;

    switch (objective.type) {
      case ObjectiveType.primary:
        typeColor = AppColors.amber;
        iconData = Icons.flag_rounded;
        break;
      case ObjectiveType.secondary:
        typeColor = AppColors.cyan;
        iconData = Icons.adjust_rounded;
        break;
      case ObjectiveType.contingency:
        typeColor = AppColors.violet;
        iconData = Icons.alt_route_rounded;
        break;
    }

    return CrystalCard(
      margin: const EdgeInsets.only(bottom: 12),
      accentColor: typeColor,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconData, size: 14, color: typeColor),
              const SizedBox(width: 8),
              Text(
                objective.type.label,
                style: AppTypography.badge.copyWith(
                  color: typeColor,
                  fontSize: 10,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            objective.title,
            style: AppTypography.headlineSmall.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            objective.description,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
