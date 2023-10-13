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
  Sad,
  @HiveField(1)
  Neutral,
  @HiveField(2)
  Happy,
  @HiveField(3)
  Excited,
  @HiveField(4)
  Anxious,
  @HiveField(5)
  Angry
}

