import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/core/utils/formatters.dart';
import 'package:tactix/data/models/simulation_models.dart';
import 'package:tactix/features/scenarios/providers/scenario_library_provider.dart';
import 'package:tactix/shared/widgets/app_bar_header.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';
import 'package:tactix/shared/widgets/tactix_button.dart';

class ReportScreen extends ConsumerWidget {
  final String sessionId;

  const ReportScreen({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeResult = ref.watch(lastSessionResultProvider);
    final repo = ref.watch(scenarioRepositoryProvider);

    // If active result matches sessionId or is present, use it; otherwise fallback to historical mock
    final sessionResult = activeResult ?? repo.getSessionResult(sessionId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarHeader(
        title: 'AFTER-ACTION REPORT',
        subtitle: 'INCIDENT AUDIT: ${sessionResult.scenarioCode}',
        showBack: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.surfaceElevated,
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: AppColors.emerald, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Audit report exported to PDF (Compliance ISO 22301)',
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded,
                color: AppColors.cyan, size: 20),
            tooltip: 'Export Audit Report',
          ),
        ],
      ),
      body: CrystalBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Performance Hero Card
                _buildHeroCard(sessionResult),

                const SizedBox(height: 16),

                // Competency Radar Progress Breakdown
                _buildCompetencyCard(sessionResult),

                const SizedBox(height: 18),

                // Chronological Decision Timeline
                _buildSectionTitle('CHRONOLOGICAL DECISION TIMELINE',
                    Icons.timeline_rounded, AppColors.cyan),
                const SizedBox(height: 10),
                ...sessionResult.decisions
                    .map((d) => _buildDecisionTimelineTile(d)),

                const SizedBox(height: 18),

                // AI Incident Commander Debrief
                _buildSectionTitle('AI INCIDENT COMMAND DEBRIEF',
                    Icons.psychology_outlined, AppColors.amber),
                const SizedBox(height: 10),
                _buildDebriefCard(sessionResult),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TactixButton(
                        label: 'RETAKE DRILL',
                        icon: Icons.replay,
                        variant: ButtonVariant.secondary,
                        onPressed: () {
                          context.push(AppRoutes.simulationPath(
                              sessionResult.scenarioId));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TactixButton(
                        label: 'COMMAND CENTER',
                        icon: Icons.dashboard,
                        variant: ButtonVariant.primary,
                        onPressed: () {
                          context.go(AppRoutes.dashboard);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.monoSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(SimulationSessionResult result) {
    final gradeColor = result.finalScore >= 80
        ? AppColors.emerald
        : (result.finalScore >= 70 ? AppColors.amber : AppColors.crimson);

    return CrystalCard(
      accentColor: gradeColor,
      isHighlighted: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.scenarioCode,
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.scenarioTitle,
                    style: AppTypography.headlineSmall.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradeColor.withValues(alpha: 0.15),
                  border: Border.all(color: gradeColor, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: gradeColor.withValues(alpha: 0.3),
                      blurRadius: 14,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    result.performanceGrade,
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: gradeColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.borderMuted),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeroMetric('COMPOSITE SCORE', '${result.finalScore}%',
                  AppColors.textPrimary),
              Container(width: 1, height: 28, color: AppColors.crystalBorder),
              _buildHeroMetric(
                'MISSION TIME',
                Formatters.formatSeconds(result.totalTimeElapsedSeconds),
                AppColors.cyan,
              ),
              Container(width: 1, height: 28, color: AppColors.crystalBorder),
              _buildHeroMetric('RISK PROFILE', '${result.riskIndex}%',
                  AppColors.emerald),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMetric(String label, String value, Color valueColor) {
    return Column(
      children: [
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
          style: AppTypography.monoLarge.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCompetencyCard(SimulationSessionResult result) {
    return CrystalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CORE COMPETENCY EVALUATION',
            style: AppTypography.monoSmall.copyWith(
              color: AppColors.cyan,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          _buildCompetencyBar('Tactical Soundness',
              result.tacticalSoundnessScore, AppColors.emerald),
          const SizedBox(height: 10),
          _buildCompetencyBar('Information Handling under Degradation',
              result.informationTriageScore, AppColors.cyan),
          const SizedBox(height: 10),
          _buildCompetencyBar('Resource Efficiency',
              result.resourceEfficiencyScore, AppColors.amber),
        ],
      ),
    );
  }

  Widget _buildCompetencyBar(String label, int score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              '$score%',
              style: AppTypography.monoSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildDecisionTimelineTile(SimulationDecisionRecord record) {
    final choice = record.selectedChoice;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: choice.isOptimal
              ? AppColors.emerald.withValues(alpha: 0.3)
              : AppColors.crystalBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: choice.isOptimal
                          ? AppColors.emerald.withValues(alpha: 0.2)
                          : AppColors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${record.stageNumber}',
                        style: AppTypography.monoSmall.copyWith(
                          color: choice.isOptimal
                              ? AppColors.emerald
                              : AppColors.amber,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    record.stageTitle,
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                '${record.responseTimeSeconds}s latency',
                style: AppTypography.monoSmall.copyWith(
                  color: AppColors.cyan,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            choice.label,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            choice.consequenceText,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebriefCard(SimulationSessionResult result) {
    return CrystalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXECUTIVE SUMMARY',
            style: AppTypography.monoSmall.copyWith(
              color: AppColors.amber,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            result.executiveSummary,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(color: AppColors.borderMuted),
          const SizedBox(height: 10),

          // Strengths
          Text(
            'COMMENDATIONS & STRENGTHS',
            style: AppTypography.monoSmall.copyWith(
              color: AppColors.emerald,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          ...result.keyStrengths.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 14, color: AppColors.emerald),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(s,
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 12),

          // Recommendations
          Text(
            'COMPLIANCE & SOP RECOMMENDATIONS',
            style: AppTypography.monoSmall.copyWith(
              color: AppColors.cyan,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          ...result.complianceRecommendations.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right,
                        size: 16, color: AppColors.cyan),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(r,
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.textSecondary)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
