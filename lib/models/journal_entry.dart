import 'package:hive/hive.dart';

part 'journal_entry.g.dart';  // Hive generates this file

@HiveType(typeId: 0)
class JournalEntry {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String text;

  @HiveField(2)
  Mood mood;

  @HiveField(3)  // New field for the image path
  String? imagePath;

  JournalEntry(this.date, this.text, this.mood, this.imagePath);  // Updated constructor
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
