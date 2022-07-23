import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_viewer/shared_preferences_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Example'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SharedPreferencesView(),
                    ),
                  );
                },
                icon: const Icon(Icons.storage),
              )
            ],
          ),
          body: Center(
            child: TextButton(
              onPressed: () async {
                final pref = await SharedPreferences.getInstance();

                pref.setInt('count', 999);
                pref.setString('username', 'John Appleseed');
                pref.setBool('didViewedPolicy', false);
                pref.setDouble('height', 1234.5678);
                pref.setStringList(
                  'staredLanguage',
                  ['Dart', 'Swift', 'Kotlin', 'Objective-C', 'Java'],
                );
              },
              child: const Text('Add some sample datas'),
            ),
          ),
        );
      }),
    );
  }
}
