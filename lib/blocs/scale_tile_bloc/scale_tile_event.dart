abstract class ScaleTileEvent {}

class ScaleTile extends ScaleTileEvent {
  final double scale;
  ScaleTile(this.scale);
}