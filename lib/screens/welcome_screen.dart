import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mines/routes/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int time = 3;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          --time;
        });
        if (time == 0) {
          timer.cancel();

          // final context = NavigationService.navigatorKey.currentState!.context;

          if (context.mounted) {
            context.goNamed(MinesRouteConstants.homeScreen);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$time',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
