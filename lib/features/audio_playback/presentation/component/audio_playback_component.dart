import 'package:flutter/material.dart';

class AudioPlaybackComponent extends StatefulWidget {
  const AudioPlaybackComponent({super.key});

  @override
  State<AudioPlaybackComponent> createState() => _AudioPlaybackComponentState();
}

class _AudioPlaybackComponentState extends State<AudioPlaybackComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: Key('audioPlayback'));
  }
}
