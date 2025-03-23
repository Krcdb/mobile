import 'package:intl/intl.dart';

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat dateFormat = DateFormat('dd/MM');
  return dateFormat.format(dateTime);
}