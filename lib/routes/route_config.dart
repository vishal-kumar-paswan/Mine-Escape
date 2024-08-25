import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mines/screens/home_screen.dart';
import 'package:mines/utils/navigation_services.dart';

class MinesRoute {
  static final GoRouter routeConfig = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}
