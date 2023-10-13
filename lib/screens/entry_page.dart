import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import 'package:hive/hive.dart';
import '../models/journal_entry.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EntryEditPage extends StatefulWidget {
  final JournalEntry entry;
  final int entryIndex;

  EntryEditPage({required this.entry, required this.entryIndex});

  @override
  _EntryEditPageState createState() => _EntryEditPageState();
}

class _EntryEditPageState extends State<EntryEditPage> {
  late TextEditingController _textController;
  Mood? _selectedMood;

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
        title: Text('Edit Entry'),
        backgroundColor: Colors.grey.shade900,
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white), 
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.save, color: Colors.white),
            onPressed: _saveChanges,
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.trash, color: Colors.white),
            onPressed: _deleteEntry,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade900,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded( // make the TextField take as much space as possible
              child: TextField(
                controller: _textController,
                maxLines: null, // extField to expand vertically
                expands: true,  // TextField occupies the full height
                style: TextStyle(color: Colors.white, fontSize: 18), // Adjust the fontSize
                decoration: InputDecoration(
                  hintText: 'Edit your entry',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none, // No visible border
                  filled: false, // No fill
                  isDense: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: [
                _buildMoodIconButton(Mood.Happy, FontAwesomeIcons.smile),
                _buildMoodIconButton(Mood.Neutral, FontAwesomeIcons.meh),
                _buildMoodIconButton(Mood.Sad, FontAwesomeIcons.frown),
                _buildMoodIconButton(Mood.Excited, FontAwesomeIcons.grinStars),
                _buildMoodIconButton(Mood.Anxious, FontAwesomeIcons.sadTear),
                _buildMoodIconButton(Mood.Angry, FontAwesomeIcons.angry),
              ],
            ),
            SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIconButton(Mood mood, IconData icon) {
    return IconButton(
      icon: Icon(icon, color: _selectedMood == mood ? Colors.blue : Colors.grey),
      onPressed: () {
        setState(() {
          _selectedMood = mood;
        });
      },
    );
  }


   void _saveChanges() {
    final box = Hive.box<JournalEntry>('journalEntries');
    final updatedEntry = JournalEntry(widget.entry.date, _textController.text, _selectedMood!);
    box.putAt(widget.entryIndex, updatedEntry);

    Navigator.pop(context);  // Return to the AllEntriesPage after saving
  }

  void _deleteEntry() async {
  final confirmDelete = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this entry?'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);  // Dismiss dialog and return false
            },
          ),
          ElevatedButton(
            child: Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop(true);  // Dismiss dialog and return true
            },
          ),
        ],
      );
    },
  );

  if (confirmDelete == true) {
    final box = Hive.box<JournalEntry>('journalEntries');
    box.deleteAt(widget.entryIndex);
    Navigator.pop(context);  // Return to the AllEntriesPage after deleting
  }
}

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
