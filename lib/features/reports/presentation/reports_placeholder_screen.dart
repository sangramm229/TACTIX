import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/core/theme/app_colors.dart';
import 'package:tactix/core/theme/app_typography.dart';
import 'package:tactix/shared/widgets/app_bar_header.dart';
import 'package:tactix/shared/widgets/tactix_button.dart';

class ReportsPlaceholderScreen extends StatelessWidget {
  final String sessionId;

  const ReportsPlaceholderScreen({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarHeader(
        title: 'AFTER-ACTION REPORT',
        subtitle: 'SESSION ID: $sessionId',
        showBack: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cyan, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.assessment_outlined, color: AppColors.cyan, size: 36),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'AAR & AI EVALUATION SYSTEM',
                style: AppTypography.displayMedium.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 8),
              Text(
                'Phase 9 will render comprehensive Decision Timelines, Communication Reconstruction, Objective Metrics, and AI-grounded performance evaluations.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              TactixButton(
                label: 'RETURN TO COMMAND',
                icon: Icons.dashboard,
                variant: ButtonVariant.secondary,
                onPressed: () => context.go(AppRoutes.dashboard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
