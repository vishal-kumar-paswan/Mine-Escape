import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mines/constants.dart';
import 'package:mines/routes/route_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // int time = 2;

  @override
  void initState() {
    super.initState();

    // Timer.periodic(
    //   const Duration(seconds: 1),
    //   (timer) {
    //     setState(() {
    //       --time;
    //     });
    //     if (time == 0) {
    //       timer.cancel();
    //       if (context.mounted) {
    //         context.goNamed(MinesRouteConstants.homeScreen);
    //       }
    //     }
    //   },
    // );

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (context.mounted) {
          context.goNamed(MinesRouteConstants.homeScreen);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Constants.appIcon,
              width: 250,
            ),
            const SizedBox(height: 15),
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
