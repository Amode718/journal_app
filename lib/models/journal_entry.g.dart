// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      fields[0] as DateTime,
      fields[1] as String,
      fields[2] as Mood,
      fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.mood)
      ..writeByte(3)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoodAdapter extends TypeAdapter<Mood> {
  @override
  final int typeId = 1;

  @override
  Mood read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Mood.Sad;
      case 1:
        return Mood.Neutral;
      case 2:
        return Mood.Happy;
      case 3:
        return Mood.Excited;
      case 4:
        return Mood.Anxious;
      case 5:
        return Mood.Angry;
      default:
        return Mood.Sad;
    }
  }

  @override
  void write(BinaryWriter writer, Mood obj) {
    switch (obj) {
      case Mood.Sad:
        writer.writeByte(0);
        break;
      case Mood.Neutral:
        writer.writeByte(1);
        break;
      case Mood.Happy:
        writer.writeByte(2);
        break;
      case Mood.Excited:
        writer.writeByte(3);
        break;
      case Mood.Anxious:
        writer.writeByte(4);
        break;
      case Mood.Angry:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
