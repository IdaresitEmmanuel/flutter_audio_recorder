import 'package:equatable/equatable.dart';

class AudioFile extends Equatable {
  final String title;
  final String path;
  final DateTime createdAt;
  final Duration duration;

  const AudioFile({
    required this.title,
    required this.path,
    required this.createdAt,
    required this.duration,
  });

  @override
  List<Object?> get props => [title, path, createdAt, duration];
}
