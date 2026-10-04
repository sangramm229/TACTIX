import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/constants/app_enums.dart';
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

class SimulationScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const SimulationScreen({
    super.key,
    required this.sessionId,
  });

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _missionTimer;
  int _secondsRemaining = 240;
  bool _isPaused = false;
  int _simulationSpeed = 1;

  int _currentStageIndex = 0;
  String? _selectedChoiceId;
  int _stageTimerSeconds = 0;

  final List<SimulationDecisionRecord> _recordedDecisions = [];
  int _accumulatedScore = 0;

  late List<SimulationStage> _stages;
  bool _isLoading = true;
  String _activeChannel = 'ALL';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _loadStages();
    _startTimer();
  }

  void _loadStages() {
    final repo = ref.read(scenarioRepositoryProvider);
    _stages = repo.getSimulationStages(widget.sessionId);
    if (_stages.isEmpty) {
      _stages = repo.getSimulationStages('comm_breakdown_01');
    }
    _isLoading = false;
  }

  void _startTimer() {
    _missionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _isPaused) return;

      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining -= _simulationSpeed;
          _stageTimerSeconds += _simulationSpeed;
        } else {
          _missionTimer?.cancel();
          _concludeSimulation();
        }
      });
    });
  }

  @override
  void dispose() {
    _missionTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleChoiceSelected(SimulationChoice choice, SimulationStage currentStage) {
    setState(() {
      _selectedChoiceId = choice.id;
    });

    // Show immediate tactical consequence dialog
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
                    Row(
                      children: [
                        Icon(
                          choice.isOptimal
                              ? Icons.verified
                              : Icons.warning_amber_rounded,
                          color: choice.isOptimal
                              ? AppColors.emerald
                              : AppColors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          choice.isOptimal
                              ? 'OPTIMAL TACTICAL CONCURRENCE'
                              : 'SUB-OPTIMAL ALLOCATION',
                          style: AppTypography.badge.copyWith(
                            color: choice.isOptimal
                                ? AppColors.emerald
                                : AppColors.amber,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.cyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: AppColors.cyan.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '+${choice.scoreDelta} PTS',
                        style: AppTypography.monoSmall.copyWith(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  choice.label,
                  style: AppTypography.headlineSmall.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.crystalBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OPERATIONAL CONSEQUENCE',
                        style: AppTypography.monoSmall.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        choice.consequenceText,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatPill('Response Time', '$_stageTimerSeconds sec',
                        AppColors.cyan),
                    const SizedBox(width: 10),
                    _buildStatPill(
                      'Risk Impact',
                      '${choice.riskImpact > 0 ? "+" : ""}${choice.riskImpact}%',
                      choice.riskImpact > 0
                          ? AppColors.crimson
                          : AppColors.emerald,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TactixButton(
                  label: _currentStageIndex < _stages.length - 1
                      ? 'ENGAGE NEXT CHECKPOINT'
                      : 'CONCLUDE & GENERATE AAR',
                  icon: Icons.arrow_forward_rounded,
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    Navigator.pop(ctx);
                    _commitChoiceAndAdvance(choice, currentStage);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _commitChoiceAndAdvance(
      SimulationChoice choice, SimulationStage currentStage) {
    _recordedDecisions.add(
      SimulationDecisionRecord(
        stageNumber: currentStage.stageNumber,
        stageTitle: currentStage.title,
        selectedChoice: choice,
        responseTimeSeconds: _stageTimerSeconds,
        timestamp: DateTime.now(),
      ),
    );

    _accumulatedScore += choice.scoreDelta;
    _stageTimerSeconds = 0;
    _selectedChoiceId = null;

    if (_currentStageIndex < _stages.length - 1) {
      setState(() {
        _currentStageIndex++;
      });
    } else {
      _concludeSimulation();
    }
  }

  void _concludeSimulation() {
    _missionTimer?.cancel();

    final repo = ref.read(scenarioRepositoryProvider);
    final scenario = repo.getScenarioById(widget.sessionId);

    final sessionResult = repo.getSessionResult(
      'session_${widget.sessionId}_${DateTime.now().millisecondsSinceEpoch}',
      scenario: scenario,
      decisions: _recordedDecisions,
      totalSeconds: 240 - _secondsRemaining,
    );

    ref.read(lastSessionResultProvider.notifier).setResult(sessionResult);

    context.go(AppRoutes.reportPath(sessionResult.sessionId));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator(color: AppColors.cyan)),
      );
    }

    final currentStage = _stages[_currentStageIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarHeader(
        title: 'LIVE INCIDENT SIMULATOR',
        subtitle: 'ACTIVE SESSION: ${widget.sessionId.toUpperCase()}',
        showBack: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isPaused = !_isPaused;
              });
            },
            icon: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: _isPaused ? AppColors.amber : AppColors.cyan,
              size: 20,
            ),
            tooltip: _isPaused ? 'Resume Mission' : 'Pause Mission',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _simulationSpeed = _simulationSpeed == 1 ? 2 : 1;
              });
            },
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: _simulationSpeed > 1
                    ? AppColors.amber.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _simulationSpeed > 1
                      ? AppColors.amber
                      : AppColors.crystalBorder,
                ),
              ),
              child: Text(
                '${_simulationSpeed}x',
                style: AppTypography.monoSmall.copyWith(
                  color: _simulationSpeed > 1
                      ? AppColors.amber
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
            tooltip: 'Toggle Speed Multiplier',
          ),
        ],
      ),
      body: CrystalBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top Liquid Crystal Telemetry Bar
              _buildTopTelemetryBar(),

              // Main Simulation Body
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stage Header Pill
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.cyan.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                  color: AppColors.cyan.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              'STAGE ${_currentStageIndex + 1} OF ${_stages.length}',
                              style: AppTypography.badge.copyWith(
                                color: AppColors.cyan,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Text(
                            'Elapsed: ${Formatters.formatSeconds(240 - _secondsRemaining)}',
                            style: AppTypography.monoSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Stage Title & Situational Update Card
                      CrystalCard(
                        accentColor: AppColors.blue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStage.title,
                              style: AppTypography.headlineSmall.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentStage.situationalUpdate,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Degraded Telemetry & Comms Feed
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.cell_tower,
                                  size: 16, color: AppColors.amber),
                              const SizedBox(width: 6),
                              Text(
                                'INCOMING DEGRADED TRANSMISSIONS',
                                style: AppTypography.monoSmall.copyWith(
                                  color: AppColors.amber,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          _buildSignalPulseIndicator(),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Channel Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildChannelChip('ALL'),
                            const SizedBox(width: 6),
                            _buildChannelChip('Radio'),
                            const SizedBox(width: 6),
                            _buildChannelChip('SCADA'),
                            const SizedBox(width: 6),
                            _buildChannelChip('Relay'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Feed Cards
                      ...currentStage.telemetryFeed
                          .where((p) =>
                              _activeChannel == 'ALL' ||
                              p.channel
                                  .toLowerCase()
                                  .contains(_activeChannel.toLowerCase()))
                          .map((packet) => _buildTelemetryCard(packet)),

                      const SizedBox(height: 16),

                      // Tactical Dilemma / Decision Deck
                      Row(
                        children: [
                          Icon(Icons.alt_route,
                              size: 16, color: AppColors.cyan),
                          const SizedBox(width: 6),
                          Text(
                            'TACTICAL DECISION DECK',
                            style: AppTypography.monoSmall.copyWith(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      CrystalCard(
                        accentColor: AppColors.amber,
                        isHighlighted: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStage.decisionPrompt,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Option Cards
                            ...currentStage.choices.map((choice) {
                              final isSelected =
                                  _selectedChoiceId == choice.id;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  onTap: () => _handleChoiceSelected(
                                      choice, currentStage),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.cyan
                                              .withValues(alpha: 0.15)
                                          : AppColors.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.cyan
                                            : AppColors.crystalBorder,
                                        width: isSelected ? 1.5 : 1.0,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 22,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isSelected
                                                    ? AppColors.cyan
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? AppColors.cyan
                                                      : AppColors.textTertiary,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: isSelected
                                                  ? const Icon(Icons.check,
                                                      size: 14,
                                                      color:
                                                          Color(0xFF070B14))
                                                  : null,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                choice.label,
                                                style: AppTypography.bodyMedium
                                                    .copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          choice.tacticalRationale,
                                          style:
                                              AppTypography.bodySmall.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Risk Impact: ',
                                              style: AppTypography.monoSmall
                                                  .copyWith(fontSize: 10),
                                            ),
                                            Text(
                                              '${choice.riskImpact > 0 ? "+" : ""}${choice.riskImpact}%',
                                              style: AppTypography.monoSmall
                                                  .copyWith(
                                                color: choice.riskImpact > 0
                                                    ? AppColors.crimson
                                                    : AppColors.emerald,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              'Est. Time: ${choice.timeSeconds}s',
                                              style: AppTypography.monoSmall
                                                  .copyWith(
                                                color: AppColors.textTertiary,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopTelemetryBar() {
    final timerColor = _secondsRemaining < 60
        ? AppColors.crimson
        : (_secondsRemaining < 120 ? AppColors.amber : AppColors.cyan);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        border: const Border(
          bottom: BorderSide(color: AppColors.crystalBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 16, color: timerColor),
              const SizedBox(width: 6),
              Text(
                Formatters.formatSeconds(_secondsRemaining),
                style: AppTypography.monoLarge.copyWith(
                  color: timerColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 8),
              if (_isPaused)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.amber),
                  ),
                  child: Text(
                    'PAUSED',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.amber,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          Row(
            children: [
              _buildDegradationBadge('$_accumulatedScore PTS', AppColors.cyan),
              const SizedBox(width: 6),
              _buildDegradationBadge('JITTER 18s', AppColors.amber),
              const SizedBox(width: 6),
              _buildDegradationBadge('LOSS 30%', AppColors.crimson),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDegradationBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: AppTypography.badge.copyWith(
          color: color,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget _buildSignalPulseIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.emerald,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.emerald.withValues(
                        alpha: 0.4 + (_pulseController.value * 0.4)),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'CARRIER ACTIVE',
              style: AppTypography.monoSmall.copyWith(
                color: AppColors.emerald,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChannelChip(String label) {
    final isSelected = _activeChannel == label;
    return InkWell(
      onTap: () {
        setState(() {
          _activeChannel = label;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.cyan.withValues(alpha: 0.2)
              : AppColors.glassCard,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? AppColors.cyan : AppColors.crystalBorder,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTypography.badge.copyWith(
            color: isSelected ? AppColors.cyan : AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryCard(IncomingTelemetryPacket packet) {
    final statusColor = AppColors.getStatusColor(packet.degradation);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.glassCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: packet.degradation != DegradationType.normal
              ? statusColor.withValues(alpha: 0.4)
              : AppColors.crystalBorder,
          width: 1.0,
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
                  Text(
                    packet.sender,
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '• ${packet.channel}',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  packet.degradation.label,
                  style: AppTypography.badge.copyWith(
                    color: statusColor,
                    fontSize: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            packet.message,
            style: AppTypography.bodySmall.copyWith(
              color: packet.degradation == DegradationType.conflicting
                  ? AppColors.amber
                  : AppColors.textSecondary,
              fontStyle: packet.degradation == DegradationType.partial
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: AppTypography.monoSmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: AppTypography.monoSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
