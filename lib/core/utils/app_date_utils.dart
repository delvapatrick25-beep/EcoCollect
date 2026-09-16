import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime date) =>
      DateFormat('dd/MM/yyyy').format(date);

  static String formatTime(DateTime date) => DateFormat('HH:mm').format(date);

  static String formatDateTime(DateTime date) =>
      DateFormat('dd/MM/yyyy HH:mm').format(date);

  static String formatLongDate(DateTime date) =>
      DateFormat.yMMMMEEEEd('fr_FR').format(date);

  /// Ex. : "Mer. 17 sept."
  static String formatShortDate(DateTime date) {
    final weekDay = DateFormat('EEE', 'fr_FR').format(date);
    final day = DateFormat('d').format(date);
    final month = DateFormat.MMM('fr_FR').format(date);
    return '$weekDay $day $month';
  }
}