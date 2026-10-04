import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/constants/app_constants.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/features/dashboard/presentation/widgets/training_progress_card.dart';
import 'package:tactix/features/scenarios/providers/scenario_library_provider.dart';
import 'package:tactix/shared/widgets/app_bar_header.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/scenario_card.dart';
import 'package:tactix/shared/widgets/tactix_button.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _selectedSector = 'ALL';

  final List<String> _sectors = [
    'ALL',
    'HEALTHCARE',
    'INDUSTRIAL',
    'ENERGY',
    'MUNICIPAL',
    'SECURITY',
  ];

  @override
  Widget build(BuildContext context) {
    final allScenarios = ref.watch(scenarioListProvider);

    final filteredScenarios = _selectedSector == 'ALL'
        ? allScenarios
        : allScenarios
            .where((s) =>
                s.sector.toLowerCase() == _selectedSector.toLowerCase())
            .toList();

    final recommendedScenario =
        filteredScenarios.isNotEmpty ? filteredScenarios.first : null;
    final otherScenarios = filteredScenarios.skip(1).take(2).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarHeader(
        title: AppConstants.appName,
        subtitle: AppConstants.appTagline.toUpperCase(),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.scenarios),
            icon: const Icon(Icons.explore_outlined,
                color: AppColors.cyan, size: 20),
            tooltip: 'Explore Scenarios',
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.shield_outlined,
                color: AppColors.textSecondary, size: 20),
            tooltip: 'Operator Dossier',
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
                // Command Center Welcome Banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'COMMAND CENTER • ENTERPRISE SUITE',
                              style: AppTypography.monoSmall.copyWith(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Welcome, Incident Commander',
                          style: AppTypography.displayMedium.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.emerald.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.emerald,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SIM ENGINE ONLINE',
                            style: AppTypography.monoSmall.copyWith(
                              color: AppColors.emerald,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Operator Training Readiness Card
                const TrainingProgressCard(
                  completedScenarios: 12,
                  totalScenarios: 18,
                  averageResponseSeconds: 14.8,
                  decisionPerformancePercentage: 88,
                ),

                const SizedBox(height: 20),

                // Sector Quick-Pills Filter Strip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SECTOR DRILL FOCUS',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '6 DOMAINS ACTIVE',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.cyan,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _sectors.map((sec) {
                      final isSelected = _selectedSector == sec;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSector = sec;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.cyan.withValues(alpha: 0.2)
                                  : Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.cyan
                                    : AppColors.crystalBorder,
                                width: isSelected ? 1.4 : 1.0,
                              ),
                            ),
                            child: Text(
                              sec,
                              style: AppTypography.badge.copyWith(
                                color: isSelected
                                    ? AppColors.cyan
                                    : AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Launch Primary Drill Action Button
                TactixButton(
                  label: 'COMMENCE MISSION SIMULATION',
                  icon: Icons.bolt,
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    if (recommendedScenario != null) {
                      context.push(AppRoutes.scenarioDetailPath(
                          recommendedScenario.id));
                    } else {
                      context.push(AppRoutes.scenarios);
                    }
                  },
                ),

                const SizedBox(height: 24),

                // Recommended Scenario Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'RECOMMENDED SCENARIO',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.scenarios),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 24),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'VIEW ALL CATALOG',
                            style: AppTypography.monoSmall.copyWith(
                              color: AppColors.cyan,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              size: 14, color: AppColors.cyan),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (recommendedScenario != null)
                  ScenarioCard(
                    scenario: recommendedScenario,
                    isHighlighted: true,
                    onViewScenario: () {
                      context.push(AppRoutes.scenarioDetailPath(
                          recommendedScenario.id));
                    },
                  ),

                const SizedBox(height: 16),

                // Other Sector Scenarios Section
                if (otherScenarios.isNotEmpty) ...[
                  Text(
                    'ADDITIONAL OPERATIONAL SCENARIOS',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.textTertiary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...otherScenarios.map((sc) {
                    return ScenarioCard(
                      scenario: sc,
                      onViewScenario: () {
                        context
                            .push(AppRoutes.scenarioDetailPath(sc.id));
                      },
                    );
                  }),
                ],

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.8),
          border: const Border(
            top: BorderSide(color: AppColors.crystalBorder, width: 1),
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              indicatorColor: AppColors.amber.withValues(alpha: 0.25),
              selectedIndex: 0,
              onDestinationSelected: (idx) {
                if (idx == 1) context.push(AppRoutes.scenarios);
                if (idx == 2) context.push(AppRoutes.history);
                if (idx == 3) context.push(AppRoutes.profile);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined,
                      color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.dashboard, color: AppColors.amber),
                  label: AppConstants.navHome,
                ),
                NavigationDestination(
                  icon: Icon(Icons.view_carousel_outlined,
                      color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.view_carousel, color: AppColors.amber),
                  label: AppConstants.navScenarios,
                ),
                NavigationDestination(
                  icon: Icon(Icons.insights_outlined,
                      color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.insights, color: AppColors.amber),
                  label: AppConstants.navAnalytics,
                ),
                NavigationDestination(
                  icon: Icon(Icons.shield_outlined,
                      color: AppColors.textSecondary),
                  selectedIcon: Icon(Icons.shield, color: AppColors.amber),
                  label: AppConstants.navProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
