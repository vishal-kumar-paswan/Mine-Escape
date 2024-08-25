import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    this.color,
    this.icon,
  });
  final Color? color;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? Colors.grey,
      ),
      child: icon == null
          ? const SizedBox()
          : Center(
              child: Image.asset(
                icon!,
                height: 70,
                width: 70,
              ),
            ),
    );
  }
}
