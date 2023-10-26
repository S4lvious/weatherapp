import 'package:flutter/material.dart';
import 'package:weatherapp/pages/home_page.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}



