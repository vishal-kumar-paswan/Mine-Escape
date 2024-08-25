import 'package:flutter/material.dart';

abstract class ViewTileEvent {}

class ClickTile extends ViewTileEvent {
  final Color color;
  final String icon;
  ClickTile(this.color, this.icon);
}
class ResetTile extends ViewTileEvent {}
