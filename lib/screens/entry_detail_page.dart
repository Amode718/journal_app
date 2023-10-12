import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/journal_entry.dart';
import 'package:intl/intl.dart';


class EntryDetailPage extends StatefulWidget {
  final JournalEntry entry;
  final int index;

  EntryDetailPage({required this.entry, required this.index});

  @override
  _EntryDetailPageState createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  late TextEditingController _textController;
  late Mood _selectedMood;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.entry.text);
    _selectedMood = widget.entry.mood;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('MMMM d, y').format(widget.entry.date)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.entry.text),
            SizedBox(height: 20),
            Icon(_getMoodIcon(widget.entry.mood)),
            // Add other details or styles as needed
          ],
        ),
      ),
    );
  }

  void _editEntry() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Entry'),
          content: Column(
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
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _saveUpdatedEntry();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _saveUpdatedEntry() {
    final updatedEntry = JournalEntry(widget.entry.date, _textController.text, _selectedMood);
    Hive.box<JournalEntry>('journalEntries').putAt(widget.index, updatedEntry);

    // Update the local entry and rebuild the widget
    setState(() {
      widget.entry.text = _textController.text;
      widget.entry.mood = _selectedMood;
    });
  }

  IconData _getMoodIcon(Mood mood) {
    switch (mood) {
      case Mood.happy:
        return Icons.sentiment_very_satisfied;
      case Mood.neutral:
        return Icons.sentiment_neutral;
      case Mood.sad:
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }
}
