import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat timeFormat = DateFormat('HH:mm:ss');
  static final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  static String formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatPercentage(double ratio) {
    return '${(ratio * 100).toStringAsFixed(0)}%';
  }

  static String formatTimestamp(DateTime dt) {
    return timeFormat.format(dt);
  }
}
