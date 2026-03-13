import 'package:intl/intl.dart';

String formatTanggal(String date) {
  final parsed = DateTime.parse(date);
  return DateFormat('dd MMMM yyyy', 'id_ID').format(parsed);
}