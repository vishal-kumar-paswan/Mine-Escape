import 'package:audioplayers/audioplayers.dart';

class SoundEffects {
  static final player = AudioPlayer();
  static void play(String audio) async {
    await player.play(AssetSource(audio));
  }
}
