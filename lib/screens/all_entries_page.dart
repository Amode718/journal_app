import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'entry_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AllEntriesPage extends StatefulWidget {
  @override
  _AllEntriesPageState createState() => _AllEntriesPageState();
}

class _AllEntriesPageState extends State<AllEntriesPage> {

   String truncateEntry(String text, int cutoff) {
    return (text.length <= cutoff) ? text : text.substring(0, cutoff) + '...';
  }

  late Box<JournalEntry> _box;

  // Define IconData for each mood
  final Map<Mood, IconData> moodIcons = {
  Mood.Happy: FontAwesomeIcons.smile,
  Mood.Neutral: FontAwesomeIcons.meh,
  Mood.Sad: FontAwesomeIcons.frown,
  Mood.Excited: FontAwesomeIcons.grinStars,  
  Mood.Anxious: FontAwesomeIcons.sadTear,    
  Mood.Angry: FontAwesomeIcons.angry
  };

  @override
  void initState() {
    super.initState();
    _box = Hive.box<JournalEntry>('journalEntries');
    //print("Number of entries: ${_box.length}");
  }

  void _deleteEntry(int index) {
    _box.deleteAt(index);
    setState(() {});
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('All Entries'),
      backgroundColor: Colors.grey.shade900,
      leading: IconButton(
          icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white), 
          onPressed: () {
            Navigator.pop(context, true); 
          },
        ),
    ),
    body: Container(
      color: Colors.grey.shade900,
      child: ListView.separated(
        itemCount: _box.length,
        separatorBuilder: (context, index) => Divider(color: Colors.grey.shade800),
        itemBuilder: (context, index) {
          final entry = _box.getAt(index);
          return Dismissible(
            key: Key(entry!.date.toIso8601String()),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  FontAwesomeIcons.trash,
                  color: Colors.white,
                ),
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete this entry?'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      ElevatedButton(
                        child: Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (direction) {
              _deleteEntry(index);
            },
              child: ListTile(
                title: Text(
                  DateFormat('MMMM d, y').format(entry.date),
                  style: TextStyle(
                    color: Colors.white, // Date text color (white)
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        truncateEntry(entry.text, 50),  // Truncate the text to 30 characters
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis, // Overflow handling
                        maxLines: 1,  // Limit to 1 line
                      ),
                    ),
                    SizedBox(width: 10),  // Spacing between the text and the icon
                    Icon(
                      moodIcons[entry.mood]!,
                      color: Colors.blue,
                    ),
                  ],
                ),
                onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => EntryEditPage(entry: entry, entryIndex: index),
                        ),
                    ).then((value) {
                        setState(() {});  // Refresh the AllEntriesPage when you return from the EntryEditPage
                    });
                    },
              ),
            );
          },
        ),
      ),
    );
  }
}
