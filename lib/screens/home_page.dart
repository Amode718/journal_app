import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'all_entries_page.dart';
import '../utils/hive_helper.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather/weather.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {

  final customDarkGrey = Color(0xFF111111); 


  final _journalController = TextEditingController();
  Mood? _selectedMood;
  bool _entryCompleted = false;
  

  Weather? _currentWeather; // store current weather

  WeatherFactory wf = WeatherFactory("684d986fffb94cb5d1cbb2eaa325a9b3", language: Language.ENGLISH);

  

  @override
  void initState() {
    super.initState();
    _loadWeather().then((_) => _checkEntryForToday());
  }


  Future<void> _loadWeather() async {
    Position? position = await _getLocation();
    if (position != null) {
      Weather w = await wf.currentWeatherByLocation(position.latitude, position.longitude);
      setState(() {
        _currentWeather = w;
      });
    }
  }

  Future<void> _checkEntryForToday() async {
    final box = Hive.box<JournalEntry>('journalEntries');
    
    // Get today's date without time
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    bool entryFound = false;

    // Iterate over the entries in the box to find a match for today
    for (var entry in box.values) {
      DateTime entryDate = entry.date;
      DateTime entryDay = DateTime(entryDate.year, entryDate.month, entryDate.day);
      if (entryDay == today) {
        entryFound = true;
        break;
      }
    }

    setState(() {
      _entryCompleted = entryFound;
    });
  }


  

  Future<Position?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;  // Return null when location services are disabled
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;  // Return null when location permissions are denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;  // Return null when location permissions are permanently denied
    }

    return await Geolocator.getCurrentPosition();
}

  Widget _weatherIcon() {
  if (_currentWeather == null) return Container();

  IconData weatherIcon;

  switch (_currentWeather!.weatherMain) {
    case "Rain":
      weatherIcon = FontAwesomeIcons.cloudRain;
      break;
    case "Snow":
      weatherIcon = FontAwesomeIcons.snowflake;
      break;
    case "Clouds":
      weatherIcon = FontAwesomeIcons.cloud;
      break;
    default:
      weatherIcon = FontAwesomeIcons.sun;
      break;
  }

  return Icon(weatherIcon, color: Colors.grey, size: 20);
}

Widget _weatherTemperature() {
  if (_currentWeather == null) return Container();

  double fahrenheitTemp = _currentWeather!.temperature!.celsius! * 9 / 5 + 32;

  return Text(
    "${fahrenheitTemp.round()}°F", // Round the temperature two digits
    style: TextStyle(color: Colors.grey),
  );
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: !_entryCompleted ? AppBar(
      backgroundColor: Colors.black,
      title: Text('Journal', style: TextStyle(color: Colors.grey.shade900, fontFamily: 'Archivo', letterSpacing: 2.0)),
      actions: [
        IconButton(
          icon: Icon(FontAwesomeIcons.book),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllEntriesPage()),
            ).then((value) {
              if (value == true) {
                setState(() {});
              }
            });
          },
        )
      ],
    ) : null,
    body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // This line dismisses the keyboard
      },
      child: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, customDarkGrey],  
                stops: [0.3, 0.3], 
              ),
            ),
          ),
          _entryCompleted ? _buildCompletionScreen() : _buildEntryScreen(),
        ],
      ),
    ),
  );
}


  Widget _buildEntryScreen() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView( 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Column(
              children: [
                SizedBox(height: 5),
                Text(
                  "Today",
                  style: TextStyle(
                    fontFamily: 'YoungSerif',
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MMMM d, y').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    _weatherIcon(),
                    SizedBox(width: 10),
                    _weatherTemperature(),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _journalController,
                  maxLines: 5,
                  style: TextStyle(color: Colors.white,
                  fontFamily: 'YoungSerif',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tap to start journaling...',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "How are you feeling?",
                style: TextStyle(color: Colors.white, 
                fontSize: 24,
                fontFamily: 'Gabarito',
                ),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true, 
            physics: NeverScrollableScrollPhysics(), 
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              // Map each index to a mood and associated icon/label for simplification
              List<Mood> moods = [Mood.Happy, Mood.Neutral, Mood.Sad, Mood.Excited, Mood.Anxious, Mood.Angry];
              List<IconData> icons = [FontAwesomeIcons.smile, FontAwesomeIcons.meh, FontAwesomeIcons.frown, FontAwesomeIcons.grinStars, FontAwesomeIcons.sadTear, FontAwesomeIcons.angry];
              List<String> labels = ["Happy", "Neutral", "Sad", "Excited", "Anxious", "Angry"];
              return _buildMoodBox(moods[index], icons[index], labels[index]);
            },
          ),
          SizedBox(height: 5), // Adjust this height if you want more/less space before the button
          ElevatedButton(
            onPressed: _saveJournal,
            child: Text("Submit"),
          ),
        ],
      ),
    ),
  );
}


Widget _buildMoodBox(Mood mood, IconData icon, String label) {
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedMood = mood;
      });
    },
    child: Container(
      padding: EdgeInsets.all(15), // Increased padding
      decoration: BoxDecoration(
        color: _selectedMood == mood ? Colors.blue.shade700 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 50), // Increased icon size
          SizedBox(height: 10),
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)), // Added text inside the box
        ],
      ),
    ),
  );
}

  void _saveJournal() {
  final journalText = _journalController.text.trim(); // Remove leading/trailing whitespace

  // Check if the journal text is empty or mood is not selected
  if (journalText.isEmpty || _selectedMood == null) {
    // Show a dialog with an error message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Incomplete Entry'),
          content: Text('Please write something in your journal and select a mood before submitting.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  setState(() {
    _entryCompleted = true;
  });

  //print("Journal Text: $journalText");

  //save the journal entry to Hive
  final box = Hive.box<JournalEntry>('journalEntries');
  final entry = JournalEntry(DateTime.now(), journalText, _selectedMood!);
  box.add(entry);

  _journalController.clear(); // Clear the text field

  // Reset mood selection for the next entry
  _selectedMood = null;
}


  Widget _buildCompletionScreen() {
  return Container(
    color: Colors.black, 
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.check, color: Colors.green, size: 100).animate()
          .fadeIn(duration: 1000.ms),
          SizedBox(height: 20),
          Container(
            width: 410,
            child: Text(
              "You have completed the journal entry for today. Come back tomorrow to write more!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 400,
            child: Text(
              "Please go to all entries to either edit or delete it.",
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllEntriesPage()),
              ).then((value) {
                if (value == true) {
                  _checkEntryForToday();
                  setState(() {});
                }
              });
            },
            child: Text("Go to All Entries"),
          ),
        ],
      ),
    ),
  );
}

}


