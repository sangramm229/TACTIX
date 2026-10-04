import 'package:flutter/material.dart';
import 'package:tactix/core/constants/app_constants.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/shared/widgets/app_bar_header.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _audioJitterSimulation = true;
  bool _hapticFeedback = true;
  bool _autoExportAAR = true;
  bool _darkCrystalMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBarHeader(
        title: 'OPERATOR DOSSIER',
        subtitle: 'ENTERPRISE CREDENTIALS & SYSTEM CONTROL',
        showBack: true,
      ),
      body: CrystalBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Operator ID Card
                CrystalCard(
                  accentColor: AppColors.amber,
                  isHighlighted: true,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.amber, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.amber.withValues(alpha: 0.25),
                              blurRadius: 14,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.shield,
                              color: AppColors.amber, size: 30),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHIEF COMMANDER V. ROY',
                              style: AppTypography.headlineSmall.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Incident Command Unit • Regional Emergency Grid',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.emerald.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: AppColors.emerald
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    'ICS-300 CERTIFIED',
                                    style: AppTypography.badge.copyWith(
                                      color: AppColors.emerald,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.cyan.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: AppColors.cyan
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    'TIER 1 OPERATOR',
                                    style: AppTypography.badge.copyWith(
                                      color: AppColors.cyan,
                                      fontSize: 9,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // System & Product Specification
                Text(
                  'ENTERPRISE PLATFORM SPECIFICATION',
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.cyan,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                CrystalCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildRow('PRODUCT SUITE', AppConstants.appName),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildRow('EDITION', AppConstants.productEdition),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildRow('ORGANIZATION', AppConstants.defaultOrganization),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildRow('COMPLIANCE', AppConstants.platformCompliance),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildRow('PLATFORM ENGINE', AppConstants.systemVersion),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildRow('SIMULATOR STATUS', 'All 7 Telemetry Degraders Operational'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Simulation Control Settings
                Text(
                  'SIMULATION ENGINE PREFERENCES',
                  style: AppTypography.monoSmall.copyWith(
                    color: AppColors.amber,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                CrystalCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        title: 'Telemetry Audio Degradation Emulation',
                        subtitle: 'Simulate radio jitter, packet dropping, and garbled voice carriers',
                        value: _audioJitterSimulation,
                        onChanged: (val) => setState(() => _audioJitterSimulation = val),
                      ),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildSwitchTile(
                        title: 'Haptic Decision Consequence Pulse',
                        subtitle: 'Vibrate device upon high-risk tactical choices',
                        value: _hapticFeedback,
                        onChanged: (val) => setState(() => _hapticFeedback = val),
                      ),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildSwitchTile(
                        title: 'Liquid Crystal UI Shader & Ambient Glow',
                        subtitle: 'Enable specular reflection and frosted glass blurs',
                        value: _darkCrystalMode,
                        onChanged: (val) => setState(() => _darkCrystalMode = val),
                      ),
                      const Divider(color: AppColors.borderMuted, height: 16),
                      _buildSwitchTile(
                        title: 'Automated After-Action Audit PDF',
                        subtitle: 'Generate printable ISO 22301 debrief upon drill completion',
                        value: _autoExportAAR,
                        onChanged: (val) => setState(() => _autoExportAAR = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: AppTypography.monoSmall.copyWith(
              fontSize: 10,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.monoSmall.copyWith(
              fontSize: 11,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.cyan,
          activeTrackColor: AppColors.cyan.withValues(alpha: 0.3),
        ),
      ],
    );
  }
}
