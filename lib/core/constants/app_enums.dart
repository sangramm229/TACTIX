enum DegradationType {
  normal('NORMAL', 'Information arrives with nominal latency'),
  delayed('DELAYED', 'Information arrives after critical delay'),
  missing('MISSING', 'Expected telemetry never arrives'),
  conflicting('CONFLICTING', 'Multiple sources deliver contradictory data'),
  partial('PARTIAL', 'Telemetry payload is fragmented or incomplete'),
  unverified('UNVERIFIED', 'Payload received without verification hash'),
  offline('OFFLINE', 'Channel unresponsive or sensor disrupted');

  const DegradationType(this.label, this.description);
  final String label;
  final String description;
}

enum DifficultyLevel {
  beginner('BEGINNER', 'Low latency • Clear telemetry • Extended time windows'),
  intermediate('INTERMEDIATE', 'Moderate delays • Incomplete transmissions • Time pressure'),
  advanced('ADVANCED', 'Heavy degradation • Conflicting intelligence • Critical time pressure');

  const DifficultyLevel(this.label, this.description);
  final String label;
  final String description;
}

enum ScenarioStatus {
  available('AVAILABLE'),
  inProgress('IN PROGRESS'),
  completed('COMPLETED'),
  locked('LOCKED');

  const ScenarioStatus(this.label);
  final String label;
}

enum ObjectiveType {
  primary('PRIMARY OBJECTIVE'),
  secondary('SECONDARY OBJECTIVE'),
  contingency('CONTINGENCY DIRECTIVE');

  const ObjectiveType(this.label);
  final String label;
}
