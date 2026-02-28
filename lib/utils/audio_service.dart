import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  Future<void> init(String assetPath) async {
    await _player.setAsset(assetPath);
  }

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();

  Future<void> dispose() => _player.dispose();
}
