import 'package:logger/logger.dart';

class EchoLogger {
  EchoLogger._();

  static final Logger _logger = Logger(
      filter: null,
      printer: PrettyPrinter(methodCount: 3, errorMethodCount: 8));

  static const String _tag = "Echo-flutter";

  static String _withTag(dynamic msg) => '$_tag $msg';

  /// debug
  static void d([dynamic msg]) {
    _logger.d(_withTag(msg));
  }

  /// verbose has been replaced with trace
  static void v([dynamic msg]) {
    _logger.t(_withTag(msg));
  }

  /// info
  static void i([dynamic msg]) {
    _logger.i(_withTag(msg));
  }

  /// warning
  static void w([dynamic msg]) {
    _logger.w(_withTag(msg));
  }

  /// error
  static void e([dynamic msg]) {
    _logger.e(_withTag(msg));
  }

  /// fatal
  static void f([dynamic msg]) {
    _logger.f(_withTag(msg));
  }
}

class ExcludeByLevelLogFilter extends LogFilter {
  ExcludeByLevelLogFilter({this.excludedLevels});

  final List<Level>? excludedLevels;

  @override
  bool shouldLog(LogEvent event) =>
      !(excludedLevels?.contains(event.level) ?? false);
}
