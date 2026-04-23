import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';

class DamkinaShell extends StatelessWidget {
  const DamkinaShell({
    required this.child,
    required this.location,
    super.key,
  });

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        onDestinationSelected: (index) => context.go(_tabs[index].path),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa),
            label: 'Crops',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_on_outlined),
            selectedIcon: Icon(Icons.location_on),
            label: 'Locations',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String location) {
    if (location.startsWith(AppRoutes.locations)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 2;
    }

    return 0;
  }
}

const _tabs = [
  _ShellTab(AppRoutes.crops),
  _ShellTab(AppRoutes.locations),
  _ShellTab(AppRoutes.profile),
];

class _ShellTab {
  const _ShellTab(this.path);

  final String path;
}
