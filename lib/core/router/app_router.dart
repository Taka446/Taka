import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../presentation/screens/dashboard_screen.dart';
import '../../presentation/screens/goals_screen.dart';
import '../../presentation/screens/assets_screen.dart';
import '../../presentation/screens/events_screen.dart';
import '../../presentation/screens/simulation_screen.dart';
import '../../presentation/screens/import_screen.dart';
import '../../presentation/screens/onboarding_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    if (state.matchedLocation == '/onboarding') return null;
    final prefs = await SharedPreferences.getInstance();
    final done = prefs.getBool('onboarding_done') ?? false;
    if (!done) return '/onboarding';
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/goals', builder: (_, __) => const GoalsScreen()),
        GoRoute(path: '/assets', builder: (_, __) => const AssetsScreen()),
        GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
        GoRoute(path: '/simulation', builder: (_, __) => const SimulationScreen()),
        GoRoute(path: '/import', builder: (_, __) => const ImportScreen()),
      ],
    ),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNav({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _indexFor(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) => context.go(_routes[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.flag), label: '目標'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: '資産'),
          NavigationDestination(icon: Icon(Icons.event), label: 'イベント'),
          NavigationDestination(icon: Icon(Icons.trending_up), label: 'シミュレーション'),
        ],
      ),
    );
  }

  static const _routes = ['/', '/goals', '/assets', '/events', '/simulation'];

  int _indexFor(String location) {
    final i = _routes.indexOf(location);
    return i < 0 ? 0 : i;
  }
}
