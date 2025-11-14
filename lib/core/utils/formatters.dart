import 'package:intl/intl.dart';

class Formatters {
  static String currency(double amount, {String locale = 'id_ID'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String date(DateTime date, {String locale = 'id_ID'}) {
    return DateFormat('dd MMM yyyy', locale).format(date);
  }

  static String monthYear(DateTime date, {String locale = 'id_ID'}) {
    return DateFormat('MMMM yyyy', locale).format(date);
  }

  static String shortDate(DateTime date, {String locale = 'id_ID'}) {
    return DateFormat('dd MMM', locale).format(date);
  }
}