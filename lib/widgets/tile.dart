import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({super.key, this.color, this.icon, this.blurIcon});
  final Color? color;
  final String? icon;
  final bool? blurIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color ?? Colors.grey.shade700,
      ),
      child: icon == null
          ? const SizedBox()
          : (blurIcon != null ? !blurIcon! : false)
              ? Image.asset(
                  icon!,
                  height: 70,
                  width: 70,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      color!,
                      BlendMode.saturation,
                    ),
                    child: Image.asset(
                      icon!,
                      height: 70,
                      width: 70,
                    ),
                  ),
                ),
    );
  }
}
