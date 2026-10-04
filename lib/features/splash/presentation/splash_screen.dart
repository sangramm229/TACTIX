import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/constants/app_constants.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/shared/widgets/crystal_background.dart';
import 'package:tactix/shared/widgets/crystal_card.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  Timer? _bootTimer;
  Timer? _navTimer;

  int _bootStep = 0;
  final List<String> _bootLogs = [
    'INITIALIZING TACTIX PRO RESILIENCE CORE...',
    'CONFIGURING TELEMETRY JITTER INJECTORS...',
    'LOADING DEGRADED COMMUNICATION ENGINE...',
    'COMMAND CENTER ONLINE. READY.',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _runBootSequence();
  }

  void _runBootSequence() {
    _bootTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_bootStep < _bootLogs.length - 1) {
        setState(() {
          _bootStep++;
        });
      } else {
        timer.cancel();
        _navTimer = Timer(const Duration(milliseconds: 700), () {
          if (mounted) {
            context.go(AppRoutes.dashboard);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _bootTimer?.cancel();
    _navTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CrystalBackground(
        child: SafeArea(
          child: InkWell(
            onTap: () => context.go(AppRoutes.dashboard),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Pulsing Tactical Radar Icon
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.amber.withValues(alpha: 0.12),
                            border: Border.all(
                              color: AppColors.amber.withValues(alpha: 0.8),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.amber.withValues(alpha: 0.35),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.radar,
                              size: 48,
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // App Title & Tagline
                  Text(
                    AppConstants.appName,
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppConstants.appTagline.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.cyan,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.crystalBorder),
                    ),
                    child: Text(
                      '${AppConstants.productEdition.toUpperCase()} • DEGRADED COMM SIMULATOR',
                      style: AppTypography.monoSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 9,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Frosted Crystal Boot log display
                  CrystalCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.cyan,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'SYSTEM INITIALIZATION',
                              style: AppTypography.monoSmall.copyWith(
                                color: AppColors.cyan,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '> ${_bootLogs[_bootStep]}',
                          style: AppTypography.monoSmall.copyWith(
                            color: _bootStep == _bootLogs.length - 1
                                ? AppColors.emerald
                                : AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'TAP ANYWHERE TO BYPASS',
                    style: AppTypography.monoSmall.copyWith(
                      color: AppColors.textTertiary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
