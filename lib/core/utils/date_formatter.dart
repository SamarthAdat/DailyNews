import 'package:intl/intl.dart';

abstract final class DateFormatter {
  static final _shortDate = DateFormat('d MMM y');
  static final _longDay = DateFormat('EEEE, d MMMM');

  static String relative(DateTime date, {DateTime? now}) {
    final local = date.toLocal();
    final difference = (now ?? DateTime.now()).difference(local);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return _shortDate.format(local);
  }

  static String longDay(DateTime date) => _longDay.format(date);
}
