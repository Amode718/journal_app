import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/journal_entry.dart';

class NewEntryPage extends StatefulWidget {
  @override
  _NewEntryPageState createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController _textController;  // Use 'late' here
  late Mood _selectedMood;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _selectedMood = Mood.neutral;  // Default mood
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Entry Text'),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            DropdownButton<Mood>(
              value: _selectedMood,
              onChanged: (Mood? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedMood = newValue;
                  });
                }
              },
              items: Mood.values.map((Mood mood) {
                return DropdownMenuItem<Mood>(
                  value: mood,
                  child: Text(mood.toString().split('.').last),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              child: Text('Save Entry'),
            )
          ],
        ),
      ),
    );
  }

  void _saveEntry() {
    final newEntry = JournalEntry(DateTime.now(), _textController.text, _selectedMood);
    Hive.box<JournalEntry>('journalEntries').add(newEntry);
    Navigator.pop(context);  // Return to the HomePage after saving
  }
}
