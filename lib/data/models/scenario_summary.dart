import 'package:tactix/core/constants/app_enums.dart';

class ObjectiveItem {
  final ObjectiveType type;
  final String title;
  final String description;

  const ObjectiveItem({
    required this.type,
    required this.title,
    required this.description,
  });
}

class ChannelCondition {
  final String channelName;
  final DegradationType status;
  final String note;

  const ChannelCondition({
    required this.channelName,
    required this.status,
    required this.note,
  });
}

class ScenarioSummary {
  final String id;
  final String code;
  final String title;
  final String category;
  final String sector;
  final String description;
  final String situationBriefing;
  final DifficultyLevel difficulty;
  final int durationMinutes;
  final int decisionCount;
  final List<DegradationType> degradationTypes;
  final ScenarioStatus status;
  final List<ObjectiveItem> objectives;
  final List<ChannelCondition> channelConditions;
  final List<String> availableResources;
  final List<String> rulesOfEngagement;
  final double? bestScore;

  const ScenarioSummary({
    required this.id,
    required this.code,
    required this.title,
    required this.category,
    this.sector = 'Industrial',
    required this.description,
    required this.situationBriefing,
    required this.difficulty,
    required this.durationMinutes,
    required this.decisionCount,
    required this.degradationTypes,
    this.status = ScenarioStatus.available,
    required this.objectives,
    required this.channelConditions,
    required this.availableResources,
    required this.rulesOfEngagement,
    this.bestScore,
  });
}
