import 'package:flutter/foundation.dart';
import '../models/journal_entry.dart';


class JournalProvider with ChangeNotifier {
  List<JournalEntry> _entries = [];

  List<JournalEntry> get entries => _entries;

  void addEntry(JournalEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }
}
