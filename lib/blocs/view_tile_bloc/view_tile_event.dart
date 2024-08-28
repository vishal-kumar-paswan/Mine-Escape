import 'package:flutter/material.dart';

abstract class ViewTileEvent {}

class ClickTile extends ViewTileEvent {
  final Color color;
  final String icon;
  bool? blurIcon = false;
  ClickTile({required this.color, required this.icon, this.blurIcon});
}

class ResetTile extends ViewTileEvent {}
