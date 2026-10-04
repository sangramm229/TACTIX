import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/constants/app_constants.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';
import 'package:tactix/shared/widgets/tactix_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _callsignController =
      TextEditingController(text: 'COMMANDER-774');

  String _selectedDivision = 'Emergency Management Grid';

  final List<String> _divisions = [
    'Emergency Management Grid',
    'Trauma & Healthcare Logistics',
    'Industrial & Energy Infrastructure',
    'Municipal Disaster Resilience',
  ];

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _callsignController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CrystalBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Luminous Crystal Shield Emblem
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: AppColors.amber.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.amber.withValues(
                                alpha: 0.6 + (_animController.value * 0.4)),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.amber.withValues(
                                  alpha: 0.2 + (_animController.value * 0.2)),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.shield_outlined,
                              color: AppColors.amber, size: 38),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),

                  Text(
                    AppConstants.appName,
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 34,
                      letterSpacing: 3.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.appTagline.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.cyan,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Frosted Crystal Login Card
                  CrystalCard(
                    accentColor: AppColors.cyan,
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ENTERPRISE AUTHENTICATION',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 10,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Operator ID / Callsign
                        Text(
                          'OPERATOR CALLSIGN / CREDENTIAL',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _callsignController,
                          style: AppTypography.monoMedium
                              .copyWith(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.crystalBorder),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.crystalBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: AppColors.cyan),
                            ),
                            prefixIcon: const Icon(Icons.badge_outlined,
                                color: AppColors.cyan, size: 18),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Division Selector
                        Text(
                          'ASSIGNED DIVISION / SECTOR',
                          style: AppTypography.monoSmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: AppColors.crystalBorder),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDivision,
                              isExpanded: true,
                              dropdownColor: AppColors.surfaceElevated,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: AppColors.cyan),
                              items: _divisions.map((div) {
                                return DropdownMenuItem(
                                  value: div,
                                  child: Text(
                                    div,
                                    style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textPrimary),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedDivision = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Login Action
                        TactixButton(
                          label: 'ENTER COMMAND CENTER',
                          icon: Icons.login,
                          variant: ButtonVariant.primary,
                          onPressed: () {
                            context.go(AppRoutes.dashboard);
                          },
                        ),

                        const SizedBox(height: 10),

                        // Rapid Sandbox Mode
                        TactixButton(
                          label: 'INSTANT SANDBOX ACCESS',
                          icon: Icons.shield_moon_outlined,
                          variant: ButtonVariant.secondary,
                          onPressed: () {
                            context.go(AppRoutes.dashboard);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'TACTIX PRO • ENTERPRISE INCIDENT RESILIENCE PLATFORM',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 9,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
