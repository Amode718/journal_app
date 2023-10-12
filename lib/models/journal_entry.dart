import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String text;

  @HiveField(2)
  Mood mood;

  JournalEntry(this.date, this.text, this.mood);
}

@HiveType(typeId: 1)
enum Mood {
  @HiveField(0)
  sad,
  @HiveField(1)
  neutral,
  @HiveField(2)
  happy
}
