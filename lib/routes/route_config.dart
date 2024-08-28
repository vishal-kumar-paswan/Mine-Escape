import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mines/routes/route_constants.dart';
import 'package:mines/screens/home_screen.dart';
import 'package:mines/screens/welcome_screen.dart';
import 'package:mines/utils/navigation_services.dart';

class MinesRoute {
  static final GoRouter routeConfig = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/welcome',
    routes: <RouteBase>[
      GoRoute(
        path: '/welcome',
        name: MinesRouteConstants.welcomeScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/',
        name: MinesRouteConstants.homeScreen,
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],
  );
}
