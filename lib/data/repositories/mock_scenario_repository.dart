import 'package:tactix/core/constants/app_enums.dart';
import 'package:tactix/data/models/scenario_summary.dart';
import 'package:tactix/data/models/simulation_models.dart';

abstract class ScenarioRepository {
  List<ScenarioSummary> getScenarios();
  ScenarioSummary? getScenarioById(String id);
  List<SimulationStage> getSimulationStages(String scenarioId);
  SimulationSessionResult getSessionResult(
    String sessionId, {
    ScenarioSummary? scenario,
    List<SimulationDecisionRecord>? decisions,
    int? totalSeconds,
  });
  List<SimulationSessionResult> getHistoricalSessions();
}

class MockScenarioRepository implements ScenarioRepository {
  static final List<ScenarioSummary> _scenarios = [
    const ScenarioSummary(
      id: 'code_black_hospital',
      code: 'MED-702',
      title: 'HOSPITAL SURGE & POWER FAILURE',
      category: 'Healthcare Crisis Management',
      sector: 'Healthcare',
      description: 'Mass casualty influx during regional grid failure. Emergency backup generator trips intermittently while clinical telemetry and pager networks desynchronize.',
      situationBriefing: 'At 19:40 hrs, Regional Trauma Center receives 45 acute casualties following an expressway pileup. Concurrently, regional power substations trip, forcing hospital auxiliary diesel generators online. SCADA sensors report fuel line pressure oscillation in Generator 2. Ward monitoring relays are dropping telemetry packets, while triage teams report conflicting patient acuity counts.',
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 4,
      decisionCount: 3,
      degradationTypes: [
        DegradationType.delayed,
        DegradationType.conflicting,
        DegradationType.partial,
      ],
      status: ScenarioStatus.available,
      objectives: [
        ObjectiveItem(
          type: ObjectiveType.primary,
          title: 'Secure ICU & OR Critical Power Bus',
          description: 'Isolate non-essential hospital loads before Generator 2 automated thermal cutout triggers.',
        ),
        ObjectiveItem(
          type: ObjectiveType.secondary,
          title: 'Resolve Triage Acuity Discrepancies',
          description: 'Reconcile ambulance dispatch manifests with frontline trauma bay admissions under degraded comms.',
        ),
        ObjectiveItem(
          type: ObjectiveType.contingency,
          title: 'Establish Emergency Runner Protocol',
          description: 'Deploy physical messenger couriers for blood bank and oxygen status verification.',
        ),
      ],
      channelConditions: [
        ChannelCondition(
          channelName: 'Trauma Bay VHF Radio',
          status: DegradationType.normal,
          note: 'Direct line operational (<0.8s latency)',
        ),
        ChannelCondition(
          channelName: 'Generator SCADA Telemetry',
          status: DegradationType.partial,
          note: 'Pressure logs dropping 35% of packets',
        ),
        ChannelCondition(
          channelName: 'Emergency Pager Relay',
          status: DegradationType.delayed,
          note: 'Dispatch queuing delay: 24-35 seconds',
        ),
        ChannelCondition(
          channelName: 'Regional EMS Inbound Feed',
          status: DegradationType.conflicting,
          note: 'Ambulance count differs from field dispatch log',
        ),
      ],
      availableResources: [
        'Trauma Response Team (8 Physicians, 14 Critical Care Nurses)',
        'Facilities Engineering Crew (Auxiliary Generator Specialists)',
        'Standby Battery Inverter Banks (Rated for 45 min ICU runtime)',
        'Civil Defense Hospital Transport Reserve',
      ],
      rulesOfEngagement: [
        'Do not interrupt life-support circuits without battery confirmation.',
        'Prioritize red-tag trauma admissions over routine transfers.',
        'Verify critical blood reserve requests with dual runner check.',
      ],
      bestScore: 0.88,
    ),
    const ScenarioSummary(
      id: 'comm_breakdown_01',
      code: 'IND-409',
      title: 'HYDROCARBON REFINERY RUPTURE',
      category: 'Industrial Incident Command',
      sector: 'Industrial',
      description: 'Emergency incident reported in industrial complex. Field units report contradictory zones while optical telemetry goes dark and HQ confirmation lags.',
      situationBriefing: 'At 14:30 hrs, emergency distress signal detected in Sector 4 of the regional chemical refinery. Field units deployed to perimeter. Team Alpha reports volatile vapor cloud in Zone A, whereas Team Bravo insists critical rupture is centered in Zone B. Remote optical and thermal telemetry sensors went offline immediately after detection. The commander must coordinate containment, assess reliability, and deploy intervention resources under extreme telemetry degradation.',
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 4,
      decisionCount: 3,
      degradationTypes: [
        DegradationType.delayed,
        DegradationType.conflicting,
        DegradationType.missing,
        DegradationType.partial,
      ],
      status: ScenarioStatus.available,
      objectives: [
        ObjectiveItem(
          type: ObjectiveType.primary,
          title: 'Identify & Verify Rupture Zone',
          description: 'Resolve conflicting ground reports between Team Alpha and Team Bravo without premature over-commitment.',
        ),
        ObjectiveItem(
          type: ObjectiveType.secondary,
          title: 'Prevent Vapor Cloud Ignition',
          description: 'Safeguard secondary operational units from unverified high-threat perimeter hazards.',
        ),
        ObjectiveItem(
          type: ObjectiveType.contingency,
          title: 'Establish Redundant Comms Loop',
          description: 'Reroute critical telemetry before primary radio repeater battery depletion.',
        ),
      ],
      channelConditions: [
        ChannelCondition(
          channelName: 'Alpha Tactical Channel',
          status: DegradationType.normal,
          note: 'VHF encrypted link nominal (Latency: <1.2s)',
        ),
        ChannelCondition(
          channelName: 'Bravo Recon Channel',
          status: DegradationType.conflicting,
          note: 'Payload contradicts Team Alpha positioning reports',
        ),
        ChannelCondition(
          channelName: 'Thermal Sensor Network',
          status: DegradationType.offline,
          note: 'Telemetry blackout post-incident trip',
        ),
        ChannelCondition(
          channelName: 'HQ Operations Relay',
          status: DegradationType.delayed,
          note: 'Packet routing delay 18-28 seconds',
        ),
      ],
      availableResources: [
        'Team Alpha — 4-man Rapid Intervention Unit (Equipped for Hazard Containment)',
        'Team Bravo — Mobile Reconnaissance Unit (Field Survey)',
        'Sector 4 Standby Medical Transport',
        'Auxiliary Drone UAV (Standby: 12-min deployment delay)',
      ],
      rulesOfEngagement: [
        'Do not commit primary reserve until spatial confirmation has at least 70% confidence.',
        'Account for transmission latency before countermanding field unit tactical directives.',
        'Maintain continuous status logging on degraded channels.',
      ],
      bestScore: 0.82,
    ),
    const ScenarioSummary(
      id: 'blackout_protocol_02',
      code: 'PWR-512',
      title: 'SUBSTATION CASCADING BLACKOUT',
      category: 'Power Grid Infrastructure',
      sector: 'Energy',
      description: 'Substation automated switches tripped during heavy storm. Dispatch receiving fragmented logs and delayed field inspection confirmations.',
      situationBriefing: 'Severe lightning storm has triggered cascading circuit breaker trips in regional Substation 9. SCADA telemetry packet flow is intermittently dropping 40% of packets. Station technicians are attempting manual reclosure while dispatch is missing critical transformer temperature data.',
      difficulty: DifficultyLevel.beginner,
      durationMinutes: 3,
      decisionCount: 3,
      degradationTypes: [
        DegradationType.missing,
        DegradationType.delayed,
      ],
      status: ScenarioStatus.completed,
      objectives: [
        ObjectiveItem(
          type: ObjectiveType.primary,
          title: 'Isolate Overloaded Feeders',
          description: 'Prevent regional grid blackout without tripping hospital emergency backup lines.',
        ),
        ObjectiveItem(
          type: ObjectiveType.secondary,
          title: 'Verify Ground Crew Safety',
          description: 'Ensure technicians are clear before issuing remote recloser commands.',
        ),
      ],
      channelConditions: [
        ChannelCondition(
          channelName: 'SCADA Telemetry Bus',
          status: DegradationType.delayed,
          note: 'Heartbeat delay 15 seconds',
        ),
        ChannelCondition(
          channelName: 'Field Crew Dispatch',
          status: DegradationType.normal,
          note: 'Radio line operational',
        ),
        ChannelCondition(
          channelName: 'Transformer Temp Probe',
          status: DegradationType.missing,
          note: 'No packets received since 14:12',
        ),
      ],
      availableResources: [
        'Substation 9 Mobile Technician Team',
        'Emergency Remote Load Shedder Control',
        'Civil Defense Liason Unit',
      ],
      rulesOfEngagement: [
        'Never energize unconfirmed lines without technician clearance.',
      ],
      bestScore: 0.94,
    ),
    const ScenarioSummary(
      id: 'hazmat_dispersion_03',
      code: 'HAZ-899',
      title: 'HIGHWAY AMMONIA PLUME DISPERSION',
      category: 'Chemical Spill Evacuation',
      sector: 'Industrial',
      description: 'Volatile tanker collision near urban corridor. Atmospheric wind sensors yield conflicting vectors with partial toxicity readouts.',
      situationBriefing: 'Highway 102 chemical freight collision has ruptured an ammonia container. Atmospheric sensors at Station North and Station East indicate conflicting wind directions. Local emergency calls report breathing irritation across overlapping zones.',
      difficulty: DifficultyLevel.advanced,
      durationMinutes: 5,
      decisionCount: 3,
      degradationTypes: [
        DegradationType.conflicting,
        DegradationType.unverified,
        DegradationType.partial,
        DegradationType.delayed,
      ],
      status: ScenarioStatus.available,
      objectives: [
        ObjectiveItem(
          type: ObjectiveType.primary,
          title: 'Determine Evacuation Plume Vector',
          description: 'Establish high-certainty chemical dispersion corridor under conflicting meteorological inputs.',
        ),
        ObjectiveItem(
          type: ObjectiveType.secondary,
          title: 'Coordinate Public Warning Sirens',
          description: 'Issue targeted zone alarms without triggering mass panics in unaffected sectors.',
        ),
      ],
      channelConditions: [
        ChannelCondition(
          channelName: 'Station North Anemometer',
          status: DegradationType.conflicting,
          note: 'Reports North-Northwest wind @ 14 knots',
        ),
        ChannelCondition(
          channelName: 'Station East Sensor',
          status: DegradationType.conflicting,
          note: 'Reports South-Southeast wind @ 9 knots',
        ),
        ChannelCondition(
          channelName: 'Highway Patrol Comms',
          status: DegradationType.partial,
          note: 'Audio carrier clipping and missing words',
        ),
        ChannelCondition(
          channelName: 'Toxicology Hotline',
          status: DegradationType.delayed,
          note: 'Subject to 30-sec queue latency',
        ),
      ],
      availableResources: [
        'Hazmat Response Team 1 (Specialized containment gear)',
        'Traffic Control Police Squadrons (Zones 1-4)',
        'Municipal Air Sampling Drone',
      ],
      rulesOfEngagement: [
        'Evacuate downwind populated sectors with safety margin buffer.',
      ],
      bestScore: null,
    ),
    const ScenarioSummary(
      id: 'flash_flood_05',
      code: 'DIS-310',
      title: 'FLASH FLOOD DAM SPILLWAY FAILURE',
      category: 'Municipal Disaster Resilience',
      sector: 'Municipal',
      description: 'Torrential rainfall pushes reservoir to crest level. Remote spillway gates telemetry lags by 45 seconds while unverified social alerts trigger spontaneous evacuations.',
      situationBriefing: 'Pine Valley Reservoir hydro-electric dam reaches 98% capacity following unprecedented monsoon cloudburst. Gate 3 actuator feedback sensor reports intermittent communication timeout. Downstream town civil sirens have not sounded due to fiber relay severance.',
      difficulty: DifficultyLevel.advanced,
      durationMinutes: 5,
      decisionCount: 3,
      degradationTypes: [
        DegradationType.delayed,
        DegradationType.missing,
        DegradationType.unverified,
      ],
      status: ScenarioStatus.available,
      objectives: [
        ObjectiveItem(
          type: ObjectiveType.primary,
          title: 'Manual Actuation of Spillway Gate 3',
          description: 'Verify gate hydraulic clearance before structural breach threshold.',
        ),
        ObjectiveItem(
          type: ObjectiveType.secondary,
          title: 'Trigger Downstream Cellular Broadcast',
          description: 'Broadcast high-certainty flood sirens to Sector Blue residents.',
        ),
      ],
      channelConditions: [
        ChannelCondition(
          channelName: 'Spillway Gate Telemetry',
          status: DegradationType.delayed,
          note: 'Sensor packet lag 45 seconds',
        ),
        ChannelCondition(
          channelName: 'Downstream River Gauge',
          status: DegradationType.normal,
          note: 'Water rise rate nominal (0.3m/hr)',
        ),
        ChannelCondition(
          channelName: 'Civil Defense Siren Bus',
          status: DegradationType.offline,
          note: 'Severed fiber relay',
        ),
      ],
      availableResources: [
        'Dam Operations On-Site Engineering Squad',
        'State Police Helicopter Rescue Unit',
        'Emergency SMS Emergency Broadcast System',
      ],
      rulesOfEngagement: [
        'Do not release full spillway volume without alerting riverfront districts.',
      ],
      bestScore: null,
    ),
    const ScenarioSummary(
      id: 'perimeter_breach_04',
      code: 'SEC-114',
      title: 'CRITICAL FACILITY PERIMETER BREACH',
      category: 'Critical Infrastructure Security',
      sector: 'Security',
      description: 'Simultaneous motion alarms along high-security perimeter. CCTV feeds suffer from electrical interference and satellite uplink delay.',
      situationBriefing: 'At 02:15, outer perimeter zone sensors report simultaneous trip events across Sectors Bravo and Delta. Optical feeds are experiencing heavy scan line distortion and delayed frame drops.',
      difficulty: DifficultyLevel.intermediate,
      durationMinutes: 4,
      decisionCount: 3,
      degradationTypes: [
        DegradationType.delayed,
        DegradationType.partial,
        DegradationType.missing,
      ],
      status: ScenarioStatus.available,
      objectives: [
        ObjectiveItem(
          type: ObjectiveType.primary,
          title: 'Identify Primary Infiltration Vector',
          description: 'Differentiate between decoy fence trips and actual core facility breach.',
        ),
        ObjectiveItem(
          type: ObjectiveType.secondary,
          title: 'Preserve Central Guard Contingent',
          description: 'Avoid total dispatch of interior security to outer false alarms.',
        ),
      ],
      channelConditions: [
        ChannelCondition(
          channelName: 'Sector Bravo CCTV',
          status: DegradationType.partial,
          note: 'Frame rate dropped to 1 fps with scan artifacts',
        ),
        ChannelCondition(
          channelName: 'Sector Delta Radar',
          status: DegradationType.delayed,
          note: '20-second sweep latency',
        ),
        ChannelCondition(
          channelName: 'Central Vault Bio-lock',
          status: DegradationType.normal,
          note: 'Encrypted fiber telemetry active',
        ),
      ],
      availableResources: [
        'QRF Security Alpha (Fast intercept squad)',
        'Interior Sentry Guard Team (Fixed asset protection)',
        'Perimeter Floodlight Array (Manual remote control)',
      ],
      rulesOfEngagement: [
        'Maintain minimum 3 guards at Central Server Core at all times.',
      ],
      bestScore: null,
    ),
  ];

  @override
  List<ScenarioSummary> getScenarios() {
    return _scenarios;
  }

  @override
  ScenarioSummary? getScenarioById(String id) {
    try {
      return _scenarios.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<SimulationStage> getSimulationStages(String scenarioId) {
    switch (scenarioId) {
      case 'code_black_hospital':
        return [
          SimulationStage(
            stageNumber: 1,
            title: 'STAGE 1: GENERATOR OSCILLATION & TRIAGE INFLUX',
            situationalUpdate: 'Regional blackout triggers transfer to Generator 2. Telemetry indicates fuel pressure fluctuating by 22%. Ambulance convoy arrives at ER ramp.',
            telemetryFeed: [
              IncomingTelemetryPacket(
                sender: 'Facility SCADA',
                channel: 'Power Management Net',
                message: 'Generator 2 fuel line oscillating. Auto-cutout possible within 180s.',
                degradation: DegradationType.delayed,
                timestamp: '19:41:05',
              ),
              IncomingTelemetryPacket(
                sender: 'EMS Dispatch',
                channel: 'Inbound Radio',
                message: 'Convoy Alpha carrying 18 trauma patients; 6 critical respiratory cases.',
                degradation: DegradationType.normal,
                timestamp: '19:41:22',
              ),
              IncomingTelemetryPacket(
                sender: 'ICU Charge Nurse',
                channel: 'Internal Paging',
                message: '[CORRUPTED] ...oxygen manifolds ...low pressure alarm in Pod C...',
                degradation: DegradationType.partial,
                timestamp: '19:41:35',
              ),
            ],
            decisionPrompt: 'How do you prioritize auxiliary generator power distribution and clinical triage?',
            choices: [
              SimulationChoice(
                id: 'med_c1',
                label: 'Shed non-essential outpatient wings and lock power bus to ICU & OR',
                tacticalRationale: 'Guarantees continuous life support to critical patients before breaker overload.',
                consequenceText: 'ICU oxygen manifolds stabilized. Power load drops 38%, stabilizing Generator 2.',
                riskImpact: -15,
                timeSeconds: 14,
                scoreDelta: 30,
                isOptimal: true,
              ),
              SimulationChoice(
                id: 'med_c2',
                label: 'Run Generator 2 at 100% capacity to power full facility including parking lights',
                tacticalRationale: 'Ensures maximum external visibility for arriving ambulance fleet.',
                consequenceText: 'Overload warning triggers. Fuel filter thermal trip occurs 45 seconds later.',
                riskImpact: 25,
                timeSeconds: 22,
                scoreDelta: 10,
                isOptimal: false,
              ),
              SimulationChoice(
                id: 'med_c3',
                label: 'Hold all actions pending manual technician verification of fuel line',
                tacticalRationale: 'Prevents making unnecessary shedding decisions prematurely.',
                consequenceText: 'Technician takes 7 minutes to reach generator while brownouts occur in Trauma Bay.',
                riskImpact: 18,
                timeSeconds: 35,
                scoreDelta: 15,
                isOptimal: false,
              ),
            ],
          ),
          SimulationStage(
            stageNumber: 2,
            title: 'STAGE 2: CONFLICTING OXYGEN MANIFOLD READINGS',
            situationalUpdate: 'Floor nurses report oxygen pressure drop in Pod B, but Central Gas Telemetry insists bulk liquid oxygen tank is at 88% capacity.',
            telemetryFeed: [
              IncomingTelemetryPacket(
                sender: 'Central Gas Plant',
                channel: 'Telemetry Bus',
                message: 'Bulk O2 Tank status: 88% nominal pressure. No supply deficit detected.',
                degradation: DegradationType.normal,
                timestamp: '19:43:10',
              ),
              IncomingTelemetryPacket(
                sender: 'Ward Runner Unit',
                channel: 'VHF Emergency Net',
                message: '[CONFLICTING] Pod B zone valve is partially closed following seismic vibration.',
                degradation: DegradationType.conflicting,
                timestamp: '19:43:28',
              ),
            ],
            decisionPrompt: 'Resolve the discrepancy between central telemetry and field runner reports.',
            choices: [
              SimulationChoice(
                id: 'med_c4',
                label: 'Dispatch engineering runner to inspect and reopen Pod B local zone valve immediately',
                tacticalRationale: 'Addresses immediate physical bottleneck at the ward level while trusting central bulk tank status.',
                consequenceText: 'Valve re-engaged. Oxygen flow restored to acute beds within 90 seconds.',
                riskImpact: -20,
                timeSeconds: 16,
                scoreDelta: 35,
                isOptimal: true,
              ),
              SimulationChoice(
                id: 'med_c5',
                label: 'Order full hospital evacuation of ICU patients to outdoor parking lot',
                tacticalRationale: 'Extreme contingency response to perceived total oxygen failure.',
                consequenceText: 'Severe patient instability during transfer under stormy weather. Unnecessary mass panic.',
                riskImpact: 35,
                timeSeconds: 30,
                scoreDelta: 5,
                isOptimal: false,
              ),
            ],
          ),
          SimulationStage(
            stageNumber: 3,
            title: 'STAGE 3: TRIAGE RESOURCE ALLOCATION',
            situationalUpdate: 'Secondary wave of 15 burn victims arrives. Blood bank communication line is dead.',
            telemetryFeed: [
              IncomingTelemetryPacket(
                sender: 'Blood Bank Relay',
                channel: 'Direct Fiber',
                message: '[NO CARRIER - OFFLINE]',
                degradation: DegradationType.offline,
                timestamp: '19:45:00',
              ),
              IncomingTelemetryPacket(
                sender: 'Trauma Lead',
                channel: 'VHF Tactical',
                message: 'Requesting 20 units O-negative blood for emergency surgery.',
                degradation: DegradationType.normal,
                timestamp: '19:45:15',
              ),
            ],
            decisionPrompt: 'Establish emergency runner courier protocol for blood and resource logistics.',
            choices: [
              SimulationChoice(
                id: 'med_c6',
                label: 'Deploy dedicated paired runners with physical requisition slips to Blood Bank',
                tacticalRationale: 'Establishes verified human air-gap courier protocol with zero digital dependency.',
                consequenceText: 'All 20 units delivered within 4 minutes. Dual-verification prevents cross-match errors.',
                riskImpact: -15,
                timeSeconds: 12,
                scoreDelta: 35,
                isOptimal: true,
              ),
              SimulationChoice(
                id: 'med_c7',
                label: 'Delay surgical interventions until fiber optic data line re-establishes',
                tacticalRationale: 'Awaiting digital inventory confirmation before committing supplies.',
                consequenceText: 'Critical delay leads to severe patient shock progression.',
                riskImpact: 30,
                timeSeconds: 40,
                scoreDelta: 10,
                isOptimal: false,
              ),
            ],
          ),
        ];

      default:
        // Default Industrial scenario (comm_breakdown_01 and others)
        return [
          SimulationStage(
            stageNumber: 1,
            title: 'STAGE 1: INCIDENT ZONE VERIFICATION',
            situationalUpdate: 'Distress beacon activated in refinery perimeter. Team Alpha reports hazard in Zone A; Team Bravo reports Zone B. Sensors offline.',
            telemetryFeed: [
              IncomingTelemetryPacket(
                sender: 'Team Alpha Lead',
                channel: 'Alpha Tactical Net',
                message: 'Visual identification of dense vapor plume over Zone A compressor building.',
                degradation: DegradationType.normal,
                timestamp: '14:31:10',
              ),
              IncomingTelemetryPacket(
                sender: 'Team Bravo Recon',
                channel: 'Bravo Recon Net',
                message: '[CONFLICTING] Negative on Zone A. Heavy hiss and thermal flare in Zone B tank farm!',
                degradation: DegradationType.conflicting,
                timestamp: '14:31:25',
              ),
              IncomingTelemetryPacket(
                sender: 'Optical Telemetry',
                channel: 'Fixed SCADA',
                message: '[PACKET LOSS 100%] Cameras offline across Sectors 3 & 4.',
                degradation: DegradationType.offline,
                timestamp: '14:31:40',
              ),
            ],
            decisionPrompt: 'How do you deploy containment units amidst contradictory ground intelligence?',
            choices: [
              SimulationChoice(
                id: 'ind_c1',
                label: 'Deploy UAV drone on high-altitude survey while keeping reserves in neutral staging',
                tacticalRationale: 'Prevents fatal commitment into false sector while acquiring independent sensor proof.',
                consequenceText: 'UAV confirms primary rupture in Zone B with drift towards Zone A. Staging area preserved.',
                riskImpact: -15,
                timeSeconds: 18,
                scoreDelta: 35,
                isOptimal: true,
              ),
              SimulationChoice(
                id: 'ind_c2',
                label: 'Commit all primary Hazmat units directly into Zone A immediately',
                tacticalRationale: 'Fast response based on Team Alpha first-reported coordinates.',
                consequenceText: 'Hazmat units caught in shifting plume downwind of actual Zone B rupture.',
                riskImpact: 25,
                timeSeconds: 12,
                scoreDelta: 10,
                isOptimal: false,
              ),
              SimulationChoice(
                id: 'ind_c3',
                label: 'Stand down both field teams until HQ operations relay provides confirmation',
                tacticalRationale: 'Wait for higher-level satellite or SCADA confirmation before moving.',
                consequenceText: 'HQ confirmation delayed by 28 seconds; vapor cloud expands across access road.',
                riskImpact: 20,
                timeSeconds: 32,
                scoreDelta: 15,
                isOptimal: false,
              ),
            ],
          ),
          SimulationStage(
            stageNumber: 2,
            title: 'STAGE 2: ISOLATION VALVE ACTUATION',
            situationalUpdate: 'UAV confirms high-pressure rupture at Zone B valve manifold. Remote servo actuator fails to respond.',
            telemetryFeed: [
              IncomingTelemetryPacket(
                sender: 'Pipeline SCADA',
                channel: 'Control Relay',
                message: '[DELAYED +22s] Remote emergency cutoff valve Command Failed. Error: Actuator Timeout.',
                degradation: DegradationType.delayed,
                timestamp: '14:33:05',
              ),
              IncomingTelemetryPacket(
                sender: 'Team Bravo',
                channel: 'Bravo Recon Net',
                message: 'Manual valve wheel accessible with positive pressure SCBA gear.',
                degradation: DegradationType.normal,
                timestamp: '14:33:20',
              ),
            ],
            decisionPrompt: 'Order manual isolation or execute plant-wide emergency nitrogen purge?',
            choices: [
              SimulationChoice(
                id: 'ind_c4',
                label: 'Authorize 2-man specialized entry team with thermal cameras for manual valve closure',
                tacticalRationale: 'Direct mechanical isolation stops continuous fuel feed at source with targeted risk.',
                consequenceText: 'Valves closed within 2 minutes. Line pressure stabilizes.',
                riskImpact: -20,
                timeSeconds: 15,
                scoreDelta: 35,
                isOptimal: true,
              ),
              SimulationChoice(
                id: 'ind_c5',
                label: 'Trigger blanket explosive nitrogen deluge over the entire facility',
                tacticalRationale: 'Automated total suppression system.',
                consequenceText: 'Causes major infrastructure damage and destroys electrical relays throughout Sector 4.',
                riskImpact: 30,
                timeSeconds: 25,
                scoreDelta: 15,
                isOptimal: false,
              ),
            ],
          ),
          SimulationStage(
            stageNumber: 3,
            title: 'STAGE 3: PERIMETER EVACUATION & CONTAINMENT',
            situationalUpdate: 'Residual vapor dispersing toward Sector 4 East Gate where civil contractors are departing.',
            telemetryFeed: [
              IncomingTelemetryPacket(
                sender: 'East Gate Security',
                channel: 'Civilian Dispatch',
                message: '[PARTIAL SIGNAL] Traffic congestion ...20 vehicles waiting at gate exit...',
                degradation: DegradationType.partial,
                timestamp: '14:35:10',
              ),
              IncomingTelemetryPacket(
                sender: 'Weather Anemometer',
                channel: 'Environmental Net',
                message: 'Wind shift from SW to SSE at 8 knots.',
                degradation: DegradationType.normal,
                timestamp: '14:35:30',
              ),
            ],
            decisionPrompt: 'Reroute traffic evacuation corridor to bypass expanding perimeter plume.',
            choices: [
              SimulationChoice(
                id: 'ind_c6',
                label: 'Reroute all vehicles via North Gate bypass and activate water curtain sprays',
                tacticalRationale: 'Prevents civilian vehicles from driving directly through toxic corridor.',
                consequenceText: 'All 20 vehicles cleared safely. Water curtain reduces vapor density by 65%.',
                riskImpact: -15,
                timeSeconds: 14,
                scoreDelta: 30,
                isOptimal: true,
              ),
              SimulationChoice(
                id: 'ind_c7',
                label: 'Instruct vehicles to shelter inside cars with engines running at East Gate',
                tacticalRationale: 'Avoids traffic re-organization delays.',
                consequenceText: 'Engine air intakes suck in hydrocarbon vapors creating secondary ignition hazard.',
                riskImpact: 35,
                timeSeconds: 28,
                scoreDelta: 10,
                isOptimal: false,
              ),
            ],
          ),
        ];
    }
  }

  @override
  SimulationSessionResult getSessionResult(
    String sessionId, {
    ScenarioSummary? scenario,
    List<SimulationDecisionRecord>? decisions,
    int? totalSeconds,
  }) {
    final effectiveScenario = scenario ?? _scenarios.first;
    final effectiveDecisions = decisions ??
        [
          SimulationDecisionRecord(
            stageNumber: 1,
            stageTitle: 'STAGE 1: INITIAL TRIAGE & DISCREPANCY RESOLUTION',
            selectedChoice: const SimulationChoice(
              id: 'c1',
              label: 'Verified ground telemetry via auxiliary drone before deployment',
              tacticalRationale: 'Prevented misallocation of critical reserves.',
              consequenceText: 'Confirmed incident perimeter within nominal limits.',
              riskImpact: -15,
              timeSeconds: 16,
              scoreDelta: 35,
              isOptimal: true,
            ),
            responseTimeSeconds: 16,
            timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          ),
          SimulationDecisionRecord(
            stageNumber: 2,
            stageTitle: 'STAGE 2: ISOLATION PROTOCOL ENGAGEMENT',
            selectedChoice: const SimulationChoice(
              id: 'c2',
              label: 'Direct mechanical isolation under positive SCBA protocol',
              tacticalRationale: 'Stopped fuel flow at primary manifold.',
              consequenceText: 'Threat mitigated without auxiliary transformer overload.',
              riskImpact: -20,
              timeSeconds: 14,
              scoreDelta: 35,
              isOptimal: true,
            ),
            responseTimeSeconds: 14,
            timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          ),
          SimulationDecisionRecord(
            stageNumber: 3,
            stageTitle: 'STAGE 3: PERIMETER EVACUATION REROUTING',
            selectedChoice: const SimulationChoice(
              id: 'c3',
              label: 'Rerouted evacuation corridor via North Gate bypass',
              tacticalRationale: 'Safeguarded civilian perimeter from downwind dispersion.',
              consequenceText: 'Safe perimeter established with zero human exposure.',
              riskImpact: -15,
              timeSeconds: 12,
              scoreDelta: 20,
              isOptimal: true,
            ),
            responseTimeSeconds: 12,
            timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          ),
        ];

    int calculatedScore = 0;
    for (final d in effectiveDecisions) {
      calculatedScore += d.selectedChoice.scoreDelta;
    }
    calculatedScore = calculatedScore.clamp(40, 96);

    String grade = 'A';
    if (calculatedScore >= 90) {
      grade = 'A+';
    } else if (calculatedScore >= 80) {
      grade = 'A';
    } else if (calculatedScore >= 70) {
      grade = 'B';
    } else {
      grade = 'C';
    }

    return SimulationSessionResult(
      sessionId: sessionId,
      scenarioId: effectiveScenario.id,
      scenarioTitle: effectiveScenario.title,
      scenarioCode: effectiveScenario.code,
      finalScore: calculatedScore,
      performanceGrade: grade,
      totalTimeElapsedSeconds: totalSeconds ?? 142,
      riskIndex: 14,
      informationTriageScore: 89,
      tacticalSoundnessScore: 92,
      resourceEfficiencyScore: 86,
      decisions: effectiveDecisions,
      executiveSummary:
          'Operator demonstrated superior command presence and critical information triage under severe telemetry degradation. Conflicting field transmissions were systematically verified using redundant sensing rather than premature reserve commitment.',
      keyStrengths: [
        'Resisted hasty over-commitment when Team Alpha and Team Bravo provided conflicting spatial data.',
        'Properly prioritized life-critical systems before secondary infrastructure.',
        'Demonstrated rapid decision latency (<18 seconds average under pressure).',
      ],
      operationalVulnerabilities: [
        'Briefly hesitated on initial radio repeater verification before dispatching secondary units.',
        'Could formalize runner couriers earlier when primary SCADA telemetry started dropping packets.',
      ],
      complianceRecommendations: [
        'Adopt ICS-300 standard communications handoff checklist for degraded multi-agency operations.',
        'Implement automated sensor sanity filters to flag contradictory readings before operator display.',
        'Conduct monthly table-top simulation drills for critical facility backup power transitions.',
      ],
      completedAt: DateTime.now(),
    );
  }

  @override
  List<SimulationSessionResult> getHistoricalSessions() {
    return [
      getSessionResult('session_0412_demo',
          scenario: _scenarios[2], totalSeconds: 118),
      getSessionResult('session_26248_demo',
          scenario: _scenarios[1], totalSeconds: 154),
      getSessionResult('session_med_demo',
          scenario: _scenarios[0], totalSeconds: 142),
    ];
  }
}
