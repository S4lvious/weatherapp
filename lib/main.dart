import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/model/weather-model.dart';
import 'package:geocoding/geocoding.dart';

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
  late Future<WeatherData> weatherData;
  late Future<List<Placemark>> placemarks;

  Future<WeatherData> getWeatherData() async {
    final currentPosition = await _getCurrentPosition();
    final String url =
        "https://api.open-meteo.com/v1/forecast?latitude=${currentPosition.latitude}&longitude=${currentPosition.longitude}&current=temperature_2m,is_day,rain&hourly=temperature_2m,is_day&timezone=auto&forecast_days=1";
    final response = await dio.get(url);
    return WeatherData.fromJson(response.data);
  }

  Future<List<Placemark>> getCurrentLocation() async {
    final currentPosition = await _getCurrentPosition();
    final List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    return placemarks;
  }

  Future<Position> _getCurrentPosition() async {
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
    return position;
  }

  Widget backgroundImage() => FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final isRain = snapshot.data!.current.rain;
            final isDay = snapshot.data!.current.isDay;
            final backgroundImage = isRain
                ? 'assets/rain.jpg'
                : isDay
                    ? 'assets/day.jpg'
                    : 'assets/night.jpg';
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black
                        .withOpacity(0.5), // Regola l'opacità del colore
                    BlendMode.darken,
                  ),
                ),
              ),
            );
          }
        },
      );

  Widget body() => FutureBuilder(
      future: placemarks,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center();
        } else {
          final placemark = snapshot.data!.first;
          return SafeArea(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        placemark.locality.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        placemark.country.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      weather(),
                      Expanded(child: hourlyWeather())
                    ],
                  )));
        }
      });

  Widget weather() => FutureBuilder(
        future: weatherData,
        builder: (context, snapshot) => snapshot.connectionState !=
                ConnectionState.done
            ? CircularProgressIndicator()
            : Center(
                child: Text(
                snapshot.data!.current.temperature2M.toString() + "°",
                style:
                    const TextStyle(fontSize: 80, fontWeight: FontWeight.w400),
              )),
      );
/*  
 */
  Widget hourlyWeather() => FutureBuilder(
      future: weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final hourlyData = snapshot.data!.hourly;
          return Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "PREVISIONE ORARIA",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                      width: double.infinity, height: 1, color: Colors.white12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: hourlyData.temperature2M.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          hourlyData.time[index].hour.toString() + ":00",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          hourlyData.temperature2M[index].toString() + "°",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      separatorBuilder: (context, index) => Container(
                          width: double.infinity,
                          height: 1,
                          color: Colors.white12),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      });

  @override
  void initState() {
    super.initState();
    placemarks = getCurrentLocation();
    weatherData = getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        backgroundImage(),
        body(),
      ],
    ));
  }
}
