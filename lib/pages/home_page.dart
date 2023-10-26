import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather-model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatherapp/service/weather_service.dart';
import 'package:weatherapp/widgets/Weather.dart';
import 'package:weatherapp/widgets/background.dart';
import 'package:weatherapp/widgets/hourly_weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  late Future<WeatherData> weatherData;
  late Future<List<Placemark>> placemarks;

  Widget body() => FutureBuilder(
      future: placemarks,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center();
        } else {
          final placemark = snapshot.data!.first;
          return SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
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
                        Expanded(
                          child: FutureBuilder(
                              future: weatherData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  return Column(
                                    children: [
                                      Weather(
                                          temperature2M: snapshot
                                              .data!.current.temperature2M),
                                      Expanded(
                                          child: HourlyWeather(
                                              weatherData: snapshot.data!))
                                    ],
                                  );
                                }
                              }),
                        )
                      ],
                    ),
                  )));
        }
      });

  @override
  void initState() {
    super.initState();
    placemarks = WeatherService.getCurrentLocation();
    weatherData = WeatherService.getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BackgroundWidget(weatherData: weatherData),
        body(),
      ],
    ));
  }
}
