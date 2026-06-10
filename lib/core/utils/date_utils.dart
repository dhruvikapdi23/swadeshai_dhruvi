import 'package:intl/intl.dart';

String formatDisplayDate(DateTime date) {
  return DateFormat('EEE, d MMM yyyy').format(date);
}

String formatApiDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatSlotTime(DateTime dateTime) {
  return DateFormat('h:mm a').format(dateTime);
}

DateTime dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
