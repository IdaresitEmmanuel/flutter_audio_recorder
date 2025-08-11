import 'package:flutter/services.dart';

class PlatformChannels {
  static const methodChannel = MethodChannel(
    'com.hyequest.audiorecorder.methodchannel',
  );
  static const audioRecorderPcmEventChannel = EventChannel(
    'com.hyequest.audiorecorder.recorder_waveform_eventchannel',
  );
  static const audioRecorderStateEventChannel = EventChannel(
    'com.hyequest.audiorecorder.recorder_status_eventchannel',
  );
}
