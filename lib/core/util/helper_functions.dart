import 'package:intl/intl.dart';

String calculateAndFormatDuration(
  Duration recordDuration, [
  bool forecedHour = true,
]) {
  var seconds = recordDuration.inSeconds;

  int hours = (seconds / (60 * 60)).floor();
  int minutes = (seconds / 60).floor();
  int remSeconds = (seconds % 60);

  String hoursText = hours < 10 ? "0$hours" : "$hours";
  String minutesText = minutes < 10 ? "0$minutes" : "$minutes";
  String remSecondsText = remSeconds < 10 ? "0$remSeconds" : "$remSeconds";
  return "${hours == 0 && !forecedHour ? '' : '$hoursText:'}$minutesText:$remSecondsText";
}

String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final difference = today.difference(date).inDays;

    if (difference == 0) {
      // "Today 14:35"
      return 'Today ${DateFormat('HH:mm').format(dateTime)}';
    } else if (difference == 1) {
      // "Yesterday 14:35"
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else if (difference < 7) {
      // "Mon 14:35"
      return DateFormat('E HH:mm').format(dateTime);
    } else if (now.year == dateTime.year) {
      // "Aug 2 14:35"
      return DateFormat('MMM d HH:mm').format(dateTime);
    } else {
      // "5/05/2024"
      return DateFormat('M/dd/yyyy').format(dateTime);
    }
  }