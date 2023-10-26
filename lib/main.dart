import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/model/weather-model.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final dio = Dio();
  late Position? _currentPosition;
  late WeatherData weatherData;



  Future<void> getWeatherData() async {
    final String url = "https://api.open-meteo.com/v1/forecast?latitude=${_currentPosition?.latitude}&longitude=${_currentPosition?.longitude}&current=temperature_2m,is_day,rain&hourly=temperature_2m,is_day&timezone=auto&forecast_days=1";
    final response = await dio.get(url);
    final WeatherData weatherData = WeatherData.fromJson(response.data);
    setState(() {
      this.weatherData = weatherData;
    });
  }

  Future<void> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
    
    if (_currentPosition != null) {
      await getWeatherData();
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Weather App')),
        body: Image.network('https://picsum.photos/200/300'));
  }

}
