import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

Future<void> playBackgroundMusic() async {
  if (!_isPlaying) {
    await _audioPlayer.play(AssetSource('background_music.mp3')); 
    _isPlaying = true;
  }
}
  Future<void> stopBackgroundMusic() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}