import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/core/theme/app_theme.dart';
import 'src/presentation/routes/app_router.dart';

/// Entry point for the Talala booking assistant.
void main() {
  runApp(const ProviderScope(child: TalalaApp()));
}

/// Root widget wiring theming and routing.
class TalalaApp extends ConsumerWidget {
  const TalalaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp(
      title: 'Talala',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      onGenerateRoute: router.onGenerateRoute,
      initialRoute: AppRouter.home,
    );
  }
}
