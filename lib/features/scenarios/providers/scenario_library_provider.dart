import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tactix/core/constants/app_enums.dart';
import 'package:tactix/data/models/scenario_summary.dart';
import 'package:tactix/data/models/simulation_models.dart';
import 'package:tactix/data/repositories/mock_scenario_repository.dart';

final scenarioRepositoryProvider = Provider<ScenarioRepository>((ref) {
  return MockScenarioRepository();
});

final scenarioListProvider = Provider<List<ScenarioSummary>>((ref) {
  final repo = ref.watch(scenarioRepositoryProvider);
  return repo.getScenarios();
});

class DifficultyFilterNotifier extends Notifier<DifficultyLevel?> {
  @override
  DifficultyLevel? build() => null;

  void setFilter(DifficultyLevel? filter) {
    state = filter;
  }
}

final selectedDifficultyFilterProvider =
    NotifierProvider<DifficultyFilterNotifier, DifficultyLevel?>(
  DifficultyFilterNotifier.new,
);

class SectorFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setSector(String? sector) {
    state = sector;
  }
}

final selectedSectorFilterProvider =
    NotifierProvider<SectorFilterNotifier, String?>(
  SectorFilterNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  SearchQueryNotifier.new,
);

final filteredScenariosProvider = Provider<List<ScenarioSummary>>((ref) {
  final scenarios = ref.watch(scenarioListProvider);
  final diffFilter = ref.watch(selectedDifficultyFilterProvider);
  final sectorFilter = ref.watch(selectedSectorFilterProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  return scenarios.where((s) {
    if (diffFilter != null && s.difficulty != diffFilter) {
      return false;
    }
    if (sectorFilter != null && s.sector.toLowerCase() != sectorFilter.toLowerCase()) {
      return false;
    }
    if (query.isNotEmpty) {
      final matchesTitle = s.title.toLowerCase().contains(query);
      final matchesCategory = s.category.toLowerCase().contains(query);
      final matchesCode = s.code.toLowerCase().contains(query);
      final matchesSector = s.sector.toLowerCase().contains(query);
      if (!matchesTitle && !matchesCategory && !matchesCode && !matchesSector) {
        return false;
      }
    }
    return true;
  }).toList();
});

final scenarioDetailProvider =
    Provider.family<ScenarioSummary?, String>((ref, id) {
  final repo = ref.watch(scenarioRepositoryProvider);
  return repo.getScenarioById(id);
});

class LastSessionResultNotifier extends Notifier<SimulationSessionResult?> {
  @override
  SimulationSessionResult? build() => null;

  void setResult(SimulationSessionResult result) {
    state = result;
  }
}

final lastSessionResultProvider =
    NotifierProvider<LastSessionResultNotifier, SimulationSessionResult?>(
  LastSessionResultNotifier.new,
);
