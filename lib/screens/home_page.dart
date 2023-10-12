import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';
import 'new_entry_page.dart';
import 'entry_detail_page.dart';
import 'package:intl/intl.dart';



class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Journal')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<JournalEntry>('journalEntries').listenable(),
        builder: (context, Box<JournalEntry> box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final entry = box.getAt(index);
              if (entry != null) {
                return _buildJournalEntry(context, entry, index);
              } else {
                return SizedBox.shrink();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewEntryPage())),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildJournalEntry(BuildContext context, JournalEntry entry, int index) {
    return Dismissible(
      key: ValueKey(entry.date),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      onDismissed: (direction) {
        Hive.box<JournalEntry>('journalEntries').deleteAt(index);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Entry deleted!")),
        );
      },
      child: ListTile(
        title: Text(DateFormat('MMMM d, y').format(entry.date)), // Display the date as the title
        subtitle: Text(entry.text.length > 40 ? entry.text.substring(0, 40) + '...' : entry.text), // Display a shortened version of the text
        trailing: Icon(_getMoodIcon(entry.mood)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryDetailPage(entry: entry, index: index),
            ),
          );
        },
      ),
    );
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
