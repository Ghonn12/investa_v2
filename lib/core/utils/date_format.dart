import 'package:intl/intl.dart';

class AppDateFormat {
  // Format: 23 Nov 2025
  static String mediumDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  // Format: 23 November 2025, 14:30
  static String fullDate(DateTime date) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(date);
  }

  // Format: Senin, 23 Nov
  static String dayDate(DateTime date) {
    return DateFormat('EEEE, dd MMM', 'id_ID').format(date);
  }
}