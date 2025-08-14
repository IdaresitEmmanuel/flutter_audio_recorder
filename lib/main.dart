import 'dart:async';

import 'package:audiorecorder/core/presentation/app/echo_app.dart';
import 'package:audiorecorder/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

var pcmmm = <List<double>>[];
void main() async {
  await initDependencies();
  // debugRepaintRainbowEnabled = true;
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

// Second

 /// Generates the 44-byte WAV header for the audio file.
  // Uint8List _buildWavHeader(int audioDataLength) {
  //   // We assume 1 channel, 16-bit PCM, and a sample rate of 44100 Hz.
  //   const int sampleRate = 44100;
  //   const int numChannels = 1;
  //   const int bitsPerSample = 16;
  //   final int byteRate = sampleRate * numChannels * bitsPerSample ~/ 8;
  //   final int blockAlign = numChannels * bitsPerSample ~/ 8;

  //   final int fileSize = 36 + audioDataLength;
  //   final ByteData header = ByteData(44);

  //   // RIFF chunk descriptor
  //   header.setUint8(0, 'R'.codeUnitAt(0));
  //   header.setUint8(1, 'I'.codeUnitAt(0));
  //   header.setUint8(2, 'F'.codeUnitAt(0));
  //   header.setUint8(3, 'F'.codeUnitAt(0));
  //   header.setUint32(4, fileSize, Endian.little);
  //   header.setUint8(8, 'W'.codeUnitAt(0));
  //   header.setUint8(9, 'A'.codeUnitAt(0));
  //   header.setUint8(10, 'V'.codeUnitAt(0));
  //   header.setUint8(11, 'E'.codeUnitAt(0));

  //   // fmt sub-chunk
  //   header.setUint8(12, 'f'.codeUnitAt(0));
  //   header.setUint8(13, 'm'.codeUnitAt(0));
  //   header.setUint8(14, 't'.codeUnitAt(0));
  //   header.setUint8(15, ' '.codeUnitAt(0));
  //   header.setUint32(16, 16, Endian.little); // Sub-chunk 1 size
  //   header.setUint16(20, 1, Endian.little); // Audio format (1 for PCM)
  //   header.setUint16(22, numChannels, Endian.little);
  //   header.setUint32(24, sampleRate, Endian.little);
  //   header.setUint32(28, byteRate, Endian.little);
  //   header.setUint16(32, blockAlign, Endian.little);
  //   header.setUint16(34, bitsPerSample, Endian.little);

  //   // data sub-chunk
  //   header.setUint8(36, 'd'.codeUnitAt(0));
  //   header.setUint8(37, 'a'.codeUnitAt(0));
  //   header.setUint8(38, 't'.codeUnitAt(0));
  //   header.setUint8(39, 'a'.codeUnitAt(0));
  //   header.setUint32(40, audioDataLength, Endian.little);

  //   return header.buffer.asUint8List();
  // }

  /// This function takes a nested list of audio data,
  /// converts it to a byte array, and writes it to a file.
  // Future<void> writeAudioToFile(List<List<double>> audioData) async {
  //   setState(() {
  //     _statusMessage = 'Writing file...';
  //   });
  //   try {
  //     // 1. Flatten the nested list into a single List of doubles.
  //     final List<double> flattenedData = audioData.expand((list) => list).toList();

  //     // 2. Convert the double data to a 16-bit signed integer format (Int16).
  //     final Int16List int16Data = Int16List(flattenedData.length);
  //     for (int i = 0; i < flattenedData.length; i++) {
  //       double value = flattenedData[i].clamp(-1.0, 1.0);
  //       int16Data[i] = (value * 32767).toInt();
  //     }

  //     // 3. Convert the Int16List to a Uint8List (byte array) for writing.
  //     final Uint8List audioBytes = int16Data.buffer.asUint8List();
      
  //     // 4. Build the WAV header.
  //     final Uint8List headerBytes = _buildWavHeader(audioBytes.length);

  //     // 5. Combine the header and audio data into a single list of bytes.
  //     final Uint8List fullFileBytes = Uint8List.fromList(headerBytes + audioBytes);

  //     // 6. Get a temporary directory to store the file and write the data.
  //     final Directory tempDir = await getTemporaryDirectory();
  //     final String filePath = '${tempDir.path}/$_fileName';
  //     final File file = File(filePath);

  //     await file.writeAsBytes(fullFileBytes);

  //     setState(() {
  //       _statusMessage = 'Successfully wrote file to: $filePath';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _statusMessage = 'Error writing file: $e';
  //     });
  //   }
  // }
// Read and convert the file

  // Future<void> readAudioFromFile() async {
  //   setState(() {
  //     _statusMessage = 'Reading file...';
  //   });
  //   try {
  //     final Directory tempDir = await getTemporaryDirectory();
  //     final String filePath = '${tempDir.path}/$_fileName';
  //     final File file = File(filePath);

  //     if (!await file.exists()) {
  //       setState(() {
  //         _statusMessage = 'File $_fileName does not exist. Please write it first.';
  //       });
  //       return;
  //     }

  //     // 1. Read the file content as a Uint8List.
  //     final Uint8List uint8Data = await file.readAsBytes();

  //     // 2. Interpret the Uint8List as an Int16List.
  //     // The length will be half of the Uint8List's length because each Int16 is 2 bytes.
  //     final Int16List int16Data = uint8Data.buffer.asInt16List();

  //     // 3. Convert the Int16List to a flattened List<double> by scaling the values.
  //     final List<double> flattenedData = int16Data.map((e) => e / 32767.0).toList();

  //     // 4. Re-chunk the flattened data to the original format of List<List<double>>.
  //     // We assume the chunk size is the length of the first list in our sample data.
  //     final int chunkSize = _audioData.first.length;
  //     final List<List<double>> restoredData = [];
  //     for (int i = 0; i < flattenedData.length; i += chunkSize) {
  //       restoredData.add(flattenedData.sublist(i, i + chunkSize));
  //     }

  //     // Check if the restored data matches the original data.
  //     final bool isEqual = _checkListsEqual(_audioData, restoredData);

  //     setState(() {
  //       _statusMessage = 'Successfully read and converted file. Data restored: ${isEqual ? 'matches original' : 'does not match'}.\n'
  //                        'First few restored values: ${restoredData.first.sublist(0, 5)}';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _statusMessage = 'Error reading file: $e';
  //     });
  //   }
  // }

  // bool _checkListsEqual(List<List<double>> list1, List<List<double>> list2) {
  //   if (list1.length != list2.length) return false;
  //   for (int i = 0; i < list1.length; i++) {
  //     if (list1[i].length != list2[i].length) return false;
  //     for (int j = 0; j < list1[i].length; j++) {
  //       // Compare doubles with a small tolerance for floating point errors
  //       if ((list1[i][j] - list2[i][j]).abs() > 0.0001) {
  //         return false;
  //       }
  //     }
  //   }
  //   return true;
  // }