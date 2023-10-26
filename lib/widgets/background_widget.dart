import 'package:flutter/material.dart';
import 'package:weatherapp/model/weather_model.dart';

class BackgroundWidget extends StatefulWidget {
  final Future<WeatherData> weatherData;
  const BackgroundWidget({super.key, required this.weatherData});

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.weatherData,
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
  }
}