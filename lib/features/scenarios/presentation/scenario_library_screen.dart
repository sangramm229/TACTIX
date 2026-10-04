import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/constants/app_enums.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/features/scenarios/providers/scenario_library_provider.dart';
import 'package:tactix/shared/widgets/app_bar_header.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/scenario_card.dart';

class ScenarioLibraryScreen extends ConsumerStatefulWidget {
  const ScenarioLibraryScreen({super.key});

  @override
  ConsumerState<ScenarioLibraryScreen> createState() =>
      _ScenarioLibraryScreenState();
}

class _ScenarioLibraryScreenState
    extends ConsumerState<ScenarioLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _sectors = [
    'ALL',
    'HEALTHCARE',
    'INDUSTRIAL',
    'ENERGY',
    'MUNICIPAL',
    'SECURITY',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scenarios = ref.watch(filteredScenariosProvider);
    final selectedDiff = ref.watch(selectedDifficultyFilterProvider);
    final selectedSector = ref.watch(selectedSectorFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarHeader(
        title: 'SCENARIO CATALOG',
        subtitle: 'MULTI-SECTOR INCIDENT SIMULATION SUITE',
        showBack: true,
      ),
      body: CrystalBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Search & Filter Header Container
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.glassCard,
                  border: const Border(
                    bottom:
                        BorderSide(color: AppColors.crystalBorder, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        ref
                            .read(searchQueryProvider.notifier)
                            .setQuery(val);
                      },
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search scenario, sector, or keyword...',
                        hintStyle: AppTypography.bodySmall
                            .copyWith(color: AppColors.textTertiary),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.cyan, size: 18),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close,
                                    size: 16, color: AppColors.textTertiary),
                                onPressed: () {
                                  _searchController.clear();
                                  ref
                                      .read(searchQueryProvider.notifier)
                                      .setQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.crystalBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.crystalBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: AppColors.cyan),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Sector Pills
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _sectors.map((sec) {
                          final isSelected = (sec == 'ALL' &&
                                  selectedSector == null) ||
                              (selectedSector?.toUpperCase() == sec);

                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: InkWell(
                              onTap: () {
                                ref
                                    .read(
                                        selectedSectorFilterProvider.notifier)
                                    .setSector(sec == 'ALL' ? null : sec);
                              },
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.cyan
                                          .withValues(alpha: 0.18)
                                      : Colors.white.withValues(alpha: 0.04),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.cyan
                                        : AppColors.crystalBorder,
                                    width: isSelected ? 1.2 : 1.0,
                                  ),
                                ),
                                child: Text(
                                  sec,
                                  style: AppTypography.badge.copyWith(
                                    color: isSelected
                                        ? AppColors.cyan
                                        : AppColors.textSecondary,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Difficulty Filter Row
                    Row(
                      children: [
                        Text(
                          'DIFFICULTY:',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildDiffChip(
                          label: 'ALL',
                          isSelected: selectedDiff == null,
                          onTap: () => ref
                              .read(selectedDifficultyFilterProvider.notifier)
                              .setFilter(null),
                        ),
                        const SizedBox(width: 6),
                        _buildDiffChip(
                          label: 'BEGINNER',
                          color: AppColors.emerald,
                          isSelected:
                              selectedDiff == DifficultyLevel.beginner,
                          onTap: () => ref
                              .read(selectedDifficultyFilterProvider.notifier)
                              .setFilter(DifficultyLevel.beginner),
                        ),
                        const SizedBox(width: 6),
                        _buildDiffChip(
                          label: 'INTERMEDIATE',
                          color: AppColors.amber,
                          isSelected:
                              selectedDiff == DifficultyLevel.intermediate,
                          onTap: () => ref
                              .read(selectedDifficultyFilterProvider.notifier)
                              .setFilter(DifficultyLevel.intermediate),
                        ),
                        const SizedBox(width: 6),
                        _buildDiffChip(
                          label: 'ADVANCED',
                          color: AppColors.crimson,
                          isSelected:
                              selectedDiff == DifficultyLevel.advanced,
                          onTap: () => ref
                              .read(selectedDifficultyFilterProvider.notifier)
                              .setFilter(DifficultyLevel.advanced),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Scenario Count Indicator
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'AVAILABLE DRILLS (${scenarios.length})',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.8,
                      ),
                    ),
                    if (selectedDiff != null ||
                        selectedSector != null ||
                        _searchController.text.isNotEmpty)
                      InkWell(
                        onTap: () {
                          _searchController.clear();
                          ref
                              .read(searchQueryProvider.notifier)
                              .setQuery('');
                          ref
                              .read(selectedDifficultyFilterProvider.notifier)
                              .setFilter(null);
                          ref
                              .read(selectedSectorFilterProvider.notifier)
                              .setSector(null);
                        },
                        child: Text(
                          'RESET FILTERS',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.amber,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Scenario List
              Expanded(
                child: scenarios.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off,
                                size: 48, color: AppColors.textTertiary),
                            const SizedBox(height: 12),
                            Text(
                              'NO SCENARIOS MATCH YOUR FILTER',
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try selecting a different sector or clearing search',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: scenarios.length,
                        itemBuilder: (context, index) {
                          final scenario = scenarios[index];
                          return ScenarioCard(
                            scenario: scenario,
                            onViewScenario: () {
                              context.push(
                                  AppRoutes.scenarioDetailPath(scenario.id));
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiffChip({
    required String label,
    required bool isSelected,
    Color color = AppColors.cyan,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? color : AppColors.crystalBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.badge.copyWith(
            color: isSelected ? color : AppColors.textTertiary,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}
