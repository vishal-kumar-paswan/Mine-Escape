import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mines/routes/route_config.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: FToastBuilder(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff0F212E),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      routerConfig: MinesRoute.routeConfig,
    );
  }
}
