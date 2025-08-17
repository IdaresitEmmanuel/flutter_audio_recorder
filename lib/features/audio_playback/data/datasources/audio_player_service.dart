import 'package:audioplayers/audioplayers.dart';
import 'package:audiorecorder/features/audio_playback/domain/entity/audio_file.dart';
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
    bool isDisposed = _audioPlayer.state == PlayerState.disposed;
    bool isStopped = _audioPlayer.state == PlayerState.stopped;

    final source = DeviceFileSource(audioFile.path);
    bool isSameSource =
        _audioPlayer.source is DeviceFileSource &&
        (_audioPlayer.source as DeviceFileSource).path == source.path;

    if (!isDisposed && !isStopped && isSameSource) {
      await _audioPlayer.resume();
      return true;
    } else if (!isSameSource || isStopped) {
      await _audioPlayer.play(source);
      return true;
    }
    return false;
  }

  @override
  Future<bool> pause() async {
    bool isDisposed = _audioPlayer.state == PlayerState.disposed;

    if (!isDisposed && _audioPlayer.source != null) {
      await _audioPlayer.pause();
      return true;
    }
    return false;
  }

  @override
  Future<bool> seek(Duration seekDuration) async {
    bool isPlaying = _audioPlayer.state == PlayerState.playing;
    bool isPaused = _audioPlayer.state == PlayerState.paused;
    bool hasFile = isPlaying || isPaused;
    if (hasFile) {
      await _audioPlayer.seek(seekDuration);
      return true;
    }
    return false;
  }

  @override
  Future<bool> stop() async {
    await _audioPlayer.stop();
    return true;
  }

  @override
  Stream<Map<String, dynamic>> playbackStatus() {
    String? getSourceName() {
      if (_audioPlayer.source == null) return null;
      if (_audioPlayer.source is! DeviceFileSource) return null;
      return (_audioPlayer.source as DeviceFileSource).path.split('/').last;
    }

    final stateStream = _audioPlayer.onPlayerStateChanged.startWith(
      PlayerState.stopped,
    );
    final positionStream = _audioPlayer.onPositionChanged.startWith(
      Duration.zero,
    );
    return Rx.combineLatest2(stateStream, positionStream, (state, position) {
      bool isPlaying = state == PlayerState.playing;
      bool isPaused = state == PlayerState.paused;
      return {
        'fileName': getSourceName().toString(),
        'state': isPlaying
            ? 'playing'
            : isPaused
            ? 'paused'
            : 'stopped',
        'position': position.inSeconds,
      };
    });
  }
}
