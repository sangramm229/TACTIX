import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tactix/core/routing/app_routes.dart';
import 'package:tactix/features/analytics/presentation/history_screen.dart';
import 'package:tactix/features/auth/presentation/login_screen.dart';
import 'package:tactix/features/dashboard/presentation/dashboard_screen.dart';
import 'package:tactix/features/profile/presentation/profile_screen.dart';
import 'package:tactix/features/reports/presentation/report_screen.dart';
import 'package:tactix/features/scenarios/presentation/scenario_detail_screen.dart';
import 'package:tactix/features/scenarios/presentation/scenario_library_screen.dart';
import 'package:tactix/features/simulation/presentation/simulation_screen.dart';
import 'package:tactix/features/splash/presentation/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.scenarios,
        builder: (context, state) => const ScenarioLibraryScreen(),
      ),
      GoRoute(
        path: AppRoutes.scenarioDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'comm_breakdown_01';
          return ScenarioDetailScreen(scenarioId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.simulation,
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId'] ?? 'comm_breakdown_01';
          return SimulationScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: AppRoutes.report,
        builder: (context, state) {
          final sessionId = state.pathParameters['sessionId'] ?? 'unknown_session';
          return ReportScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.uri}'),
      ),
    ),
  );
});
