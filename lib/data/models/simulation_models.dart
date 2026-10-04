import 'package:tactix/core/constants/app_enums.dart';

class SimulationChoice {
  final String id;
  final String label;
  final String tacticalRationale;
  final String consequenceText;
  final int riskImpact; // -20 to +20
  final int timeSeconds; // time cost
  final int scoreDelta; // score points
  final bool isOptimal;

  const SimulationChoice({
    required this.id,
    required this.label,
    required this.tacticalRationale,
    required this.consequenceText,
    required this.riskImpact,
    required this.timeSeconds,
    required this.scoreDelta,
    this.isOptimal = false,
  });
}

class IncomingTelemetryPacket {
  final String sender;
  final String channel;
  final String message;
  final DegradationType degradation;
  final String timestamp;

  const IncomingTelemetryPacket({
    required this.sender,
    required this.channel,
    required this.message,
    required this.degradation,
    required this.timestamp,
  });
}

class SimulationStage {
  final int stageNumber;
  final String title;
  final String situationalUpdate;
  final List<IncomingTelemetryPacket> telemetryFeed;
  final String decisionPrompt;
  final List<SimulationChoice> choices;

  const SimulationStage({
    required this.stageNumber,
    required this.title,
    required this.situationalUpdate,
    required this.telemetryFeed,
    required this.decisionPrompt,
    required this.choices,
  });
}

class SimulationDecisionRecord {
  final int stageNumber;
  final String stageTitle;
  final SimulationChoice selectedChoice;
  final int responseTimeSeconds;
  final DateTime timestamp;

  const SimulationDecisionRecord({
    required this.stageNumber,
    required this.stageTitle,
    required this.selectedChoice,
    required this.responseTimeSeconds,
    required this.timestamp,
  });
}

class SimulationSessionResult {
  final String sessionId;
  final String scenarioId;
  final String scenarioTitle;
  final String scenarioCode;
  final int finalScore; // 0 - 100
  final String performanceGrade; // 'A+', 'A', 'B', etc.
  final int totalTimeElapsedSeconds;
  final int riskIndex; // 0 - 100
  final int informationTriageScore; // 0 - 100
  final int tacticalSoundnessScore; // 0 - 100
  final int resourceEfficiencyScore; // 0 - 100
  final List<SimulationDecisionRecord> decisions;
  final String executiveSummary;
  final List<String> keyStrengths;
  final List<String> operationalVulnerabilities;
  final List<String> complianceRecommendations;
  final DateTime completedAt;

  const SimulationSessionResult({
    required this.sessionId,
    required this.scenarioId,
    required this.scenarioTitle,
    required this.scenarioCode,
    required this.finalScore,
    required this.performanceGrade,
    required this.totalTimeElapsedSeconds,
    required this.riskIndex,
    required this.informationTriageScore,
    required this.tacticalSoundnessScore,
    required this.resourceEfficiencyScore,
    required this.decisions,
    required this.executiveSummary,
    required this.keyStrengths,
    required this.operationalVulnerabilities,
    required this.complianceRecommendations,
    required this.completedAt,
  });
}
