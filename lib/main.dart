import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AffirmationApp(),
    ),
  );
}

class AffirmationApp extends StatelessWidget {
  const AffirmationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: '긍정 확언',
      theme: AppTheme.lightTheme,
    );
  }
}
