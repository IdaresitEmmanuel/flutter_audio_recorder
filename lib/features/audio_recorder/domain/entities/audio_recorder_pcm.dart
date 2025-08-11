import 'package:equatable/equatable.dart';

class AudioRecorderPcm extends Equatable {
  final Duration timestamp;
  final List<double> data;
  
  const AudioRecorderPcm({required this.timestamp, required this.data});

  @override
  List<Object?> get props => [timestamp, data];
}
