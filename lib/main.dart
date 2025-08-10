import 'dart:async';

import 'package:audiorecorder/core/presentation/app/echo_app.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  await initDependencies();
  runApp(const EchoApp());
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final mc = MethodChannel("com.hyequest.audiorecorder.methodchannel");
  final wc = EventChannel(
    "com.hyequest.audiorecorder.recorder_waveform_eventchannel",
  );
  final sc = EventChannel(
    "com.hyequest.audiorecorder.recorder_status_eventchannel",
  );

  var dataList = <Map<dynamic, dynamic>>[];
  var status = "";
  StreamSubscription? wcSubscription;
  StreamSubscription? scSubscription;
  start() async {
    try {
      listenForWaves();
      listenForStatus();
      await mc.invokeMethod("startRecorder");
    } catch (e) {
      print("o shit: $e");
    }
  }

  listenForWaves() {
    wcSubscription?.cancel();
    print("flutter:: receiveBroadcastStream");
    wcSubscription = wc.receiveBroadcastStream().listen((data) {
      // print("data: $data");
      setState(() {
        dataList.add(data);
      });
    });
  }

  listenForStatus() {
    scSubscription?.cancel();
    print("flutter:: receiveBroadcastStream");
    scSubscription = sc.receiveBroadcastStream().listen((data) {
      // print("data: $data");
      setState(() {
        status = data.toString();
      });
    });
  }

  stop() async {
    await mc.invokeMethod("stopRecorder");
    wcSubscription?.cancel();
    scSubscription?.cancel();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Wrap(children: dataList.map((d) => Text(d.toString())).toList()),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: ListView(
                        children: dataList.isEmpty
                            ? []
                            : [Text(dataList.last.toString())],
                      ),
                    ),
                    Flexible(child: Center(child: Text(status))),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: start, icon: Icon(Icons.mic)),
                  IconButton(
                    onPressed: () {
                      mc.invokeMethod("resumeRecorder");
                    },
                    icon: Icon(Icons.play_arrow),
                  ),
                  IconButton(
                    onPressed: () {
                      mc.invokeMethod("pauseRecorder");
                    },
                    icon: Icon(Icons.pause),
                  ),
                  IconButton(onPressed: stop, icon: Icon(Icons.stop)),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';

// class AudioSaver {
//   final List<double> _samples = [];
//   final int sampleRate;

//   AudioSaver({this.sampleRate = 44100}); // Match Swift AVAudioEngine rate

//   void addSamples(List<double> samples) {
//     _samples.addAll(samples);
//   }

//   Future<File> saveWav(String fileName) async {
//     // Convert doubles (-1.0 to 1.0) to 16-bit PCM
//     final bytes = Int16List(_samples.length);
//     for (int i = 0; i < _samples.length; i++) {
//       double val = _samples[i];
//       if (val > 1.0) val = 1.0;
//       if (val < -1.0) val = -1.0;
//       bytes[i] = (val * 32767).toInt();
//     }

//     // WAV header
//     final byteData = BytesBuilder();
//     int byteRate = sampleRate * 2; // mono, 16-bit
//     int totalDataLen = bytes.length * 2 + 36;

//     // RIFF header
//     byteData.add(asciiEncode("RIFF"));
//     byteData.add(_int32ToBytes(totalDataLen));
//     byteData.add(asciiEncode("WAVE"));

//     // fmt subchunk
//     byteData.add(asciiEncode("fmt "));
//     byteData.add(_int32ToBytes(16)); // PCM header length
//     byteData.add(_int16ToBytes(1)); // PCM format
//     byteData.add(_int16ToBytes(1)); // mono channel
//     byteData.add(_int32ToBytes(sampleRate));
//     byteData.add(_int32ToBytes(byteRate));
//     byteData.add(_int16ToBytes(2)); // block align (2 bytes per sample)
//     byteData.add(_int16ToBytes(16)); // bits per sample

//     // data subchunk
//     byteData.add(asciiEncode("data"));
//     byteData.add(_int32ToBytes(bytes.length * 2));
//     byteData.add(Uint8List.view(bytes.buffer));

//     // Save to file
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/$fileName.wav');
//     await file.writeAsBytes(byteData.toBytes());

//     return file;
//   }

//   List<int> asciiEncode(String text) => text.codeUnits;

//   List<int> _int16ToBytes(int value) => [
//         value & 0xff,
//         (value >> 8) & 0xff,
//       ];

//   List<int> _int32ToBytes(int value) => [
//         value & 0xff,
//         (value >> 8) & 0xff,
//         (value >> 16) & 0xff,
//         (value >> 24) & 0xff,
//       ];
// }
