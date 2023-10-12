import 'package:flutter/material.dart';
import 'package:journal_app/utils/hive_helper.dart';
import 'package:journal_app/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
