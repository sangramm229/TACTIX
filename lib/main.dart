import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tactix/core/constants/app_constants.dart';
import 'package:tactix/core/routing/app_router.dart';
import 'package:tactix/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: TactixApp(),
    ),
  );
}

class TactixApp extends ConsumerWidget {
  const TactixApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: '${AppConstants.appName} • ${AppConstants.appTagline}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
