// import 'package:audioplayers/audioplayers.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

abstract class IAudioPlayerService {
  Future<bool> play(AudioFile audioFile);
  Future<bool> pause();
  Future<bool> seek(Duration seekDuration);
  Future<bool> stop();
  Stream<Map<String, dynamic>> playbackStatus();
}

class AudioPlayerService extends IAudioPlayerService {
  final AudioPlayer _audioPlayer;
  AudioPlayerService(this._audioPlayer);

  @override
  Future<bool> play(AudioFile audioFile) async {
    final audioSource = AudioSource.uri(Uri.file(audioFile.path));

    final currentAudioSource = _audioPlayer.audioSource;
    final isSameSource =
        currentAudioSource is UriAudioSource &&
        currentAudioSource.uri.path == audioSource.uri.path;

    if (!isSameSource) {
      await _audioPlayer.setAudioSource(audioSource, preload: true);
    }

    await _audioPlayer.play();
    return true;
  }

  @override
  Future<bool> pause() async {
    if (_audioPlayer.audioSource == null) return false;
    await _audioPlayer.pause();
    return true;
  }

  @override
  Future<bool> seek(Duration seekDuration) async {
    await _audioPlayer.seek(seekDuration);
    return true;
  }

  @override
  Future<bool> stop() async {
    await _audioPlayer.stop();
    return true;
  }

  @override
  Stream<Map<String, dynamic>> playbackStatus() {
    String? getFileName() {
      // just_audio does not expose the file path directly in the AudioSource.
      // You may need to manage the filename separately if needed for the UI.
      final audioSource = _audioPlayer.audioSource;
      if (audioSource is UriAudioSource) {
        return audioSource.uri.pathSegments.last;
      }
      return null;
    }

    final stateStream = _audioPlayer.playerStateStream.startWith(
      _audioPlayer.playerState,
    );
    final positionStream = _audioPlayer.positionStream.startWith(Duration.zero);

    return Rx.combineLatest2(stateStream, positionStream, (
      playerState,
      position,
    ) {
      String state;
      // Use a switch on the processingState for more granular control.
      switch (playerState.processingState) {
        case ProcessingState.ready:
        case ProcessingState.buffering:
          state = playerState.playing ? 'playing' : 'paused';
          break;
        case ProcessingState.completed:
        case ProcessingState.idle:
        case ProcessingState.loading:
          state = 'stopped';
          break;
      }
      return {
        'fileName': state == 'stopped' ? '' : getFileName() ?? "",
        'state': state,
        'position': position.inSeconds,
      };
    });
  }
}
