import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../local_storage/storage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static String id = 'mainScreen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('welcome to main screen'),
          TextButton(
            child: Text('print local storage'),
            onPressed: () => print(
              'local storage-> ${Hive.box<Credentials>('credentials').values.map((e) => e.creds).toList()}',
            ),
          ),
        ],
      ),
    );
  }
}
