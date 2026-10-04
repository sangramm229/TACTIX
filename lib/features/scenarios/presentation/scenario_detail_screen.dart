import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/features/scenarios/providers/scenario_library_provider.dart';
import 'package:tactix/shared/components/degraded_signal_badge.dart';
import 'package:tactix/shared/widgets/app_bar_header.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';
import 'package:tactix/shared/widgets/mission_objective_card.dart';
import 'package:tactix/shared/widgets/tactix_button.dart';

class ScenarioDetailScreen extends ConsumerWidget {
  final String scenarioId;

  const ScenarioDetailScreen({
    super.key,
    required this.scenarioId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenario = ref.watch(scenarioDetailProvider(scenarioId));

    if (scenario == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const AppBarHeader(
          title: 'SCENARIO DETAILS',
          showBack: true,
        ),
        body: Center(
          child: Text(
            'Scenario not found: $scenarioId',
            style: AppTypography.bodyMedium,
          ),
        ),
      );
    }

    final diffColor = AppColors.getDifficultyColor(scenario.difficulty);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarHeader(
        title: scenario.code,
        subtitle: '${scenario.sector.toUpperCase()} • ${scenario.category.toUpperCase()}',
        showBack: true,
      ),
      body: CrystalBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tags: Sector, Difficulty, Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: diffColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: diffColor.withValues(alpha: 0.6)),
                          ),
                          child: Text(
                            'DIFFICULTY: ${scenario.difficulty.label}',
                            style: AppTypography.badge.copyWith(
                              color: diffColor,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: AppColors.crystalBorder),
                          ),
                          child: Text(
                            scenario.sector.toUpperCase(),
                            style: AppTypography.badge.copyWith(
                              color: AppColors.cyan,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 14, color: AppColors.cyan),
                        const SizedBox(width: 4),
                        Text(
                          '${scenario.durationMinutes} MIN EST.',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.cyan,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  scenario.title,
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scenario.category,
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),

                const SizedBox(height: 16),

                // Mission Specs Pill Strip
                CrystalCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpecItem('EST. TIME',
                          '${scenario.durationMinutes} min', Icons.schedule),
                      Container(
                          width: 1, height: 26, color: AppColors.crystalBorder),
                      _buildSpecItem(
                          'DECISIONS',
                          '${scenario.decisionCount} checkpoints',
                          Icons.alt_route),
                      Container(
                          width: 1, height: 26, color: AppColors.crystalBorder),
                      _buildSpecItem(
                          'CHANNELS',
                          '${scenario.channelConditions.length} active',
                          Icons.cell_tower),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SITUATION BRIEFING SECTION
                _buildSectionHeader('SITUATION BRIEFING', Icons.info_outline),
                const SizedBox(height: 8),
                CrystalCard(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    scenario.situationBriefing,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // MISSION OBJECTIVES SECTION
                _buildSectionHeader('MISSION OBJECTIVES', Icons.flag_outlined),
                const SizedBox(height: 8),
                ...scenario.objectives
                    .map((obj) => MissionObjectiveCard(objective: obj)),

                const SizedBox(height: 16),

                // COMMUNICATION CONDITIONS & DEGRADATION MATRIX
                _buildSectionHeader(
                    'COMMUNICATION CONDITIONS & DEGRADATION MATRIX',
                    Icons.sensors),
                const SizedBox(height: 6),
                Text(
                  'Diagnostic telemetry profile indicates the following degraded channel states:',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                ...scenario.channelConditions.map((cond) =>
                    CommunicationConditionTile(condition: cond)),

                const SizedBox(height: 20),

                // AVAILABLE RESOURCES SECTION
                _buildSectionHeader(
                    'DEPLOYABLE RESOURCES', Icons.inventory_2_outlined),
                const SizedBox(height: 8),
                CrystalCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: scenario.availableResources.map((res) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_right,
                                size: 18, color: AppColors.cyan),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                res,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // RULES OF ENGAGEMENT
                _buildSectionHeader(
                    'RULES OF ENGAGEMENT & PROTOCOLS', Icons.gavel_outlined),
                const SizedBox(height: 8),
                CrystalCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: scenario.rulesOfEngagement.map((rule) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.shield_outlined,
                                size: 14, color: AppColors.amber),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                rule,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // START SIMULATION BUTTON
                TactixButton(
                  label: 'LAUNCH SIMULATION DRILL',
                  icon: Icons.play_arrow_rounded,
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    _showPreBriefingModal(context, scenario);
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.amber),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.monoSmall.copyWith(
            color: AppColors.amber,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.cyan),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.monoSmall.copyWith(
            color: AppColors.textTertiary,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.monoSmall.copyWith(
            color: AppColors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _showPreBriefingModal(BuildContext context, dynamic scenario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppColors.crystalBorder, width: 1.5),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PRE-SIMULATION BRIEFING',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.amber,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          size: 20, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Review mission objectives before engaging. The mission countdown clock and telemetry degradation injectors will activate immediately upon confirmation.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.crystalBorder),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mission Target:',
                              style: AppTypography.monoSmall),
                          Text(scenario.title,
                              style: AppTypography.monoSmall.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Session Timer:',
                              style: AppTypography.monoSmall),
                          Text('${scenario.durationMinutes}:00',
                              style: AppTypography.monoSmall.copyWith(
                                  color: AppColors.amber,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Degradation Profile:',
                              style: AppTypography.monoSmall),
                          Text('ACTIVE INJECTION',
                              style: AppTypography.monoSmall.copyWith(
                                  color: AppColors.crimson,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TactixButton(
                  label: 'COMMENCE MISSION SIMULATION',
                  icon: Icons.play_arrow_rounded,
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push(AppRoutes.simulationPath(scenario.id));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
