import 'package:intl/intl.dart';

String formatLogTime(String dTime) {
  if (dTime.isEmpty) return '';
  final dateTime = DateTime.parse(dTime);
  final now = DateTime.now();

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return 'Today • ${DateFormat('h:mm a').format(dateTime)}';
  }

  final yesterday = now.subtract(const Duration(days: 1));

  if (dateTime.year == yesterday.year &&
      dateTime.month == yesterday.month &&
      dateTime.day == yesterday.day) {
    return 'Yesterday • ${DateFormat('h:mm a').format(dateTime)}';
  }

  return DateFormat('dd MMM yyyy • h:mm a').format(dateTime);
}
