import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mines/utils/navigation_services.dart';

class DisplayMessage {
  static void toast(String message) {
    final fToast = FToast();
    fToast.init(NavigationService.navigatorKey.currentState!.context);
    final size =
        MediaQuery.of(NavigationService.navigatorKey.currentState!.context)
            .size;
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.redAccent,
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity:
          size.width > 600 ? ToastGravity.BOTTOM_RIGHT : ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2, milliseconds: 500),
    );
  }

  static void dialogBox(BuildContext context, String animation, String message,
      Function resetCallback) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3,
            sigmaY: 3,
          ),
          child: AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            alignment: Alignment.center,
            title: Transform.scale(
              scale: 1.3,
              child: Lottie.asset(
                animation,
                animate: true,
                height: 130,
                width: 130,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  resetCallback();
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(140, 45),
                  backgroundColor: const Color(0xff1FFF20),
                ),
                child: const Text(
                  'RESTART',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
