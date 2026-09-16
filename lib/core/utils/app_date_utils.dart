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
}