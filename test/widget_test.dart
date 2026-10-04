import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tactix/core/constants/app_constants.dart';
import 'package:tactix/core/constants/app_enums.dart';
import 'package:tactix/data/repositories/mock_scenario_repository.dart';
import 'package:tactix/features/scenarios/providers/scenario_library_provider.dart';
import 'package:tactix/main.dart';

void main() {
  group('Enterprise Product Foundation & Smoke Tests', () {
    testWidgets('App boots into Tactix Pro Splash Screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: TactixApp(),
        ),
      );

      // Splash screen should display TACTIX Pro product brand and edition
      expect(find.text(AppConstants.appName), findsOneWidget);
      expect(
        find.text('${AppConstants.productEdition.toUpperCase()} • DEGRADED COMM SIMULATOR'),
        findsOneWidget,
      );

      // Unmount widget to trigger clean disposal of timers
      await tester.pumpWidget(const SizedBox());
    });

    test('MockScenarioRepository returns valid multi-sector scenario catalogue', () {
      final repo = MockScenarioRepository();
      final scenarios = repo.getScenarios();

      expect(scenarios.isNotEmpty, isTrue);
      expect(scenarios.length, greaterThanOrEqualTo(5));
      expect(scenarios.any((s) => s.sector == 'Healthcare'), isTrue);
      expect(scenarios.any((s) => s.sector == 'Industrial'), isTrue);
      expect(scenarios.any((s) => s.sector == 'Energy'), isTrue);

      final demoScenario = repo.getScenarioById('comm_breakdown_01');
      expect(demoScenario, isNotNull);
      expect(demoScenario!.difficulty, DifficultyLevel.intermediate);
      expect(demoScenario.degradationTypes.contains(DegradationType.conflicting), isTrue);
      expect(demoScenario.degradationTypes.contains(DegradationType.delayed), isTrue);
      expect(demoScenario.degradationTypes.contains(DegradationType.missing), isTrue);
    });

    test('Scenario Filter Provider correctly filters by difficulty and sector', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Default: All scenarios
      var list = container.read(filteredScenariosProvider);
      expect(list.length, greaterThanOrEqualTo(4));

      // Filter by Intermediate
      container
          .read(selectedDifficultyFilterProvider.notifier)
          .setFilter(DifficultyLevel.intermediate);

      list = container.read(filteredScenariosProvider);
      expect(list.every((s) => s.difficulty == DifficultyLevel.intermediate), isTrue);

      // Filter by Healthcare sector
      container
          .read(selectedDifficultyFilterProvider.notifier)
          .setFilter(null);
      container
          .read(selectedSectorFilterProvider.notifier)
          .setSector('Healthcare');

      list = container.read(filteredScenariosProvider);
      expect(list.every((s) => s.sector == 'Healthcare'), isTrue);
    });
  });
}
