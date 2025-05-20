import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todaily/screens/today_screen.dart';
import 'package:todaily/state/now_signal.dart';
import 'package:todaily/state/journal_signal.dart';

Future<void> saveJournalEntry({
  required DateTime date,
  required String title,
  required String description,
  required MoodType mood,
  required List<String> imagePaths,
}) async {
  final Box<Map<String, dynamic>> journalBox = Hive.box('hive_journal');

  final Map<String, dynamic> entry = <String, dynamic>{
    'date': DateFormat('yyyymmdd').format(date),
    'title': title,
    'description': description,
    'mood': mood.toString(),
    'imagePaths': imagePaths,
  };

  await journalBox.add(entry);
}

void updateJournalEntry({
  required String title,
  required String description,
  required MoodType mood,
  required List<String> imagePaths,
}) {
  sJournalEntry.value = <String, dynamic>{
    'date': Now().now.value,
    'title': title,
    'description': description,
    'mood': mood,
    'imagePaths': imagePaths,
  };
}
