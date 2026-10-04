import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/shared/widgets/app_bar_header.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';
import 'package:tactix/shared/widgets/metric_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarHeader(
        title: 'TRAINING ANALYTICS',
        subtitle: 'HISTORICAL SESSIONS & INCIDENT AUDIT LOGS',
        showBack: true,
      ),
      body: CrystalBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERFORMANCE RADAR & READINESS',
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: const [
                    MetricCard(
                      title: 'Decision Quality',
                      value: '88%',
                      subtitle: 'Logic tree concurrence',
                      accentColor: AppColors.emerald,
                      icon: Icons.psychology_outlined,
                    ),
                    MetricCard(
                      title: 'Information Handling',
                      value: '84%',
                      subtitle: 'Degraded telemetry triage',
                      accentColor: AppColors.cyan,
                      icon: Icons.filter_alt_outlined,
                    ),
                    MetricCard(
                      title: 'Risk Profile',
                      value: '14%',
                      subtitle: 'Low hazard exposure',
                      accentColor: AppColors.amber,
                      icon: Icons.security_outlined,
                    ),
                    MetricCard(
                      title: 'Conflict Detection',
                      value: '94%',
                      subtitle: 'Discrepancy recognition',
                      accentColor: AppColors.violet,
                      icon: Icons.compare_arrows_outlined,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Sector Mastery Section
                Text(
                  'SECTOR COMPETENCY BREAKDOWN',
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.amber,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),

                CrystalCard(
                  child: Column(
                    children: [
                      _buildSectorProgressRow('Healthcare & Mass Influx', 0.92, AppColors.cyan),
                      const SizedBox(height: 10),
                      _buildSectorProgressRow('Power Grid & SCADA Blackout', 0.94, AppColors.emerald),
                      const SizedBox(height: 10),
                      _buildSectorProgressRow('Industrial Hydrocarbon Containment', 0.82, AppColors.amber),
                      const SizedBox(height: 10),
                      _buildSectorProgressRow('Municipal Flood & Spillway Protocol', 0.78, AppColors.violet),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'RECENT COMPLETED INCIDENT DRILLS',
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),

                _buildHistoryItem(
                  context: context,
                  scenarioCode: 'MED-702',
                  scenarioTitle: 'HOSPITAL SURGE & POWER FAILURE',
                  sector: 'Healthcare',
                  date: '2026-10-04 • 17:30',
                  score: '88%',
                  outcome: 'ICU & OR power preserved; runner blood relay established',
                  sessionId: 'session_med_demo',
                ),
                const SizedBox(height: 10),
                _buildHistoryItem(
                  context: context,
                  scenarioCode: 'PWR-512',
                  scenarioTitle: 'SUBSTATION CASCADING BLACKOUT',
                  sector: 'Energy & Grid',
                  date: '2026-10-02 • 14:45',
                  score: '94%',
                  outcome: 'Substation isolated without feeder collapse',
                  sessionId: 'session_0412_demo',
                ),
                const SizedBox(height: 10),
                _buildHistoryItem(
                  context: context,
                  scenarioCode: 'IND-409',
                  scenarioTitle: 'HYDROCARBON REFINERY RUPTURE',
                  sector: 'Industrial',
                  date: '2026-09-29 • 11:20',
                  score: '82%',
                  outcome: 'UAV drone verified Zone B rupture; valve shutoff completed',
                  sessionId: 'session_26248_demo',
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectorProgressRow(String sector, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sector,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTypography.monoSmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required BuildContext context,
    required String scenarioCode,
    required String scenarioTitle,
    required String sector,
    required String date,
    required String score,
    required String outcome,
    required String sessionId,
  }) {
    return CrystalCard(
      onTap: () => context.push(AppRoutes.reportPath(sessionId)),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      scenarioCode,
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sector.toUpperCase(),
                    style: AppTypography.badge.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
              Text(
                'Score: $score',
                style: AppTypography.monoSmall.copyWith(
                  color: AppColors.emerald,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            scenarioTitle,
            style: AppTypography.headlineSmall.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            outcome,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: AppTypography.monoSmall.copyWith(fontSize: 10)),
              Row(
                children: [
                  Text(
                    'VIEW AUDIT AAR',
                    style: AppTypography.badge.copyWith(
                      color: AppColors.amber,
                      fontSize: 10,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 14, color: AppColors.amber),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
