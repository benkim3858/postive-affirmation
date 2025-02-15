import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/affirmation_list_screen.dart';
import '../screens/record_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/player_screen.dart';

// 임시 화면들
class AffirmationListScreen extends StatelessWidget {
  const AffirmationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('확언 목록 화면'),
      ),
    );
  }
}

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('녹음 화면'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('설정 화면'),
      ),
    );
  }
}

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/affirmations',
      builder: (context, state) => const AffirmationListScreen(),
    ),
    GoRoute(
      path: '/record',
      builder: (context, state) => const RecordScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) => const PlayerScreen(),
    ),
  ],
);
