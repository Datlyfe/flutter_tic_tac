import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  AudioPlayer _fixedPlayer;
  AudioCache _player;

  SoundService() {
    _fixedPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
    _player = AudioCache(fixedPlayer: _fixedPlayer);
    _player.loadAll(['x.mp3', 'o.mp3', "click.mp3"]);
  }

  playXSound() {
    _player.play("x.mp3");
  }

  playOSound() {
    _player.play("o.mp3");
  }

  playClickSound() {
    _player.play("click.mp3");
  }
}
