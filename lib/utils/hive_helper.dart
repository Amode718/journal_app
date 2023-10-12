import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/journal_entry.dart';

class HiveHelper {
  static Future<void> initHive() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(MoodAdapter());
    await Hive.openBox<JournalEntry>('journalEntries');
  }
}
